import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mcm_app/api/models/api_model.dart';
import 'package:mcm_app/storages/user_storage.dart';

class ApiService {
  // 本地 android
  // final String _baseUrl = 'http://10.0.2.2:8080';

  // 本地 ios
  // final String _baseUrl = 'http://127.0.0.1:8080';

  // RunServer
  final String _baseUrl = 'http://13.115.212.233:8080';

  Future<ApiModel> deleteUser({
    required int userId,
  }) async {
    return await postData(
      'api/f/private/delete-user',
      body: {
        'userId': userId,
      },
    );
  }

  Future<ApiModel> postData(String endpoint,
      {Map<String, dynamic>? body}) async {
    ApiModel apiModel = ApiModel();
    apiModel.status = "error";
    apiModel.code = -1;
    apiModel.data = null;
    apiModel.message = '';

    try {
      final response = await http.post(Uri.parse('$_baseUrl/$endpoint'),
          body: body != null ? json.encode(body) : null,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'barear ${UserStorage.token}',
          }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        dynamic result = json.decode(response.body);

        apiModel.status = result['status'];
        apiModel.code = result['code'];
        apiModel.data = result['data'];
        apiModel.message = result['message'];
      } else {
        apiModel.message =
            'Server responded with status code: ${response.statusCode}';
      }
    } catch (e) {
      apiModel.message = 'Error: ${e.toString()}';
      return apiModel;
    }

    return apiModel;
  }
}
