import 'package:mcm_app/api/models/api_model.dart';

class Refrigerant {
  int? id;
  String? name;
  int? count;
  int? useMonth;
  double? refrigerantSupplement;
  int? refrigerantType;
  int? deviceType;
  double? value;

  Refrigerant(data) {
    id = data['id'];
    name = data['name'];
    count = data['count'];
    useMonth = data['useMonth'];
    refrigerantSupplement = data['refrigerantSupplement'].toDouble();
    refrigerantType = data['refrigerantType'];
    deviceType = data['deviceType'];
    value = data['value'].toDouble();
  }
}

class ApiGetRefrigerantModel {
  late ApiModel apiModel;
  List<Refrigerant> refrigerant = [];

  ApiGetRefrigerantModel(this.apiModel) {
    for (int i = 0; i < apiModel.data.length; i++) {
      refrigerant.add(Refrigerant(apiModel.data[i]));
    }
  }
}
