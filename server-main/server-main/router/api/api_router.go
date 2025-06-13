package api

import (
	"MCM/router/api/front"
	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.RouterGroup) {
	frontRoute := r.Group("/f")
	front.AddRoutes(frontRoute)

	//backendRoute := r.Group("/b")
	//backend.AddRoutes(backendRoute)
}
