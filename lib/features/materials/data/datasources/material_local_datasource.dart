// features/material/data/datasources/material_local_datasource.dart
import 'package:hive/hive.dart';
import '../../../../core/constants/hive_constants.dart';
import '../models/material_model.dart';

abstract class MaterialLocalDataSource {
  Future<void> cacheMaterials(List<MaterialModel> materials);
  Future<List<MaterialModel>> getCachedMaterials();
  Future<void> clearMaterialsCache();
}

class MaterialLocalDataSourceImpl implements MaterialLocalDataSource {
  final Box cacheBox;

  MaterialLocalDataSourceImpl(this.cacheBox);

  @override
  Future<void> cacheMaterials(List<MaterialModel> materials) async {
    final materialsJson = materials.map((m) => m.toJson()).toList();
    await cacheBox.put('materials', materialsJson);
  }

  @override
  Future<List<MaterialModel>> getCachedMaterials() async {
    final materialsJson = cacheBox.get('materials', defaultValue: []) as List;
    return materialsJson
        .map((json) => MaterialModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> clearMaterialsCache() async {
    await cacheBox.delete('materials');
  }
}