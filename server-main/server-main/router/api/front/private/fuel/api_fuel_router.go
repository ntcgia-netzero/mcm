package fuel

import (
	"MCM/database"
	confing "MCM/database/config"
	model "MCM/database/fuel"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"strconv"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/get-fuel", getFuel)
	r.POST("/update-fuel", updateFuel)
}

// get-fuel

type GetFuelIn struct {
	UserId int `json:"userId" binding:"required"`
	Year   int `json:"year" binding:"required"`
}

type GetFuelOut map[string]Data

type Data struct {
	Gasoline      float64 `json:"gasoline"`
	Diesel        float64 `json:"diesel"`
	GasolineValue float64 `json:"gasolineValue"`
	DieselValue   float64 `json:"dieselValue"`
}

func getFuel(c *gin.Context) {
	var input GetFuelIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	var gwpConfig confing.GWPConfig
	if db.First(&gwpConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 2, "GWP設定 不存在")
		return
	}

	var fuelConfig confing.FuelConfig
	if db.First(&fuelConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 3, "燃料設定 不存在")
		return
	}

	fuel := getFuelData(db, input.UserId, input.Year)

	var output = make(GetFuelOut)
	var monthKeys = util.MonthKeys

	var gasolineCO2EmissionCoefficient = fuelConfig.GasolineCO2EmissionCoefficient
	var gasolineCH4EmissionCoefficient = fuelConfig.GasolineCH4EmissionCoefficient
	var gasolineN2OEmissionCoefficient = fuelConfig.GasolineN2OEmissionCoefficient
	var dieselCO2EmissionCoefficient = fuelConfig.DieselCO2EmissionCoefficient
	var dieselCH4EmissionCoefficient = fuelConfig.DieselCH4EmissionCoefficient
	var dieselN2OEmissionCoefficient = fuelConfig.DieselN2OEmissionCoefficient
	var gwpCH4 = gwpConfig.GWPCH4
	var gwpCO2 = gwpConfig.GWPCO2
	var gwpN2O = gwpConfig.GWPN2O

	for i := 0; i < 12; i++ {
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

		var gasolineValue = gasolineCO2 + gasolineCH4 + gasolineN2O
		var dieselValue = dieselCO2 + dieselCH4 + dieselN2O

		output[monthKeys[i]] = Data{
			Gasoline:      gasoline,
			Diesel:        diesel,
			GasolineValue: gasolineValue,
			DieselValue:   dieselValue,
		}
	}

	util.SuccessResponse(c, output)
}

func getFuelData(db *gorm.DB, userId int, year int) []model.Fuel {
	var existingElectricity []model.Fuel
	db.Where("user_id = ? AND year = ?", userId, year).Find(&existingElectricity)

	electricityMap := make(map[int]model.Fuel)
	for _, e := range existingElectricity {
		electricityMap[e.Month] = e
	}

	var result []model.Fuel
	for month := 1; month <= 12; month++ {
		if e, exists := electricityMap[month]; exists {
			result = append(result, e)
		} else {
			newElectricity := model.Fuel{
				UserId:   userId,
				Year:     year,
				Month:    month,
				Gasoline: 0,
				Diesel:   0,
			}
			db.Create(&newElectricity)
			result = append(result, newElectricity)
		}
	}

	return result
}

// update-fuel

type UpdateFuelIn struct {
	UserId   int      `json:"userId" binding:"required"`
	Year     int      `json:"year" binding:"required"`
	Month    int      `json:"month" binding:"required"`
	Gasoline *float64 `json:"gasoline" binding:"required"`
	Diesel   *float64 `json:"diesel" binding:"required"`
}

func updateFuel(c *gin.Context) {
	var input UpdateFuelIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	var employee model.Fuel
	if db.Where("user_id = ? AND year = ? AND month = ?", input.UserId, input.Year, input.Month).First(&employee).Error != nil {
		util.FailedResponse(c, 1, "此資料不存在")
		return
	}

	// 保存修改後的數據
	employee.Gasoline = *input.Gasoline
	employee.Diesel = *input.Diesel

	if err := db.Save(&employee).Error; err != nil {
		util.FailedResponse(c, 2, "更新失敗")
		return
	}

	// 返回成功響應
	util.SuccessResponse(c)
}
