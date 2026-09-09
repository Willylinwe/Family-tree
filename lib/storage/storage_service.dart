import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/family_member.dart';

class StorageService {
  const StorageService();

  static const _membersKey = 'family_members_v1';

  Future<List<FamilyMember>> loadMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_membersKey);
    if (jsonString == null || jsonString.isEmpty) return <FamilyMember>[];
    try {
      final list = json.decode(jsonString) as List<dynamic>;
      return list
          .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error, stackTrace) {
      debugPrint('Failed to load saved members: $error');
      debugPrint('$stackTrace');
      return <FamilyMember>[];
    }
  }

  Future<void> saveMembers(List<FamilyMember> members) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(members.map((m) => m.toJson()).toList());
    await prefs.setString(_membersKey, jsonString);
  }
}
