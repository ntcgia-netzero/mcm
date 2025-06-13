package electricity

import "MCM/database/common"

type Electricity struct {
	common.IDModel
	UserId                 int
	Year                   int     `gorm:"types:int(4)"`
	Month                  int     `gorm:"types:int(2)"`
	ElectricityConsumption float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
