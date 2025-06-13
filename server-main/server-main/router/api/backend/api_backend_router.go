package backend

import (
	"MCM/router/api/backend/private"
	"MCM/router/api/backend/public"
	"MCM/router/api/util"
	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.RouterGroup) {
	publicRoute := r.Group("/public")
	public.AddRoutes(publicRoute)

	privateRoute := r.Group("/private")
	privateRoute.Use(util.AuthMiddleware())
	private.AddRoutes(privateRoute)
}
