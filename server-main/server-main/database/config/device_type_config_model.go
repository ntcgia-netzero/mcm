package config

import "MCM/database/common"

type DeviceTypeConfig struct {
	common.IDModel
	DeviceTypeId        int
	Year                int     `gorm:"types:int(4)"`
	EquipmentEscapeRate float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
