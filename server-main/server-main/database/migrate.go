package database

import (
	"MCM/database/config"
	"MCM/database/electricity"
	"MCM/database/employee"
	"MCM/database/fuel"
	"MCM/database/refrigerant"
	"MCM/database/types"
	user "MCM/database/user"
	"gorm.io/gorm"
)

func MigrateDB(db *gorm.DB) error {
	err := db.AutoMigrate(
		// config
		&config.DeviceTypeConfig{},
		&config.ElectricityConfig{},
		&config.EmployeeConfig{},
		&config.FuelConfig{},
		&config.GWPConfig{},
		&config.RefrigerantTypeConfig{},
		&config.YearConfig{},
		// electricity
		&electricity.Electricity{},
		// employee
		&employee.Employee{},
		// refrigerant
		&refrigerant.Refrigerant{},
		// fuel
		&fuel.Fuel{},
		// types
		&types.IndustryType{},
		&types.DeviceType{},
		&types.RefrigerantType{},
		// user
		&user.User{},
	)

	if err != nil {
		return err
	}

	return nil
}
