package config

import "MCM/database/common"

type EmployeeConfig struct {
	common.IDModel
	Year                 int     `gorm:"types:int(4)"`
	WastewaterVolume     float64 `gorm:"types:decimal(10,10)"`
	EmissionFactor       float64 `gorm:"types:decimal(10,10)"`
	SewageConcentration  float64 `gorm:"types:decimal(10,10)"`
	SepticTankEfficiency float64 `gorm:"types:decimal(10,10)"`
	Conversion           float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
