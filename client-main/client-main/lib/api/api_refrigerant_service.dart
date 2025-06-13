import 'package:mcm_app/api/api_service.dart';
import 'package:mcm_app/api/models/api_model.dart';
import 'package:mcm_app/api/models/api_refrigerant_model.dart';

class ApiRefrigerantService extends ApiService {
  String prefix = 'api/f/private/refrigerant/';

  Future<ApiGetRefrigerantModel> getRefrigerant({
    required int userId,
    required int year,
  }) async {
    return ApiGetRefrigerantModel(
      await postData(
        '${prefix}get-refrigerant',
        body: {
          'userId': userId,
          'year': year,
        },
      ),
    );
  }

  Future<ApiModel> updateRefrigerant({
    required int id,
    required int userId,
    required String name,
    required int count,
    required int useMonth,
    required double refrigerantSupplement,
    required int refrigerantType,
    required int deviceType,
  }) async {
    return await postData(
      '${prefix}update-refrigerant',
      body: {
        'id': id,
        'userId': userId,
        'name': name,
        'count': count,
        'useMonth': useMonth,
        'refrigerantSupplement': refrigerantSupplement,
        'refrigerantType': refrigerantType,
        'deviceType': deviceType,
      },
    );
  }

  Future<ApiModel> createRefrigerant({
    required int userId,
    required int year,
    required String name,
    required int count,
    required int useMonth,
    required double refrigerantSupplement,
    required int refrigerantType,
    required int deviceType,
  }) async {
    return await postData(
      '${prefix}create-refrigerant',
      body: {
        'userId': userId,
        'year': year,
        'name': name,
        'count': count,
        'useMonth': useMonth,
        'refrigerantSupplement': refrigerantSupplement,
        'refrigerantType': refrigerantType,
        'deviceType': deviceType,
      },
    );
  }
}
