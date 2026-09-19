import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/family_member.dart';
import '../storage/storage_service.dart';

class FamilyController extends ChangeNotifier {
  FamilyController({StorageService? storageService})
      : storageService = storageService ?? const StorageService();

  final StorageService storageService;

  List<FamilyMember> _members = <FamilyMember>[];
  bool _isLoading = false;
  String? _error;

  List<FamilyMember> get members => List.unmodifiable(_members);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalMembers => _members.length;
  int get maxGeneration =>
      _members.isEmpty ? 0 : _members.map((member) => member.generation).fold(0, max);

  List<FamilyMember> get rootMembers =>
      _members
        .where((member) => member.parentId == null && member.fatherId == null && member.motherId == null)
        .toList();

  FamilyMember? get rootMember {
    if (rootMembers.isEmpty) return null;
    return rootMembers.first;
  }

  FamilyMember? getMemberById(String id) {
    for (final member in _members) {
      if (member.id == id) return member;
    }
    return null;
  }

  Future<void> loadMembers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _members = await storageService.loadMembers();
    } catch (error, stackTrace) {
      _error = error.toString();
      debugPrint('Failed to load members: $_error');
      debugPrint('$stackTrace');
      _members = <FamilyMember>[];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMember(FamilyMember newMember) async {
    _members = [..._members, newMember];

    if (newMember.parentId != null) {
      _updateParentChildren(newMember.parentId!, newMember.id);
    }
    if (newMember.fatherId != null) {
      _updateParentChildren(newMember.fatherId!, newMember.id);
    }
    if (newMember.motherId != null) {
      _updateParentChildren(newMember.motherId!, newMember.id);
    }

    if (newMember.spouseId != null) {
      _updateSpouseLink(newMember.spouseId!, newMember.id);
    }

    await _saveMembers();
    notifyListeners();
  }

  Future<void> removeMember(String memberId) async {
    final memberExists = _members.any((member) => member.id == memberId);
    if (!memberExists) return;

    final remainingMembers = <FamilyMember>[];
    for (final member in _members) {
      if (member.id == memberId) {
        continue;
      }

      var updatedMember = member;

      if (updatedMember.parentId == memberId) {
        updatedMember = updatedMember.copyWith(parentId: null, generation: 0);
      }

      if (updatedMember.fatherId == memberId) {
        updatedMember = updatedMember.copyWith(fatherId: null);
      }

      if (updatedMember.motherId == memberId) {
        updatedMember = updatedMember.copyWith(motherId: null);
      }

      if (updatedMember.spouseId == memberId) {
        updatedMember = updatedMember.copyWith(spouseId: null);
      }

      if (updatedMember.childIds.contains(memberId)) {
        updatedMember = updatedMember.copyWith(
          childIds: updatedMember.childIds
              .where((childId) => childId != memberId)
              .toList(),
        );
      }

      remainingMembers.add(updatedMember);
    }

    _members = remainingMembers;
    await _saveMembers();
    notifyListeners();
  }

  Future<void> updateMembers(List<FamilyMember> newMembers) async {
    _members = List.unmodifiable(newMembers);
    await _saveMembers();
    notifyListeners();
  }

  Future<void> _saveMembers() async {
    try {
      await storageService.saveMembers(_members);
    } catch (error, stackTrace) {
      debugPrint('Failed to save members: $error');
      debugPrint('$stackTrace');
    }
  }

  void _updateParentChildren(String parentId, String childId) {
    final parentIndex = _members.indexWhere((member) => member.id == parentId);
    if (parentIndex < 0) return;

    final parent = _members[parentIndex];
    _members[parentIndex] = parent.copyWith(
      childIds: [...parent.childIds, childId],
    );
  }

  void _updateSpouseLink(String spouseId, String memberId) {
    final spouseIndex = _members.indexWhere((member) => member.id == spouseId);
    if (spouseIndex < 0) return;

    final spouse = _members[spouseIndex];
    _members[spouseIndex] = spouse.copyWith(spouseId: memberId);
  }
}
