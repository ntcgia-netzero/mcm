import 'package:mcm_app/api/api_util.dart';
import 'package:mcm_app/api/models/api_model.dart';

class Employee {
  int? employeesCount;
  double? workingHoursPerDay;
  double? workingDaysPerMonth;
  double? value;

  Employee(data) {
    employeesCount = data['employeesCount'];
    workingHoursPerDay = data['workingHoursPerDay'].toDouble();
    workingDaysPerMonth = data['workingDaysPerMonth'].toDouble();
    value = data['value'].toDouble();
  }
}

class ApiGetEmployeeModel {
  late ApiModel apiModel;
  Map<String, Employee> employee = {};

  ApiGetEmployeeModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      for (int i = 0; i < ApiUtil.monthKey.length; i++) {
        String key = ApiUtil.monthKey[i];
        employee[key] = Employee(content[key]);
      }
    }
  }
}
