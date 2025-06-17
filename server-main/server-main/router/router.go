package api

// 根路由設定，將所有 /api 相關路由註冊進 gin.Engine

import (
	"MCM/router/api" // API 群組路由
	"github.com/gin-gonic/gin"
)

// AddRoutes 綁定 /api 路徑下的所有子路由
func AddRoutes(r *gin.Engine) {
	apiRoute := r.Group("/api")
	api.AddRoutes(apiRoute)
}
