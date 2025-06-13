package types

import (
	"MCM/database"
	"MCM/database/config"
	"MCM/database/types"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/get-years", getYears)
	r.POST("/get-device-types", getDeviceTypes)
	r.POST("/get-industry-types", getIndustryTypes)
	r.POST("/get-refrigerant-types", getRefrigerantTypes)
}

// get-years

type GetYearsOut struct {
	Years []int `json:"years"`
}

func getYears(c *gin.Context) {
	var db = database.Connect()
	defer database.Close(db)

	var years []config.YearConfig
	db.Find(&years)

	var output GetYearsOut
	for i := 0; i < len(years); i++ {
		output.Years = append(output.Years, years[i].Year)
	}

	util.SuccessResponse(c, output)
}

// get-device-types

type GetDeviceTypesOut struct {
	DeviceTypes []DeviceTypeData `json:"deviceTypes"`
}

type DeviceTypeData struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}

func getDeviceTypes(c *gin.Context) {
	var db = database.Connect()
	defer database.Close(db)

	var deviceTypes []types.DeviceType
	db.Find(&deviceTypes)

	var output GetDeviceTypesOut
	for i := 0; i < len(deviceTypes); i++ {
		output.DeviceTypes = append(output.DeviceTypes, DeviceTypeData{
			Id:   int(deviceTypes[i].ID),
			Name: deviceTypes[i].Name,
		})
	}

	util.SuccessResponse(c, output)
}

// get-industry-types

type GetIndustryTypesOut struct {
	IndustryTypes []IndustryTypeData `json:"industryTypes"`
}

type IndustryTypeData struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}

func getIndustryTypes(c *gin.Context) {
	var db = database.Connect()
	defer database.Close(db)

	var industryTypes []types.IndustryType
	db.Find(&industryTypes)

	var output GetIndustryTypesOut
	for i := 0; i < len(industryTypes); i++ {
		output.IndustryTypes = append(output.IndustryTypes, IndustryTypeData{
			Id:   int(industryTypes[i].ID),
			Name: industryTypes[i].Name,
		})
	}

	util.SuccessResponse(c, output)
}

// get-refrigerant-types

type GetRefrigerantTypesOut struct {
	RefrigerantTypes []RefrigerantTypeData `json:"refrigerantTypes"`
}

type RefrigerantTypeData struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}

func getRefrigerantTypes(c *gin.Context) {
	var db = database.Connect()
	defer database.Close(db)

	var refrigerantTypes []types.RefrigerantType
	db.Find(&refrigerantTypes)

	var output GetRefrigerantTypesOut
	for i := 0; i < len(refrigerantTypes); i++ {
		output.RefrigerantTypes = append(output.RefrigerantTypes, RefrigerantTypeData{
			Id:   int(refrigerantTypes[i].ID),
			Name: refrigerantTypes[i].Name,
		})
	}

	util.SuccessResponse(c, output)
}
