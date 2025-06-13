package electricity

import (
	"MCM/database"
	confing "MCM/database/config"
	model "MCM/database/electricity"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"strconv"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/get-electricity", getElectricity)
	r.POST("/update-electricity", updateElectricity)
}

// get-electricity

type GetElectricityIn struct {
	UserId int `json:"userId" binding:"required"`
	Year   int `json:"year" binding:"required"`
}

type GetElectricityOut map[string]Data

type Data struct {
	ElectricityConsumption float64 `json:"electricityConsumption"`
	Value                  float64 `json:"value"`
}

func getElectricity(c *gin.Context) {
	var input GetElectricityIn
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

	var electricityConfig confing.ElectricityConfig
	if db.First(&electricityConfig, "year = ?", input.Year).Error != nil {
		util.FailedResponse(c, 3, "電費設定 不存在")
		return
	}

	var gwpElectric = gwpConfig.GWPElectric
	var coefficient = electricityConfig.Coefficient

	electricity := getElectricityData(db, input.UserId, input.Year)

	var output = make(GetElectricityOut)
	var monthKeys = util.MonthKeys

	for i := 0; i < 12; i++ {
		var electricityConsumption = electricity[i].ElectricityConsumption
		var value = electricityConsumption * gwpElectric * coefficient

		output[monthKeys[i]] = Data{
			ElectricityConsumption: electricityConsumption,
			Value:                  value,
		}
	}

	util.SuccessResponse(c, output)
}

func getElectricityData(db *gorm.DB, userId int, year int) []model.Electricity {
	var existingElectricity []model.Electricity
	db.Where("user_id = ? AND year = ?", userId, year).Find(&existingElectricity)

	electricityMap := make(map[int]model.Electricity)
	for _, e := range existingElectricity {
		electricityMap[e.Month] = e
	}

	var result []model.Electricity
	for month := 1; month <= 12; month++ {
		if e, exists := electricityMap[month]; exists {
			result = append(result, e)
		} else {
			newElectricity := model.Electricity{
				UserId:                 userId,
				Year:                   year,
				Month:                  month,
				ElectricityConsumption: 0,
			}
			db.Create(&newElectricity)
			result = append(result, newElectricity)
		}
	}

	return result
}

// update-electricity

type UpdateElectricityIn struct {
	UserId                 int      `json:"userId" binding:"required"`
	Year                   int      `json:"year" binding:"required"`
	Month                  int      `json:"month" binding:"required"`
	ElectricityConsumption *float64 `json:"electricityConsumption" binding:"required"`
}

func updateElectricity(c *gin.Context) {
	var input UpdateElectricityIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	var electricity model.Electricity
	if db.Where("user_id = ? AND year = ? AND month = ?", input.UserId, input.Year, input.Month).First(&electricity).Error != nil {
		util.FailedResponse(c, 1, "此資料不存在")
		return
	}

	// 保存修改後的數據
	electricity.ElectricityConsumption = *input.ElectricityConsumption

	if err := db.Save(&electricity).Error; err != nil {
		util.FailedResponse(c, 2, "更新失敗")
		return
	}

	// 返回成功響應
	util.SuccessResponse(c)
}
