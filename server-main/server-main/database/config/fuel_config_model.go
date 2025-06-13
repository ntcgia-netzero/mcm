package config

import "MCM/database/common"

type FuelConfig struct {
	common.IDModel
	Year                           int     `gorm:"types:int(4)"`
	GasolineCO2EmissionCoefficient float64 `gorm:"types:decimal(10,10)"`
	GasolineCH4EmissionCoefficient float64 `gorm:"types:decimal(10,10)"`
	GasolineN2OEmissionCoefficient float64 `gorm:"types:decimal(10,10)"`
	DieselCO2EmissionCoefficient   float64 `gorm:"types:decimal(10,10)"`
	DieselCH4EmissionCoefficient   float64 `gorm:"types:decimal(10,10)"`
	DieselN2OEmissionCoefficient   float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
