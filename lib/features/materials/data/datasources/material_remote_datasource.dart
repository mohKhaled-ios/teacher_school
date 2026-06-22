// // features/material/data/datasources/material_remote_datasource.dart
// import 'package:dio/dio.dart';
// import '../../../../core/network/api_client.dart';
// import '../models/material_model.dart';
// import '../models/subject_model.dart';

// abstract class MaterialRemoteDataSource {
//   Future<List<MaterialModel>> getMaterials({
//     String? subjectId,
//     String? classId,
//     String? fileType,
//   });

//   Future<List<SubjectModel>> getSubjects({
//     String? classId,
//     String? teacherId,
//   });

//   Future<MaterialModel> uploadMaterial(FormData formData);
//   Future<void> deleteMaterial(String materialId);
// }

// class MaterialRemoteDataSourceImpl implements MaterialRemoteDataSource {
//   final ApiClient apiClient;

//   MaterialRemoteDataSourceImpl(this.apiClient);

//   @override
//   Future<List<MaterialModel>> getMaterials({
//     String? subjectId,
//     String? classId,
//     String? fileType,
//   }) async {
//     final queryParams = <String, dynamic>{};
//     if (subjectId != null) queryParams['subjectId'] = subjectId;
//     if (classId != null) queryParams['classId'] = classId;
//     if (fileType != null) queryParams['fileType'] = fileType;

//     final response = await apiClient.getMaterials(queryParams: queryParams);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = response.data;
//       return data.map((json) => MaterialModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load materials: ${response.statusMessage}');
//     }
//   }

//   @override
//   Future<List<SubjectModel>> getSubjects({
//     String? classId,
//     String? teacherId,
//   }) async {
//     final queryParams = <String, dynamic>{};
//     if (classId != null) queryParams['classId'] = classId;
//     if (teacherId != null) queryParams['teacherId'] = teacherId;

//     final response = await apiClient.getSubjects(queryParams: queryParams);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = response.data;
//       return data.map((json) => SubjectModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load subjects: ${response.statusMessage}');
//     }
//   }

//   @override
//   Future<MaterialModel> uploadMaterial(FormData formData) async {
//     final response = await apiClient.uploadMaterial(formData);

//     if (response.statusCode == 201) {
//       return MaterialModel.fromJson(response.data);
//     } else {
//       throw Exception('Failed to upload material: ${response.statusMessage}');
//     }
//   }

//   @override
//   Future<void> deleteMaterial(String materialId) async {
//     final response = await apiClient.deleteMaterial(materialId);

//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete material: ${response.statusMessage}');
//     }
//   }
// }
// features/material/data/datasources/material_remote_datasource.dart
// features/material/data/datasources/material_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/material_model.dart';
import '../models/subject_model.dart';
import '../models/class_model.dart'; // أضف هذا الاستيراد

abstract class MaterialRemoteDataSource {
  Future<List<MaterialModel>> getMaterials({
    String? subjectId,
    String? classId,
    String? fileType,
  });

  Future<List<SubjectModel>> getSubjects({
    String? classId,
    String? teacherId,
  });

  Future<List<ClassModel>> getClasses();

  Future<MaterialModel> uploadMaterial(FormData formData);
  Future<void> deleteMaterial(String materialId);
}

class MaterialRemoteDataSourceImpl implements MaterialRemoteDataSource {
  final ApiClient apiClient;

  MaterialRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MaterialModel>> getMaterials({
    String? subjectId,
    String? classId,
    String? fileType,
  }) async {
    final queryParams = <String, dynamic>{};
    if (subjectId != null) queryParams['subjectId'] = subjectId;
    if (classId != null) queryParams['classId'] = classId;
    if (fileType != null) queryParams['fileType'] = fileType;

    final response = await apiClient.getMaterials(queryParams: queryParams);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => MaterialModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load materials: ${response.statusMessage}');
    }
  }

  @override
  Future<List<SubjectModel>> getSubjects({
    String? classId,
    String? teacherId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (classId != null) queryParams['classId'] = classId;
    if (teacherId != null) queryParams['teacherId'] = teacherId;

    final response = await apiClient.getSubjects(queryParams: queryParams);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => SubjectModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects: ${response.statusMessage}');
    }
  }

  @override
  Future<List<ClassModel>> getClasses() async {
    final response = await apiClient.getClasses();

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ClassModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load classes: ${response.statusMessage}');
    }
  }

  @override
  Future<MaterialModel> uploadMaterial(FormData formData) async {
    final response = await apiClient.uploadMaterial(formData);

    if (response.statusCode == 201) {
      return MaterialModel.fromJson(response.data);
    } else {
      throw Exception('Failed to upload material: ${response.statusMessage}');
    }
  }

  @override
  Future<void> deleteMaterial(String materialId) async {
    final response = await apiClient.deleteMaterial(materialId);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete material: ${response.statusMessage}');
    }
  }
}
