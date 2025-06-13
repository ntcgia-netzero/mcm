import 'package:mcm_app/api/api_util.dart';
import 'package:mcm_app/api/models/api_model.dart';

class Electricity {
  double? electricityConsumption;
  double? value;

  Electricity(data) {
    electricityConsumption = data['electricityConsumption'].toDouble();
    value = data['value'].toDouble();
  }
}

class ApiGetElectricityModel {
  late ApiModel apiModel;
  Map<String, Electricity> electricity = {};

  ApiGetElectricityModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      for (int i = 0; i < ApiUtil.monthKey.length; i++) {
        String key = ApiUtil.monthKey[i];
        electricity[key] = Electricity(content[key]);
      }
    }
  }
}
