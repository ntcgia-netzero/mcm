package front

import (
	"MCM/router/api/front/private"
	"MCM/router/api/front/public"
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
