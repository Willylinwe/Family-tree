import 'package:flutter/foundation.dart';

enum LifeStatus { alive, deceased }

enum CauseCategory { illness, accident, unknown }

extension CauseCategoryHelpers on CauseCategory {
  String get value => name;

  String get label {
    switch (this) {
      case CauseCategory.illness:
        return 'Illness';
      case CauseCategory.accident:
        return 'Accident';
      case CauseCategory.unknown:
      default:
        return 'Unknown';
    }
  }

  static CauseCategory fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'illness':
        return CauseCategory.illness;
      case 'accident':
        return CauseCategory.accident;
      case 'unknown':
      default:
        return CauseCategory.unknown;
    }
  }
}

extension LifeStatusHelpers on LifeStatus {
  String get value => name;

  String get label {
    switch (this) {
      case LifeStatus.alive:
        return 'Alive';
      case LifeStatus.deceased:
        return 'Deceased';
    }
  }

  static LifeStatus fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'deceased':
        return LifeStatus.deceased;
      case 'alive':
      default:
        return LifeStatus.alive;
    }
  }
}

@immutable
class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.generation,
    this.childIds = const <String>[],
    this.parentId,
    this.location,
    this.note,
    this.spouseId,
    this.relationshipRole = 'Family member',
    this.status = LifeStatus.alive,
    this.birthYear,
    this.deathYear,
    this.occupation,
    this.causeOfDeath,
    this.causeCategory,
    this.causeVisible = true,
  });

  final String id;
  final String name;
  final String role;
  final int generation;
  final String? parentId;
  final List<String> childIds;
  final String? location;
  final String? note;
  final String? spouseId;
  final String relationshipRole;
  final LifeStatus status;
  final String? birthYear;
  final String? deathYear;
  final String? occupation;
  final String? causeOfDeath;
  final CauseCategory? causeCategory;
  final bool causeVisible;

  String get initials {
    final words = name.split(' ');
    final initials = <String>[];
    for (final word in words.take(2)) {
      if (word.isNotEmpty) {
        initials.add(word[0].toUpperCase());
      }
    }
    return initials.join();
  }

  bool get hasChildren => childIds.isNotEmpty;
  bool get isAlive => status == LifeStatus.alive;
  String get statusLabel => status.label;

  FamilyMember copyWith({
    String? id,
    String? name,
    String? role,
    int? generation,
    String? parentId,
    List<String>? childIds,
    String? location,
    String? note,
    String? spouseId,
    String? relationshipRole,
    LifeStatus? status,
    String? birthYear,
    String? deathYear,
    String? occupation,
    String? causeOfDeath,
    CauseCategory? causeCategory,
    bool? causeVisible,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      generation: generation ?? this.generation,
      parentId: parentId ?? this.parentId,
      childIds: childIds ?? this.childIds,
      location: location ?? this.location,
      note: note ?? this.note,
      spouseId: spouseId ?? this.spouseId,
      relationshipRole: relationshipRole ?? this.relationshipRole,
      status: status ?? this.status,
      birthYear: birthYear ?? this.birthYear,
      deathYear: deathYear ?? this.deathYear,
      occupation: occupation ?? this.occupation,
      causeOfDeath: causeOfDeath ?? this.causeOfDeath,
      causeCategory: causeCategory ?? this.causeCategory,
      causeVisible: causeVisible ?? this.causeVisible,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'generation': generation,
        'parentId': parentId,
        'childIds': childIds,
        'location': location,
        'note': note,
        'spouseId': spouseId,
        'relationshipRole': relationshipRole,
        'status': status.value,
        'birthYear': birthYear,
        'deathYear': deathYear,
        'occupation': occupation,
        'causeOfDeath': causeOfDeath,
        'causeCategory': causeCategory?.value,
        'causeVisible': causeVisible,
      };

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final rawGeneration = json['generation'];
    final parsedGeneration = rawGeneration is int
        ? rawGeneration
        : rawGeneration is String
            ? int.tryParse(rawGeneration) ?? 0
            : 0;

    return FamilyMember(
      id: json['id'] is String ? json['id'] as String : 'unknown',
      name: json['name'] is String ? json['name'] as String : 'Unnamed',
      role: json['role'] is String ? json['role'] as String : 'Family member',
      generation: parsedGeneration,
      parentId: json['parentId'] is String ? json['parentId'] as String : null,
      childIds: (json['childIds'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          <String>[],
      location: json['location'] is String ? json['location'] as String : null,
      note: json['note'] is String ? json['note'] as String : null,
      spouseId: json['spouseId'] is String ? json['spouseId'] as String : null,
      relationshipRole: json['relationshipRole'] is String
          ? json['relationshipRole'] as String
          : 'Family member',
      status: LifeStatusHelpers.fromString(
          json['status'] is String ? json['status'] as String : null),
      birthYear:
          json['birthYear'] is String ? json['birthYear'] as String : null,
      deathYear:
          json['deathYear'] is String ? json['deathYear'] as String : null,
      occupation:
          json['occupation'] is String ? json['occupation'] as String : null,
        causeOfDeath: json['causeOfDeath'] is String
          ? json['causeOfDeath'] as String
          : null,
        causeCategory: CauseCategoryHelpers.fromString(
          json['causeCategory'] is String ? json['causeCategory'] as String : null),
        causeVisible: json['causeVisible'] is bool ? json['causeVisible'] as bool : true,
    );
  }
}
