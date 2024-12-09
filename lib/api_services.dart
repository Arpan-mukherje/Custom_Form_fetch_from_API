import 'dart:developer';

import 'package:fetch_custom_form/model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  CustomFormModel customFormModel = CustomFormModel();

  Future<CustomFormModel> fetchData() async {
    try {
      const url =
          "https://api.nobunk.com/admin/fetchform?schoolId=66475fbb4facc685df7ca48c";

      var response = await http.get(Uri.parse(url));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        customFormModel = customFormModelFromJson(response.body);
        //log(customFormModel.data.formName!.toString());
      }
      return customFormModel;
    } catch (e) {
      log("Error : ${e.toString()}");
    }
    return customFormModel;
  }
}
