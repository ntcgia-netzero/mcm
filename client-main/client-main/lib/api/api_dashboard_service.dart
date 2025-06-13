import 'package:mcm_app/api/api_service.dart';
import 'package:mcm_app/api/models/api_dashboard_model.dart';

class ApiDashboardService extends ApiService {
  String prefix = 'api/f/private/dashboard/';

  Future<ApiGetDashboardModel> getData({
    required int userId,
    required int year,
  }) async {
    return ApiGetDashboardModel(
      await postData(
        '${prefix}get-data',
        body: {
          'userId': userId,
          'year': year,
        },
      ),
    );
  }
}
