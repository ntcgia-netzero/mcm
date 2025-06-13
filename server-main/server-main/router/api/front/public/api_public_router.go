package public

import (
	"MCM/database"
	"MCM/database/types"
	userModel "MCM/database/user"
	apiTypes "MCM/router/api/front/public/types"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
	"strconv"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/login", login)
	r.POST("/register", register)

	typesRoutes := r.Group("/types")
	apiTypes.AddRoutes(typesRoutes)
}

type LoginIn struct {
	Account  string `json:"account" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type LoginOut struct {
	UserId int    `json:"userId"`
	Token  string `json:"token"`
}

func login(c *gin.Context) {
	var input LoginIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	var existUser userModel.User
	if db.Where("account = ?", input.Account).First(&existUser).Error != nil {
		util.FailedResponse(c, 1, "帳號不存在")
		return
	}

	if !util.CheckPasswordHash(input.Password, existUser.Password) {
		util.FailedResponse(c, 2, "密碼錯誤")
		return
	}

	token, err := util.GenerateJWTToken(strconv.Itoa(int(existUser.ID)))

	if err != nil {
		util.FailedResponse(c, 3, err.Error())
		return
	}

	var output LoginOut
	output.Token = token
	output.UserId = int(existUser.ID)

	util.SuccessResponse(c, output)
}

type RegisterIn struct {
	Account      string `json:"account" binding:"required"`
	Password     string `json:"password" binding:"required"`
	ShopName     string `json:"shopName" binding:"required"`
	Phone        string `json:"phone" binding:"required"`
	IndustryType int    `json:"industryType" binding:"required"`
	Email        string `json:"email" binding:"required"`
	PostalCode   string `json:"postalCode" binding:"required"`
	Region       string `json:"region" binding:"required"`
	Address      string `json:"address" binding:"required"`
}

func register(c *gin.Context) {
	var input RegisterIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	print("input.Account: ", input.Account, "\n")

	// 檢查帳號是否已存在
	if db.Where("account = ?", input.Account).First(&userModel.User{}).Error == nil {
		print("帳號已存在\n")
		util.FailedResponse(c, 1, "帳號已存在")
		return
	}

	// 獲取 IndustryType
	var industryType types.IndustryType
	if err := db.First(&industryType, input.IndustryType).Error; err != nil {
		util.FailedResponse(c, 2, "無法獲取 IndustryType")
		return
	}

	hashedPassword, err := util.HashPassword(input.Password)
	if err != nil {
		util.FailedResponse(c, 3, "密碼加密失敗")
		return
	}

	newUser := userModel.User{}
	newUser.Account = input.Account
	newUser.Password = hashedPassword
	newUser.ShopName = input.ShopName
	newUser.Phone = input.Phone
	newUser.IndustryType = input.IndustryType
	newUser.Email = input.Email
	newUser.PostalCode = input.PostalCode
	newUser.Region = input.Region
	newUser.Address = input.Address

	if db.Create(&newUser).Error != nil {
		util.FailedResponse(c, 2, "無法創建新用戶")
		return
	}

	util.SuccessResponse(c)
}
