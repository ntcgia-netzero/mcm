package config

import "MCM/database/common"

type GWPConfig struct {
	common.IDModel
	Year        int     `gorm:"types:int(4)"`
	GWPElectric float64 `gorm:"types:decimal(10,10)"`
	GWPCH4      float64 `gorm:"types:decimal(10,10)"`
	GWPCO2      float64 `gorm:"types:decimal(10,10)"`
	GWPN2O      float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
