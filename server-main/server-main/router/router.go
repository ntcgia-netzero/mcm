package api

import (
	"MCM/router/api"
	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.Engine) {
	apiRoute := r.Group("/api")
	api.AddRoutes(apiRoute)
}
