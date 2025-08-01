import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relogio_flutter/data/models/alarme_model.dart';

class AlarmesStorage {
  static const _key = 'alarmes';

  static Future<List<AlarmeModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return [];

    final raw = json.decode(jsonStr);
    if (raw is! List) return [];

    return raw
        .map<AlarmeModel>(
          (e) => AlarmeModel.fromJson(
            (e as Map).cast<String, dynamic>(),
          ),
        )
        .toList();
  }

  static Future<void> save(List<AlarmeModel> alarmes) async {
    final prefs = await SharedPreferences.getInstance();
    final list = alarmes.map((e) => e.toJson()).toList();
    await prefs.setString(_key, json.encode(list));
  }
}
