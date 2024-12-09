import 'dart:convert';

CustomFormModel customFormModelFromJson(String str) =>
    CustomFormModel.fromJson(json.decode(str));

String customFormModelToJson(CustomFormModel data) =>
    json.encode(data.toJson());

class CustomFormModel {
  bool? status;
  String? message;
  Data? data;

  CustomFormModel({
    this.status,
    this.message,
    this.data,
  });

  factory CustomFormModel.fromJson(Map<String, dynamic> json) =>
      CustomFormModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? schoolId;
  String? formName;
  List<FormDetail>? formDetails;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.id,
    this.schoolId,
    this.formName,
    this.formDetails,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        schoolId: json["schoolId"],
        formName: json["formName"],
        formDetails: json["formDetails"] == null
            ? []
            : List<FormDetail>.from(
                json["formDetails"]!.map((x) => FormDetail.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "schoolId": schoolId,
        "formName": formName,
        "formDetails": formDetails == null
            ? []
            : List<dynamic>.from(formDetails!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class FormDetail {
  String? sectionName;
  List<SectionDatum>? sectionData;
  String? id;

  FormDetail({
    this.sectionName,
    this.sectionData,
    this.id,
  });

  factory FormDetail.fromJson(Map<String, dynamic> json) => FormDetail(
        sectionName: json["sectionName"],
        sectionData: json["sectionData"] == null
            ? []
            : List<SectionDatum>.from(
                json["sectionData"]!.map((x) => SectionDatum.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "sectionName": sectionName,
        "sectionData": sectionData == null
            ? []
            : List<dynamic>.from(sectionData!.map((x) => x.toJson())),
        "_id": id,
      };
}

class SectionDatum {
  String? heading;
  String? label;
  String? typeOfWidget;
  bool? isdefault;
  bool? isMandatory;
  bool? enabled;
  List<dynamic>? options;
  dynamic selectedOption;
  String? id;

  SectionDatum({
    this.heading,
    this.label,
    this.typeOfWidget,
    this.isdefault,
    this.isMandatory,
    this.enabled,
    this.options,
    this.selectedOption,
    this.id,
  });

  factory SectionDatum.fromJson(Map<String, dynamic> json) => SectionDatum(
        heading: json["heading"],
        label: json["label"],
        typeOfWidget: json["typeOfWidget"],
        isdefault: json["isdefault"],
        isMandatory: json["isMandatory"],
        enabled: json["enabled"],
        options: json["options"] == null
            ? []
            : List<dynamic>.from(json["options"]!.map((x) => x)),
        selectedOption: json["selectedOption"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "heading": heading,
        "label": label,
        "typeOfWidget": typeOfWidget,
        "isdefault": isdefault,
        "isMandatory": isMandatory,
        "enabled": enabled,
        "options":
            options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "selectedOption": selectedOption,
        "_id": id,
      };
}
