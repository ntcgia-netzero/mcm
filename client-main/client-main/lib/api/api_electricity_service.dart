import 'package:mcm_app/api/api_service.dart';
import 'package:mcm_app/api/models/api_electricity_model.dart';
import 'package:mcm_app/api/models/api_model.dart';

class ApiElectricityService extends ApiService {
  String prefix = 'api/f/private/electricity/';

  Future<ApiGetElectricityModel> getElectricity({
    required int userId,
    required int year,
  }) async {
    return ApiGetElectricityModel(
      await postData(
        '${prefix}get-electricity',
        body: {
          'userId': userId,
          'year': year,
        },
      ),
    );
  }

  Future<ApiModel> updateElectricity({
    required int userId,
    required int year,
    required int month,
    required double electricityConsumption,
  }) async {
    return await postData(
      '${prefix}update-electricity',
      body: {
        'userId': userId,
        'year': year,
        'month': month,
        'electricityConsumption': electricityConsumption,
      },
    );
  }
}
