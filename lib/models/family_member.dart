import 'package:flutter/foundation.dart';

enum LifeStatus { alive, deceased }

enum CauseCategory { illness, accident, unknown }

enum FamilyGender { male, female, other }

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

extension FamilyGenderHelpers on FamilyGender {
  String get value => name;

  String get label {
    switch (this) {
      case FamilyGender.male:
        return 'Male';
      case FamilyGender.female:
        return 'Female';
      case FamilyGender.other:
        return 'Other';
    }
  }

  static FamilyGender fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'male':
        return FamilyGender.male;
      case 'female':
        return FamilyGender.female;
      case 'other':
      default:
        return FamilyGender.other;
    }
  }
}

const _undefined = Object();

@immutable
class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.generation,
    this.childIds = const <String>[],
    this.parentId,
    this.fatherId,
    this.motherId,
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
    this.gender = FamilyGender.other,
  });

  final String id;
  final String name;
  final String role;
  final int generation;
  final String? parentId;
  final String? fatherId;
  final String? motherId;
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
  final FamilyGender gender;

  static String autoRole({required int generation, required FamilyGender gender}) {
    switch (generation) {
      case 0:
        if (gender == FamilyGender.male) return 'Patriarch';
        if (gender == FamilyGender.female) return 'Matriarch';
        return 'Founder';
      case 1:
        if (gender == FamilyGender.male) return 'Son';
        if (gender == FamilyGender.female) return 'Daughter';
        return 'Child';
      default:
        final prefix = _generationPrefix(generation);
        if (gender == FamilyGender.male) return '${prefix}son';
        if (gender == FamilyGender.female) return '${prefix}daughter';
        return '${prefix}child';
    }
  }

  static String _generationPrefix(int generation) {
    if (generation == 2) return 'Grand';
    if (generation <= 1) return '';
    final buffer = StringBuffer();
    for (var i = 2; i < generation; i++) {
      buffer.write('Great-');
    }
    buffer.write('Grand');
    return buffer.toString();
  }

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
    Object? id = _undefined,
    Object? name = _undefined,
    Object? role = _undefined,
    Object? generation = _undefined,
    Object? parentId = _undefined,
    Object? fatherId = _undefined,
    Object? motherId = _undefined,
    Object? childIds = _undefined,
    Object? location = _undefined,
    Object? note = _undefined,
    Object? spouseId = _undefined,
    Object? relationshipRole = _undefined,
    Object? status = _undefined,
    Object? birthYear = _undefined,
    Object? deathYear = _undefined,
    Object? occupation = _undefined,
    Object? causeOfDeath = _undefined,
    Object? causeCategory = _undefined,
    Object? causeVisible = _undefined,
    Object? gender = _undefined,
  }) {
    return FamilyMember(
      id: id == _undefined ? this.id : id as String,
      name: name == _undefined ? this.name : name as String,
      role: role == _undefined ? this.role : role as String,
      generation: generation == _undefined ? this.generation : generation as int,
      parentId: parentId == _undefined ? this.parentId : parentId as String?,
      fatherId: fatherId == _undefined ? this.fatherId : fatherId as String?,
      motherId: motherId == _undefined ? this.motherId : motherId as String?,
      childIds: childIds == _undefined ? this.childIds : childIds as List<String>,
      location: location == _undefined ? this.location : location as String?,
      note: note == _undefined ? this.note : note as String?,
      spouseId: spouseId == _undefined ? this.spouseId : spouseId as String?,
      relationshipRole: relationshipRole == _undefined
          ? this.relationshipRole
          : relationshipRole as String,
      status: status == _undefined ? this.status : status as LifeStatus,
      birthYear: birthYear == _undefined ? this.birthYear : birthYear as String?,
      deathYear: deathYear == _undefined ? this.deathYear : deathYear as String?,
      occupation: occupation == _undefined ? this.occupation : occupation as String?,
      causeOfDeath: causeOfDeath == _undefined
          ? this.causeOfDeath
          : causeOfDeath as String?,
      causeCategory: causeCategory == _undefined
          ? this.causeCategory
          : causeCategory as CauseCategory?,
      causeVisible: causeVisible == _undefined
          ? this.causeVisible
          : causeVisible as bool,
      gender: gender == _undefined ? this.gender : gender as FamilyGender,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'generation': generation,
        'parentId': parentId,
        'fatherId': fatherId,
        'motherId': motherId,
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
        'gender': gender.value,
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
      fatherId: json['fatherId'] is String ? json['fatherId'] as String : null,
      motherId: json['motherId'] is String ? json['motherId'] as String : null,
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
      causeVisible:
          json['causeVisible'] is bool ? json['causeVisible'] as bool : true,
      gender: FamilyGenderHelpers.fromString(
          json['gender'] is String ? json['gender'] as String : null),
    );
  }
}
