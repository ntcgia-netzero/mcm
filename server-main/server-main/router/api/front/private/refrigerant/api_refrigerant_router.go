package refrigerant

import (
	"MCM/database"
	model "MCM/database/refrigerant"
	"MCM/database/types"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
	"strconv"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/get-refrigerant", getRefrigerant)
	r.POST("/create-refrigerant", createRefrigerant)
	r.POST("/update-refrigerant", updateRefrigerant)
}

// get-refrigerant

type GetRefrigerantIn struct {
	UserId int `json:"userId" binding:"required"`
	Year   int `json:"year" binding:"required"`
}

type GetRefrigerantOut []Data

type Data struct {
	Id                    int     `json:"id"`
	Name                  string  `json:"name"`
	Count                 int     `json:"count"`
	UseMonth              int     `json:"useMonth"`
	RefrigerantSupplement float64 `json:"refrigerantSupplement"`
	RefrigerantType       int     `json:"refrigerantType"`
	DeviceType            int     `json:"deviceType"`
	Value                 float64 `json:"value"`
}

func getRefrigerant(c *gin.Context) {
	var input GetRefrigerantIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		util.FailedResponse(c, 1, "用戶不存在")
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	var results []struct {
		model.Refrigerant
		EquipmentEscapeRate float64 `gorm:"column:equipment_escape_rate"`
		RefrigerantGWP      float64 `gorm:"column:refrigerant_gwp"`
	}

	var output GetRefrigerantOut
	output = []Data{}

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

		var value = float64(refrigerant.Count)
		value *= refrigerant.RefrigerantSupplement
		value *= float64(refrigerant.UseMonth)
		value *= equipmentEscapeRate
		value *= refrigerantGWP

		print("Name: ", refrigerant.Name, "\n")
		print("Count: ", refrigerant.Count, "\n")
		print("RefrigerantSupplement: ", refrigerant.RefrigerantSupplement, "\n")
		print("UseMonth: ", refrigerant.UseMonth, "\n")
		print("equipmentEscapeRate: ", equipmentEscapeRate, "\n")
		print("refrigerantGWP: ", refrigerantGWP, "\n")

		output = append(output, Data{
			Id:                    int(refrigerant.ID),
			Name:                  refrigerant.Name,
			Count:                 refrigerant.Count,
			UseMonth:              refrigerant.UseMonth,
			RefrigerantSupplement: refrigerant.RefrigerantSupplement,
			RefrigerantType:       refrigerant.RefrigerantType,
			DeviceType:            refrigerant.DeviceType,
			Value:                 value,
		})
	}

	util.SuccessResponse(c, output)
}

// create-refrigerant

type CreateRefrigerantIn struct {
	UserId                int      `json:"userId" binding:"required"`
	Year                  int      `json:"year" binding:"required"`
	Name                  string   `json:"name" binding:"required"`
	Count                 *int     `json:"count" binding:"required"`
	UseMonth              *int     `json:"useMonth" binding:"required"`
	RefrigerantSupplement *float64 `json:"refrigerantSupplement" binding:"required"`
	RefrigerantType       int      `json:"refrigerantType" binding:"required"`
	DeviceType            int      `json:"deviceType" binding:"required"`
}

func createRefrigerant(c *gin.Context) {
	var input CreateRefrigerantIn
	if err := c.ShouldBindJSON(&input); err != nil {
		println(err.Error())
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	if db.First(&types.DeviceType{}, input.DeviceType).Error != nil {
		util.FailedResponse(c, 2, "DeviceType 不存在")
		return
	}

	if db.First(&types.RefrigerantType{}, input.RefrigerantType).Error != nil {
		util.FailedResponse(c, 3, "RefrigerantType 不存在")
		return
	}

	newRefrigerant := model.Refrigerant{}
	newRefrigerant.UserId = input.UserId
	newRefrigerant.Year = input.Year
	newRefrigerant.Name = input.Name
	newRefrigerant.Count = *input.Count
	newRefrigerant.UseMonth = *input.UseMonth
	newRefrigerant.RefrigerantSupplement = *input.RefrigerantSupplement
	newRefrigerant.RefrigerantType = input.RefrigerantType
	newRefrigerant.DeviceType = input.DeviceType

	if db.Create(&newRefrigerant).Error != nil {
		util.FailedResponse(c, 4, "無法創建新資料")
		return
	}

	util.SuccessResponse(c)
}

// update-refrigerant

type UpdateRefrigerantIn struct {
	Id                    int      `json:"Id" binding:"required"`
	UserId                int      `json:"userId" binding:"required"`
	Name                  string   `json:"name" binding:"required"`
	Count                 *int     `json:"count" binding:"required"`
	UseMonth              *int     `json:"useMonth" binding:"required"`
	RefrigerantSupplement *float64 `json:"refrigerantSupplement" binding:"required"`
	RefrigerantType       int      `json:"refrigerantType" binding:"required"`
	DeviceType            int      `json:"deviceType" binding:"required"`
}

func updateRefrigerant(c *gin.Context) {
	var input UpdateRefrigerantIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	if db.First(&types.DeviceType{}, input.DeviceType).Error != nil {
		util.FailedResponse(c, 2, "DeviceType 不存在")
		return
	}

	if db.First(&types.RefrigerantType{}, input.RefrigerantType).Error != nil {
		util.FailedResponse(c, 3, "RefrigerantType 不存在")
		return
	}

	var refrigerant model.Refrigerant
	if db.First(&refrigerant, input.Id).Error != nil {
		util.FailedResponse(c, 4, "此資料不存在")
		return
	}

	// 保存修改後的數據
	refrigerant.Name = input.Name
	refrigerant.Count = *input.Count
	refrigerant.UseMonth = *input.UseMonth
	refrigerant.RefrigerantSupplement = *input.RefrigerantSupplement
	refrigerant.RefrigerantType = input.RefrigerantType
	refrigerant.DeviceType = input.DeviceType

	if err := db.Save(&refrigerant).Error; err != nil {
		util.FailedResponse(c, 5, "更新失敗")
		return
	}

	// 返回成功響應
	util.SuccessResponse(c)
}
