package employee

import (
	"MCM/database"
	confing "MCM/database/config"
	model "MCM/database/employee"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"strconv"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/get-employee", getEmployee)
	r.POST("/update-employee", updateEmployee)
}

// get-employee

type GetEmployeeIn struct {
	UserId int `json:"userId" binding:"required"`
	Year   int `json:"year" binding:"required"`
}

type GetEmployeeOut map[string]Data

type Data struct {
	EmployeesCount      int     `json:"employeesCount"`
	WorkingHoursPerDay  float64 `json:"workingHoursPerDay"`
	WorkingDaysPerMonth float64 `json:"workingDaysPerMonth"`
	Value               float64 `json:"value"`
}

func getEmployee(c *gin.Context) {
	var input GetEmployeeIn
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

	var employeeConfig confing.EmployeeConfig
	if db.First(&employeeConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 3, "員工設定 不存在")
		return
	}

	employee := getEmployeeData(db, input.UserId, input.Year)

	var output = make(GetEmployeeOut)
	var monthKeys = util.MonthKeys

	var wasteWaterVolume = employeeConfig.WastewaterVolume
	var emissionFactor = employeeConfig.EmissionFactor
	var sewageConcentration = employeeConfig.SewageConcentration
	var septicTankEfficiency = employeeConfig.SepticTankEfficiency
	var conversion = employeeConfig.Conversion
	var gwpCH4 = gwpConfig.GWPCH4

	for i := 0; i < 12; i++ {
		var employeeCount = employee[i].EmployeesCount
		var workingHoursPerDay = employee[i].WorkingHoursPerDay
		var workingDaysPerMonth = employee[i].WorkingDaysPerMonth

		var value = float64(employeeCount)
		value *= workingHoursPerDay
		value *= workingDaysPerMonth
		value *= wasteWaterVolume
		value *= emissionFactor
		value *= sewageConcentration
		value *= septicTankEfficiency
		value *= conversion
		value *= gwpCH4

		output[monthKeys[i]] = Data{
			EmployeesCount:      employeeCount,
			WorkingHoursPerDay:  workingHoursPerDay,
			WorkingDaysPerMonth: workingDaysPerMonth,
			Value:               value,
		}
	}

	util.SuccessResponse(c, output)
}

func getEmployeeData(db *gorm.DB, userId int, year int) []model.Employee {
	var existingElectricity []model.Employee
	db.Where("user_id = ? AND year = ?", userId, year).Find(&existingElectricity)

	electricityMap := make(map[int]model.Employee)
	for _, e := range existingElectricity {
		electricityMap[e.Month] = e
	}

	var result []model.Employee
	for month := 1; month <= 12; month++ {
		if e, exists := electricityMap[month]; exists {
			result = append(result, e)
		} else {
			newElectricity := model.Employee{
				UserId:              userId,
				Year:                year,
				Month:               month,
				EmployeesCount:      0,
				WorkingHoursPerDay:  0,
				WorkingDaysPerMonth: 0,
			}
			db.Create(&newElectricity)
			result = append(result, newElectricity)
		}
	}

	return result
}

// update-employee

type UpdateEmployeeIn struct {
	UserId              int      `json:"userId" binding:"required"`
	Year                int      `json:"year" binding:"required"`
	Month               int      `json:"month" binding:"required"`
	EmployeesCount      *int     `json:"employeesCount" binding:"required"`
	WorkingHoursPerDay  *float64 `json:"workingHoursPerDay" binding:"required"`
	WorkingDaysPerMonth *float64 `json:"workingDaysPerMonth" binding:"required"`
}

func updateEmployee(c *gin.Context) {
	var input UpdateEmployeeIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	var employee model.Employee
	if db.Where("user_id = ? AND year = ? AND month = ?", input.UserId, input.Year, input.Month).First(&employee).Error != nil {
		util.FailedResponse(c, 1, "此資料不存在")
		return
	}

	// 保存修改後的數據
	employee.EmployeesCount = *input.EmployeesCount
	employee.WorkingHoursPerDay = *input.WorkingHoursPerDay
	employee.WorkingDaysPerMonth = *input.WorkingDaysPerMonth

	if err := db.Save(&employee).Error; err != nil {
		util.FailedResponse(c, 2, "更新失敗")
		return
	}

	// 返回成功響應
	util.SuccessResponse(c)
}
