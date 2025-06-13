import 'package:mcm_app/api/api_service.dart';
import 'package:mcm_app/api/models/api_fuel_model.dart';
import 'package:mcm_app/api/models/api_model.dart';

class ApiFuelService extends ApiService {
  String prefix = 'api/f/private/fuel/';

  Future<ApiGetFuelModel> getFuel({
    required int userId,
    required int year,
  }) async {
    return ApiGetFuelModel(
      await postData(
        '${prefix}get-fuel',
        body: {
          'userId': userId,
          'year': year,
        },
      ),
    );
  }

  Future<ApiModel> updateFuel({
    required int userId,
    required int year,
    required int month,
    required double gasoline,
    required double diesel,
  }) async {
    return await postData(
      '${prefix}update-fuel',
      body: {
        'userId': userId,
        'year': year,
        'month': month,
        'gasoline': gasoline,
        'diesel': diesel,
      },
    );
  }
}