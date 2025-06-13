package public

import (
	"MCM/router/api/util"
	"fmt"
	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/login", login)
}

type LoginIn struct {
	Account  string `json:"account" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type LoginOut struct {
	Token string `json:"token"`
}

func login(c *gin.Context) {
	var input LoginIn
	fmt.Print("atg")
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if input.Account == "" {
		util.FailedResponse(c, 2, "account can't be empty")
		return
	}

	token, err := util.GenerateJWTToken(input.Account)

	if err != nil {
		util.FailedResponse(c, 2, err.Error())
		return
	}

	var output LoginOut
	output.Token = token

	util.SuccessResponse(c, output)
}
