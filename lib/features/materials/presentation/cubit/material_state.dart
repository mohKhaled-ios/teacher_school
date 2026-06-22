// import 'package:equatable/equatable.dart';
// import '../../domain/entities/material_entity.dart';
// import '../../domain/entities/subject_entity.dart';

// abstract class MaterialStateeee extends Equatable {
//   final List<SubjectEntity> subjects;

//   const MaterialStateeee({this.subjects = const []});

//   @override
//   List<Object?> get props => [subjects];

//   MaterialStateeee copyWith({
//     List<SubjectEntity>? subjects,
//   });
// }

// class MaterialInitial extends MaterialStateeee {
//   const MaterialInitial({super.subjects = const []});

//   @override
//   MaterialStateeee copyWith({List<SubjectEntity>? subjects}) {
//     return MaterialInitial(subjects: subjects ?? this.subjects);
//   }
// }

// class MaterialLoading extends MaterialStateeee {
//   const MaterialLoading({super.subjects = const []});

//   @override
//   MaterialStateeee copyWith({List<SubjectEntity>? subjects}) {
//     return MaterialLoading(subjects: subjects ?? this.subjects);
//   }
// }

// class MaterialsLoaded extends MaterialStateeee {
//   final List<MaterialEntity> materials;

//   const MaterialsLoaded(this.materials, {super.subjects = const []});

//   @override
//   List<Object?> get props => [materials, subjects];

//   @override
//   MaterialStateeee copyWith({
//     List<MaterialEntity>? materials,
//     List<SubjectEntity>? subjects,
//   }) {
//     return MaterialsLoaded(
//       materials ?? this.materials,
//       subjects: subjects ?? this.subjects,
//     );
//   }
// }

// class MaterialUploading extends MaterialStateeee {
//   const MaterialUploading({super.subjects = const []});

//   @override
//   MaterialStateeee copyWith({List<SubjectEntity>? subjects}) {
//     return MaterialUploading(subjects: subjects ?? this.subjects);
//   }
// }

// class MaterialUploadSuccess extends MaterialStateeee {
//   final MaterialEntity material;

//   const MaterialUploadSuccess(this.material, {super.subjects = const []});

//   @override
//   List<Object?> get props => [material, subjects];

//   @override
//   MaterialStateeee copyWith({
//     MaterialEntity? material,
//     List<SubjectEntity>? subjects,
//   }) {
//     return MaterialUploadSuccess(
//       material ?? this.material,
//       subjects: subjects ?? this.subjects,
//     );
//   }
// }

// class MaterialError extends MaterialStateeee {
//   final String message;

//   const MaterialError(this.message, {super.subjects = const []});

//   @override
//   List<Object?> get props => [message, subjects];

//   @override
//   MaterialStateeee copyWith({
//     String? message,
//     List<SubjectEntity>? subjects,
//   }) {
//     return MaterialError(
//       message ?? this.message,
//       subjects: subjects ?? this.subjects,
//     );
//   }
// }
// features/material/presentation/cubit/material_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/entities/class_entity.dart';

abstract class MaterialStateeee extends Equatable {
  final List<SubjectEntity> subjects;
  final List<ClassEntity> classes;

  const MaterialStateeee({
    this.subjects = const [],
    this.classes = const [],
  });

  @override
  List<Object?> get props => [subjects, classes];

  MaterialStateeee copyWith({
    List<SubjectEntity>? subjects,
    List<ClassEntity>? classes,
  });
}

class MaterialInitial extends MaterialStateeee {
  const MaterialInitial({
    super.subjects = const [],
    super.classes = const [],
  });

  @override
  MaterialStateeee copyWith({
    List<SubjectEntity>? subjects,
    List<ClassEntity>? classes,
  }) {
    return MaterialInitial(
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
    );
  }
}

class MaterialLoading extends MaterialStateeee {
  const MaterialLoading({
    super.subjects = const [],
    super.classes = const [],
  });

  @override
  MaterialStateeee copyWith({
    List<SubjectEntity>? subjects,
    List<ClassEntity>? classes,
  }) {
    return MaterialLoading(
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
    );
  }
}

class MaterialsLoaded extends MaterialStateeee {
  final List<MaterialEntity> materials;

  const MaterialsLoaded(
    this.materials, {
    super.subjects = const [],
    super.classes = const [],
  });

  @override
  List<Object?> get props => [materials, subjects, classes];

  @override
  MaterialStateeee copyWith({
    List<MaterialEntity>? materials,
    List<SubjectEntity>? subjects,
    List<ClassEntity>? classes,
  }) {
    return MaterialsLoaded(
      materials ?? this.materials,
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
    );
  }
}

class MaterialUploading extends MaterialStateeee {
  const MaterialUploading({
    super.subjects = const [],
    super.classes = const [],
  });

  @override
  MaterialStateeee copyWith({
    List<SubjectEntity>? subjects,
    List<ClassEntity>? classes,
  }) {
    return MaterialUploading(
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
    );
  }
}

class MaterialUploadSuccess extends MaterialStateeee {
  final MaterialEntity material;

  const MaterialUploadSuccess(
    this.material, {
    super.subjects = const [],
    super.classes = const [],
  });

  @override
  List<Object?> get props => [material, subjects, classes];

  @override
  MaterialStateeee copyWith({
    MaterialEntity? material,
    List<SubjectEntity>? subjects,
    List<ClassEntity>? classes,
  }) {
    return MaterialUploadSuccess(
      material ?? this.material,
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
    );
  }
}

class MaterialError extends MaterialStateeee {
  final String message;

  const MaterialError(
    this.message, {
    super.subjects = const [],
    super.classes = const [],
  });

  @override
  List<Object?> get props => [message, subjects, classes];

  @override
  MaterialStateeee copyWith({
    String? message,
    List<SubjectEntity>? subjects,
    List<ClassEntity>? classes,
  }) {
    return MaterialError(
      message ?? this.message,
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
    );
  }
}
