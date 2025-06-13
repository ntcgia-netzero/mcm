import 'package:mcm_app/api/api_service.dart';
import 'package:mcm_app/api/models/api_model.dart';
import 'package:mcm_app/api/models/api_public_model.dart';

class ApiPublicService extends ApiService {
  String prefix = 'api/f/public/';

  Future<ApiLoginModel> login({
    required String account,
    required String password,
  }) async {
    return ApiLoginModel(
      await postData(
        '${prefix}login',
        body: {
          'account': account,
          'password': password,
        },
      ),
    );
  }

  Future<ApiModel> register({
    required String account,
    required String password,
    required String shopName,
    required String phone,
    required int industryType,
    required String email,
    required String postalCode,
    required String region,
    required String address,
  }) async {
    return await postData(
      '${prefix}register',
      body: {
        'account': account,
        'password': password,
        'shopName': shopName,
        'phone': phone,
        'industryType': industryType,
        'email': email,
        'postalCode': postalCode,
        'region': region,
        'address': address,
      },
    );
  }

  Future<ApiGetIndustryTypesModel> getIndustryTypes() async {
    return ApiGetIndustryTypesModel(
      await postData(
        '${prefix}types/get-industry-types',
      ),
    );
  }

  Future<ApiGetDeviceTypesModel> getDeviceTypes() async {
    return ApiGetDeviceTypesModel(
      await postData(
        '${prefix}types/get-device-types',
      ),
    );
  }

  Future<ApiGetRefrigerantTypesModel> getRefrigerantTypes() async {
    return ApiGetRefrigerantTypesModel(
      await postData(
        '${prefix}types/get-refrigerant-types',
      ),
    );
  }

  Future<ApiGetYearsModel> getYears() async {
    return ApiGetYearsModel(
      await postData(
        '${prefix}types/get-years',
      ),
    );
  }
}
