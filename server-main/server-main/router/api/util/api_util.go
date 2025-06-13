package util

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

var MonthKeys = []string{"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}

func SuccessResponse(c *gin.Context, data ...any) {
	responseData := gin.H{
		"status":  "ok",
		"code":    0,
		"message": "",
	}

	if len(data) > 0 {
		responseData["data"] = data[0]
	} else {
		responseData["data"] = nil
	}

	c.JSON(http.StatusOK, responseData)
}

func FailedResponse(c *gin.Context, code int, message string) {
	c.JSON(http.StatusOK, gin.H{
		"status":  "error",
		"data":    nil,
		"code":    code,
		"message": message,
	})
}

func InputInvalidResponse(c *gin.Context) {
	FailedResponse(c, 1, "Input is invalid")
}
