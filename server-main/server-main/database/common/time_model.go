package common

import (
	"gorm.io/gorm"
	"time"
)

type TimeModel struct {
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}
