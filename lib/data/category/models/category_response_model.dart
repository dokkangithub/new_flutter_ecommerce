import 'package:laravel_ecommerce/domain/category/entities/category.dart';

import 'category_model.dart';

class CategoryResponseModel {
  final List<CategoryModel> data;
  final bool? success;
  final int? status;

  CategoryResponseModel({
    required this.data,
    required this.success,
    required this.status,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      data: json["data"] == null
          ? []
          : List<CategoryModel>.from(json["data"]!.map((x) => CategoryModel.fromJson(x))),
      success: json["success"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
      'success': success,
      'status': status,
    };
  }
}