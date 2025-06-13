package types

import "MCM/database/common"

type RefrigerantType struct {
	common.IDModel
	Name string `gorm:"type:varchar(50)"`
	common.TimeModel
}
