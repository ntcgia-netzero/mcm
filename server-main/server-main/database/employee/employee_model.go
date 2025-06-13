package employee

import "MCM/database/common"

type Employee struct {
	common.IDModel
	UserId              int
	Year                int     `gorm:"types:int(4)"`
	Month               int     `gorm:"types:int(2)"`
	EmployeesCount      int     `gorm:"types:int(10)"`
	WorkingHoursPerDay  float64 `gorm:"types:decimal(5,10)"`
	WorkingDaysPerMonth float64 `gorm:"types:decimal(5,10)"`
	common.TimeModel
}
