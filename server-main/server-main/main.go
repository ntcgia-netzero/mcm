package main

import (
	"MCM/database"
	"MCM/router"
	"github.com/gin-gonic/gin"
)

func main() {
	// 建立 DB 連線
	db := database.Connect()
	if err := database.MigrateDB(db); err != nil {
		panic(err)
	}

	// 初始化 Gin
	r := gin.Default()

	// 註冊路由
	api.AddRoutes(r)

	r.Run() // listen and serve on 0.0.0.0:8080
}
