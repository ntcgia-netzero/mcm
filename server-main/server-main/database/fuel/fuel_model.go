package fuel

import "MCM/database/common"

type Fuel struct {
	common.IDModel
	UserId   int
	Year     int     `gorm:"types:int(4)"`
	Month    int     `gorm:"types:int(2)"`
	Gasoline float64 `gorm:"types:decimal(10,10)"`
	Diesel   float64 `gorm:"types:decimal(10,10)"`
	common.TimeModel
}
