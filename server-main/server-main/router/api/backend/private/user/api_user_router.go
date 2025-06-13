package user

import (
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.RouterGroup) {
	r.POST("/get-user", getUser)
}

type GetUserIn struct {
	Account string `json:"account" binding:"required"`
}

func getUser(c *gin.Context) {
	var input GetUserIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if input.Account == "" {
		util.FailedResponse(c, 2, "account can't be empty")
		return
	}

	if !util.CheckUserId(c, input.Account) {
		return
	}

	util.SuccessResponse(c)
}
