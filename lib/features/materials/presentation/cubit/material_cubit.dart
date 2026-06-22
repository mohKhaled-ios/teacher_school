// // features/material/presentation/cubit/material_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import '../../../../core/errors/failures.dart';
// import '../../domain/entities/material_entity.dart';
// import '../../domain/entities/subject_entity.dart';
// import '../../domain/usecases/delete_material_usecase.dart';
// import '../../domain/usecases/get_materials_usecase.dart';
// import '../../domain/usecases/get_subjects_usecase.dart';
// import '../../domain/usecases/upload_material_usecase.dart';
// import 'material_state.dart';

// class MaterialCubit extends Cubit<MaterialStateeee> {
//   final GetMaterialsUseCase getMaterialsUseCase;
//   final GetSubjectsUseCase getSubjectsUseCase;
//   final UploadMaterialUseCase uploadMaterialUseCase;
//   final DeleteMaterialUseCase deleteMaterialUseCase;

//   MaterialCubit({
//     required this.getMaterialsUseCase,
//     required this.getSubjectsUseCase,
//     required this.uploadMaterialUseCase,
//     required this.deleteMaterialUseCase,
//   }) : super(MaterialInitial());

//   Future<void> loadMaterials({
//     String? subjectId,
//     String? classId,
//     String? fileType,
//   }) async {
//     emit(MaterialLoading());

//     final result = await getMaterialsUseCase(
//       subjectId: subjectId,
//       classId: classId,
//       fileType: fileType,
//     );

//     result.fold(
//       (failure) => emit(MaterialError(_mapFailureToMessage(failure))),
//       (materials) => emit(MaterialsLoaded(materials)),
//     );
//   }

//   Future<void> loadSubjects({
//     String? classId,
//     String? teacherId,
//   }) async {
//     final result = await getSubjectsUseCase(
//       classId: classId,
//       teacherId: teacherId,
//     );

//     result.fold(
//       (failure) => null, // Handle error silently
//       (subjects) => emit(state.copyWith(subjects: subjects)),
//     );
//   }

//   Future<void> uploadMaterial(FormData formData) async {
//     emit(MaterialUploading());

//     final result = await uploadMaterialUseCase(formData);

//     result.fold(
//       (failure) => emit(MaterialError(_mapFailureToMessage(failure))),
//       (material) {
//         // Add the new material to the list
//         if (state is MaterialsLoaded) {
//           final currentState = state as MaterialsLoaded;
//           final updatedMaterials = [material, ...currentState.materials];
//           emit(MaterialsLoaded(updatedMaterials));
//         } else {
//           emit(MaterialsLoaded([material]));
//         }
//         emit(MaterialUploadSuccess(material));
//       },
//     );
//   }

//   Future<void> deleteMaterial(String materialId) async {
//     emit(MaterialLoading());

//     final result = await deleteMaterialUseCase(materialId);

//     result.fold(
//       (failure) => emit(MaterialError(_mapFailureToMessage(failure))),
//       (_) {
//         // Remove the material from the list
//         if (state is MaterialsLoaded) {
//           final currentState = state as MaterialsLoaded;
//           final updatedMaterials = currentState.materials
//               .where((material) => material.id != materialId)
//               .toList();
//           emit(MaterialsLoaded(updatedMaterials));
//         }
//       },
//     );
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return 'خطأ في الخادم';
//       case NetworkFailure:
//         return 'خطأ في الاتصال بالانترنت';
//       case CacheFailure:
//         return 'خطأ في التخزين المحلي';
//       default:
//         return 'حدث خطأ غير متوقع';
//     }
//   }
// }

// features/material/presentation/cubit/material_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/usecases/delete_material_usecase.dart';
import '../../domain/usecases/get_materials_usecase.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/get_classes_usecase.dart';
import '../../domain/usecases/upload_material_usecase.dart';
import 'material_state.dart';

class MaterialCubit extends Cubit<MaterialStateeee> {
  final GetMaterialsUseCase getMaterialsUseCase;
  final GetSubjectsUseCase getSubjectsUseCase;
  final GetClassesUseCase getClassesUseCase;
  final UploadMaterialUseCase uploadMaterialUseCase;
  final DeleteMaterialUseCase deleteMaterialUseCase;

  MaterialCubit({
    required this.getMaterialsUseCase,
    required this.getSubjectsUseCase,
    required this.getClassesUseCase,
    required this.uploadMaterialUseCase,
    required this.deleteMaterialUseCase,
  }) : super(const MaterialInitial());

  Future<void> loadMaterials({
    String? subjectId,
    String? classId,
    String? fileType,
  }) async {
    emit(MaterialLoading(
      subjects: state.subjects,
      classes: state.classes,
    ));

    final result = await getMaterialsUseCase(
      subjectId: subjectId,
      classId: classId,
      fileType: fileType,
    );

    result.fold(
      (failure) => emit(MaterialError(
        _mapFailureToMessage(failure),
        subjects: state.subjects,
        classes: state.classes,
      )),
      (materials) => emit(MaterialsLoaded(
        materials,
        subjects: state.subjects,
        classes: state.classes,
      )),
    );
  }

  Future<void> loadSubjects({
    String? classId,
    String? teacherId,
  }) async {
    final result = await getSubjectsUseCase(
      classId: classId,
      teacherId: teacherId,
    );

    result.fold(
      (failure) => null, // Handle error silently
      (subjects) => emit(state.copyWith(subjects: subjects)),
    );
  }

  Future<void> loadClasses() async {
    final result = await getClassesUseCase();

    result.fold(
      (failure) => null, // Handle error silently
      (classes) => emit(state.copyWith(classes: classes)),
    );
  }

  Future<void> uploadMaterial(FormData formData) async {
    emit(MaterialUploading(
      subjects: state.subjects,
      classes: state.classes,
    ));

    final result = await uploadMaterialUseCase(formData);

    result.fold(
      (failure) => emit(MaterialError(
        _mapFailureToMessage(failure),
        subjects: state.subjects,
        classes: state.classes,
      )),
      (material) {
        // Add the new material to the list
        if (state is MaterialsLoaded) {
          final currentState = state as MaterialsLoaded;
          final updatedMaterials = [material, ...currentState.materials];
          emit(MaterialsLoaded(
            updatedMaterials,
            subjects: state.subjects,
            classes: state.classes,
          ));
        } else {
          emit(MaterialsLoaded(
            [material],
            subjects: state.subjects,
            classes: state.classes,
          ));
        }
        emit(MaterialUploadSuccess(
          material,
          subjects: state.subjects,
          classes: state.classes,
        ));
      },
    );
  }

  Future<void> deleteMaterial(String materialId) async {
    emit(MaterialLoading(
      subjects: state.subjects,
      classes: state.classes,
    ));

    final result = await deleteMaterialUseCase(materialId);

    result.fold(
      (failure) => emit(MaterialError(
        _mapFailureToMessage(failure),
        subjects: state.subjects,
        classes: state.classes,
      )),
      (_) {
        // Remove the material from the list
        if (state is MaterialsLoaded) {
          final currentState = state as MaterialsLoaded;
          final updatedMaterials = currentState.materials
              .where((material) => material.id != materialId)
              .toList();
          emit(MaterialsLoaded(
            updatedMaterials,
            subjects: state.subjects,
            classes: state.classes,
          ));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'خطأ في الخادم';
      case NetworkFailure:
        return 'خطأ في الاتصال بالانترنت';
      case CacheFailure:
        return 'خطأ في التخزين المحلي';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
