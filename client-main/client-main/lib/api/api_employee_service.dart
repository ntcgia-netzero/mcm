import 'package:mcm_app/api/api_service.dart';
import 'package:mcm_app/api/models/api_employee_model.dart';
import 'package:mcm_app/api/models/api_model.dart';

class ApiEmployeeService extends ApiService {
  String prefix = 'api/f/private/employee/';

  Future<ApiGetEmployeeModel> getEmployee({
    required int userId,
    required int year,
  }) async {
    return ApiGetEmployeeModel(
      await postData(
        '${prefix}get-employee',
        body: {
          'userId': userId,
          'year': year,
        },
      ),
    );
  }

  Future<ApiModel> updateEmployee({
    required int userId,
    required int year,
    required int month,
    required int employeesCount,
    required double workingHoursPerDay,
    required double workingDaysPerMonth,
  }) async {
    return await postData(
      '${prefix}update-employee',
      body: {
        'userId': userId,
        'year': year,
        'month': month,
        'employeesCount': employeesCount,
        'workingHoursPerDay': workingHoursPerDay,
        'workingDaysPerMonth': workingDaysPerMonth,
      },
    );
  }
}
