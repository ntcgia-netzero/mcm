package config

import "MCM/database/common"

type RefrigerantTypeConfig struct {
	common.IDModel
	RefrigerantTypeId int
	Year              int     `gorm:"types:int(4)"`
	RefrigerantGWP    float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
