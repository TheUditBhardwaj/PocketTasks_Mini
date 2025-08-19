import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

enum TaskFilter { all, active, done }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = '';
  TaskFilter _currentFilter = TaskFilter.all;
  Timer? _debounceTimer;

  List<Task> get filteredTasks => _filteredTasks;
  String get searchQuery => _searchQuery;
  TaskFilter get currentFilter => _currentFilter;

  int get completedCount => _tasks.where((task) => task.done).length;
  int get totalCount => _tasks.length;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await StorageService.loadTasks();
    _applyFilters();
  }

  Future<void> _saveTasks() async {
    await StorageService.saveTasks(_tasks);
  }

  void _applyFilters() {
    _filteredTasks = _tasks.where((task) {
      // Apply search filter
      bool matchesSearch = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase());

      // Apply status filter
      bool matchesFilter = switch (_currentFilter) {
        TaskFilter.all => true,
        TaskFilter.active => !task.done,
        TaskFilter.done => task.done,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    // Sort by creation date (newest first)
    _filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title.trim(),
      createdAt: DateTime.now(),
    );

    _tasks.insert(0, task);
    await _saveTasks();
    _applyFilters();
  }

  Future<void> toggleTask(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(done: !_tasks[index].done);
      await _saveTasks();
      _applyFilters();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    _applyFilters();
  }

  Future<void> restoreTask(Task task) async {
    _tasks.insert(0, task);
    await _saveTasks();
    _applyFilters();
  }

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = query;
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
