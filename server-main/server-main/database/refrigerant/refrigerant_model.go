package refrigerant

import "MCM/database/common"

type Refrigerant struct {
	common.IDModel
	UserId                int
	Year                  int     `gorm:"types:int(4)"`
	Name                  string  `gorm:"types:varchar(50)"`
	Count                 int     `gorm:"types:decimal(10,10)"`
	UseMonth              int     `gorm:"types:decimal(10,10)"`
	RefrigerantSupplement float64 `gorm:"types:decimal(10,10)"`
	RefrigerantType       int
	DeviceType            int
	common.TimeModel
}
