package main

// 伺服器入口程式，負責初始化資料庫與路由後啟動服務

import (
	"MCM/database"             // 資料庫連線及模型
	"MCM/router"               // 路由設定
	"github.com/gin-gonic/gin" // gin web framework
)

func main() {
	// 建立 DB 連線
	db := database.Connect()
	// 自動建立/更新資料表
	if err := database.MigrateDB(db); err != nil {
		panic(err)
	}

	// 初始化 Gin
	r := gin.Default()

	// 註冊路由
	api.AddRoutes(r)

	r.Run() // listen and serve on 0.0.0.0:8080
}
