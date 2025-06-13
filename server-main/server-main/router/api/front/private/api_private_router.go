package private

import (
	"MCM/database"
	electricityModel "MCM/database/electricity"
	employeeModel "MCM/database/employee"
	fuelModel "MCM/database/fuel"
	refrigerantModel "MCM/database/refrigerant"
	userModel "MCM/database/user"
	"MCM/router/api/front/private/dashboard"
	"MCM/router/api/front/private/electricity"
	"MCM/router/api/front/private/employee"
	"MCM/router/api/front/private/fuel"
	"MCM/router/api/front/private/refrigerant"
	"MCM/router/api/util"
	"fmt"
	"github.com/gin-gonic/gin"
	"strconv"
)

func AddRoutes(r *gin.RouterGroup) {
	electricityRoute := r.Group("/electricity")
	electricity.AddRoutes(electricityRoute)

	employeeRoute := r.Group("/employee")
	employee.AddRoutes(employeeRoute)

	fuelRoute := r.Group("/fuel")
	fuel.AddRoutes(fuelRoute)

	refrigerantRoute := r.Group("/refrigerant")
	refrigerant.AddRoutes(refrigerantRoute)

	dashboardRoute := r.Group("/dashboard")
	dashboard.AddRoutes(dashboardRoute)

	r.POST("/delete-user", deleteUser)
}

type DeleteUserIn struct {
	UserId int `json:"userId" binding:"required"`
}

func deleteUser(c *gin.Context) {
	var input DeleteUserIn
	if err := c.ShouldBindJSON(&input); err != nil {
		util.InputInvalidResponse(c)
		return
	}

	if !util.CheckUserId(c, strconv.Itoa(input.UserId)) {
		return
	}

	var db = database.Connect()
	defer database.Close(db)

	tx := db.Begin()
	defer tx.Rollback()

	if err := tx.Delete(&userModel.User{}, input.UserId).Error; err != nil {
		util.FailedResponse(c, 2, fmt.Sprintf("delete user failed: %v", err))
		return
	}

	if err := tx.Delete(&electricityModel.Electricity{}, "user_id = ?", input.UserId).Error; err != nil {
		util.FailedResponse(c, 2, fmt.Sprintf("delete electricity failed: %v", err))
		return
	}

	if err := tx.Delete(&employeeModel.Employee{}, "user_id = ?", input.UserId).Error; err != nil {
		util.FailedResponse(c, 2, fmt.Sprintf("delete employee failed: %v", err))
		return
	}

	if err := tx.Delete(&fuelModel.Fuel{}, "user_id = ?", input.UserId).Error; err != nil {
		util.FailedResponse(c, 2, fmt.Sprintf("delete fuel failed: %v", err))
		return
	}

	if err := tx.Delete(&refrigerantModel.Refrigerant{}, "user_id = ?", input.UserId).Error; err != nil {
		util.FailedResponse(c, 2, fmt.Sprintf("delete refrigerant failed: %v", err))
		return
	}

	if err := tx.Commit().Error; err != nil {
		util.FailedResponse(c, 2, fmt.Sprintf("commit transaction failed: %v", err))
		return
	}

	util.SuccessResponse(c)
}
