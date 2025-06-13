package database

import "MCM/database/common"

type User struct {
	common.IDModel
	Account      string `gorm:"types:varchar(50);primary_key"`
	Password     string `gorm:"types:varchar(100)"`
	ShopName     string `gorm:"types:varchar(50);"`
	Phone        string `gorm:"types:varchar(50)"`
	IndustryType int
	Email        string `gorm:"types:varchar(50)"`
	PostalCode   string `gorm:"types:varchar(50)"`
	Region       string `gorm:"types:varchar(50)"`
	Address      string `gorm:"types:varchar(100)"`
	common.TimeModel
}
