package config

import "MCM/database/common"

type ElectricityConfig struct {
	common.IDModel
	Year        int     `gorm:"types:int(4)"`
	Coefficient float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
