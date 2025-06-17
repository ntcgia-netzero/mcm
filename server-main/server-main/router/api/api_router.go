package api

// API 路由的入口，依前後台分派子路由

import (
	"MCM/router/api/front" // 前台路由
	"github.com/gin-gonic/gin"
)

// AddRoutes 將前台與後台路由掛載於 /api 下
func AddRoutes(r *gin.RouterGroup) {
	// 前台路由 /api/f
	frontRoute := r.Group("/f")
	front.AddRoutes(frontRoute)

	// 後台路由預留，未開啟
	// backendRoute := r.Group("/b")
	// backend.AddRoutes(backendRoute)
}
