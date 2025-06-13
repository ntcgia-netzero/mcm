package config

import "MCM/database/common"

type YearConfig struct {
	common.IDModel
	Year int `gorm:"types:int(4)"`
	common.TimeModel
}
