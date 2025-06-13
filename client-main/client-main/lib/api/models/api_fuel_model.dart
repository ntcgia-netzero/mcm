import 'package:mcm_app/api/api_util.dart';
import 'package:mcm_app/api/models/api_model.dart';

class Fuel {
  double? gasoline;
  double? diesel;
  double? gasolineValue;
  double? dieselValue;

  Fuel(data) {
    gasoline = data['gasoline'].toDouble();
    diesel = data['diesel'].toDouble();
    gasolineValue = data['gasolineValue'].toDouble();
    dieselValue = data['dieselValue'].toDouble();
  }
}

class ApiGetFuelModel {
  late ApiModel apiModel;
  Map<String, Fuel> fuel = {};

  ApiGetFuelModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      for (int i = 0; i < ApiUtil.monthKey.length; i++) {
        String key = ApiUtil.monthKey[i];
        fuel[key] = Fuel(content[key]);
      }
    }
  }
}
