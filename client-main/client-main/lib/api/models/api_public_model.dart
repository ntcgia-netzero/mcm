import 'package:mcm_app/api/models/api_model.dart';

// login

class ApiLoginModel {
  late ApiModel apiModel;
  int? userId;
  String? token;

  ApiLoginModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      userId = content['userId'];
      token = content['token'];
    }
  }
}

// industryType

class IndustryType {
  int? id;
  String? name;

  IndustryType(data) {
    id = data['id'];
    name = data['name'];
  }
}

class ApiGetIndustryTypesModel {
  late ApiModel apiModel;
  List<IndustryType> industryTypes = [];

  ApiGetIndustryTypesModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      List<dynamic> values = content['industryTypes'];

      for (int i = 0; i < values.length; i++) {
        industryTypes.add(IndustryType(values[i]));
      }
    }
  }
}

// year

class ApiGetYearsModel {
  late ApiModel apiModel;
  List<int> years = [];

  ApiGetYearsModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      List<dynamic> values = content['years'];

      for (int i = 0; i < values.length; i++) {
        years.add(values[i]);
      }
    }
  }
}

// refrigerantTypes

class RefrigerantType {
  int? id;
  String? name;

  RefrigerantType(data) {
    id = data['id'];
    name = data['name'];
  }
}

class ApiGetRefrigerantTypesModel {
  late ApiModel apiModel;
  List<RefrigerantType> refrigerantTypes = [];

  ApiGetRefrigerantTypesModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      List<dynamic> values = content['refrigerantTypes'];

      for (int i = 0; i < values.length; i++) {
        refrigerantTypes.add(RefrigerantType(values[i]));
      }
    }
  }
}

// deviceTypes

class DeviceType {
  int? id;
  String? name;

  DeviceType(data) {
    id = data['id'];
    name = data['name'];
  }
}

class ApiGetDeviceTypesModel {
  late ApiModel apiModel;
  List<DeviceType> deviceTypes = [];

  ApiGetDeviceTypesModel(this.apiModel) {
    dynamic content = apiModel.data;

    if (content is Map) {
      List<dynamic> values = content['deviceTypes'];

      for (int i = 0; i < values.length; i++) {
        deviceTypes.add(DeviceType(values[i]));
      }
    }
  }
}