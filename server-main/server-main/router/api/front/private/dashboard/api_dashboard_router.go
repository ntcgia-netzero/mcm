package dashboard

import (
	"MCM/database"
	confing "MCM/database/config"
	electricityModel "MCM/database/electricity"
	employeeModel "MCM/database/employee"
	fuelModel "MCM/database/fuel"
	refrigerantModel "MCM/database/refrigerant"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
	"strconv"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/get-data", getData)
}

// get-data

type GetDataIn struct {
	UserId int `json:"userId" binding:"required"`
	Year   int `json:"year" binding:"required"`
}

type GetDataOut struct {
	Electricity float64 `json:"electricity"`
	Employee    float64 `json:"employee"`
	Gasoline    float64 `json:"gasoline"`
	Diesel      float64 `json:"diesel"`
	Refrigerant float64 `json:"refrigerant"`
}

func getData(c *gin.Context) {
	var input GetDataIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		util.FailedResponse(c, 1, "用戶不存在")
		return
	}

	var output GetDataOut

	var db = database.Connect()
	defer database.Close(db)

	var gwpConfig confing.GWPConfig
	if db.First(&gwpConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 2, "GWP設定 不存在")
		return
	}

	var gwpElectric = gwpConfig.GWPElectric
	var gwpCH4 = gwpConfig.GWPCH4
	var gwpCO2 = gwpConfig.GWPCO2
	var gwpN2O = gwpConfig.GWPN2O

	// electricity
	var electricityConfig confing.ElectricityConfig
	if db.First(&electricityConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 3, "電費設定 不存在")
		return
	}

	var electricity []electricityModel.Electricity
	if db.Find(&electricity, "user_id = ? AND year = ?", input.UserId, input.Year).Error != nil {
		util.FailedResponse(c, 4, "電費 不存在")
		return
	}
	var coefficient = electricityConfig.Coefficient

	for i := 0; i < len(electricity); i++ {
		var electricityConsumption = electricity[i].ElectricityConsumption

		var result = electricityConsumption
		result *= coefficient
		result *= gwpElectric
		output.Electricity += result
	}

	output.Electricity *= 0.001

	// employee
	var employeeConfig confing.EmployeeConfig
	if db.First(&employeeConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 5, "員工設定 不存在")
		return
	}

	var wasteWaterVolume = employeeConfig.WastewaterVolume
	var emissionFactor = employeeConfig.EmissionFactor
	var sewageConcentration = employeeConfig.SewageConcentration
	var septicTankEfficiency = employeeConfig.SepticTankEfficiency
	var conversion = employeeConfig.Conversion

	var employee []employeeModel.Employee
	if db.Find(&employee, "user_id = ? AND year = ?", input.UserId, input.Year).Error != nil {
		util.FailedResponse(c, 6, "員工 不存在")
		return
	}

	for i := 0; i < len(employee); i++ {
		var employeeCount = employee[i].EmployeesCount
		var workingHoursPerDay = employee[i].WorkingHoursPerDay
		var workingDaysPerMonth = employee[i].WorkingDaysPerMonth

		var result = float64(employeeCount)
		result *= workingHoursPerDay
		result *= workingDaysPerMonth
		result *= wasteWaterVolume
		result *= emissionFactor
		result *= sewageConcentration
		result *= septicTankEfficiency
		result *= conversion
		result *= gwpCH4

		output.Employee += result
	}

	output.Employee *= 0.001

	// fuel
	var fuelConfig confing.FuelConfig
	if db.First(&fuelConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 7, "燃料設定 不存在")
		return
	}

	var gasolineCO2EmissionCoefficient = fuelConfig.GasolineCO2EmissionCoefficient
	var gasolineCH4EmissionCoefficient = fuelConfig.GasolineCH4EmissionCoefficient
	var gasolineN2OEmissionCoefficient = fuelConfig.GasolineN2OEmissionCoefficient
	var dieselCO2EmissionCoefficient = fuelConfig.DieselCO2EmissionCoefficient
	var dieselCH4EmissionCoefficient = fuelConfig.DieselCH4EmissionCoefficient
	var dieselN2OEmissionCoefficient = fuelConfig.DieselN2OEmissionCoefficient

	var fuel []fuelModel.Fuel
	if db.Find(&fuel, "user_id = ? AND year = ?", input.UserId, input.Year).Error != nil {
		util.FailedResponse(c, 8, "燃料 不存在")
		return
	}

	for i := 0; i < len(fuel); i++ {
		var gasoline = fuel[i].Gasoline
		var diesel = fuel[i].Diesel

		var gasolineCO2 = gasoline
		gasolineCO2 *= gasolineCO2EmissionCoefficient
		gasolineCO2 *= gwpCO2

		var gasolineCH4 = gasoline
		gasolineCH4 *= gasolineCH4EmissionCoefficient
		gasolineCH4 *= gwpCH4

		var gasolineN2O = gasoline
		gasolineN2O *= gasolineN2OEmissionCoefficient
		gasolineN2O *= gwpN2O

		var dieselCO2 = diesel
		dieselCO2 *= dieselCO2EmissionCoefficient
		dieselCO2 *= gwpCO2

		var dieselCH4 = diesel
		dieselCH4 *= dieselCH4EmissionCoefficient
		dieselCH4 *= gwpCH4

		var dieselN2O = diesel
		dieselN2O *= dieselN2OEmissionCoefficient
		dieselN2O *= gwpN2O

		output.Gasoline += gasolineCO2 + gasolineCH4 + gasolineN2O
		output.Diesel += dieselCO2 + dieselCH4 + dieselN2O
	}

	output.Gasoline *= 0.001
	output.Diesel *= 0.001

	//refrigerant
	var results []struct {
		refrigerantModel.Refrigerant
		EquipmentEscapeRate float64 `gorm:"column:equipment_escape_rate"`
		RefrigerantGWP      float64 `gorm:"column:refrigerant_gwp"`
	}

	if db.Table("refrigerants").
		Select("refrigerants.*, device_type_configs.equipment_escape_rate, refrigerant_type_configs.refrigerant_gwp").
		Joins("left join device_type_configs on refrigerants.year = device_type_configs.year and refrigerants.device_type = device_type_configs.device_type_id").
		Joins("left join refrigerant_type_configs on refrigerants.year = refrigerant_type_configs.year and refrigerants.refrigerant_type = refrigerant_type_configs.refrigerant_type_id").
		Where("refrigerants.user_id = ? AND refrigerants.year = ?", input.UserId, input.Year).
		Scan(&results).Error != nil {
		util.FailedResponse(c, 9, "冷媒 不存在")
		return
	}

	for i := 0; i < len(results); i++ {
		var refrigerant = results[i].Refrigerant
		var equipmentEscapeRate = results[i].EquipmentEscapeRate
		var refrigerantGWP = results[i].RefrigerantGWP

		var result = float64(refrigerant.Count)
		result *= refrigerant.RefrigerantSupplement
		result *= float64(refrigerant.UseMonth)
		result *= equipmentEscapeRate
		result *= refrigerantGWP

		output.Refrigerant += result
	}

	output.Refrigerant *= 0.001

	util.SuccessResponse(c, output)
}
