import 'package:mcm_app/api/models/api_model.dart';

class ApiGetDashboardModel {
  late ApiModel apiModel;
  late double electricity;
  late double employee;
  late double gasoline;
  late double diesel;
  late double refrigerant;

  ApiGetDashboardModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      print(content);

      electricity = content['electricity'].toDouble();
      employee = content['employee'].toDouble();
      gasoline = content['gasoline'].toDouble();
      diesel = content['diesel'].toDouble();
      refrigerant = content['refrigerant'].toDouble();
    }
  }
}
