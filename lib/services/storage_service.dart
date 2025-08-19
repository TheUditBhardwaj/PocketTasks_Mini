import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _storageKey = 'pocket_tasks_v1';

  static Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_storageKey);

      if (tasksJson == null) return [];

      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((json) => Task.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(tasks.map((task) => task.toMap()).toList());
      await prefs.setString(_storageKey, tasksJson);
    } catch (e) {
      // Handle error silently in production app
    }
  }
}
