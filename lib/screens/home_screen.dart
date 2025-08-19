import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/progress_ring.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskController = TextEditingController();
  final _searchController = TextEditingController();
  String? _addTaskError;

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTask(BuildContext context) {
    final title = _taskController.text.trim();

    if (title.isEmpty) {
      setState(() {
        _addTaskError = 'Task title cannot be empty';
      });
      return;
    }

    context.read<TaskProvider>().addTask(title);
    _taskController.clear();
    setState(() {
      _addTaskError = null;
    });
  }

  void _toggleTask(BuildContext context, String taskId, String taskTitle, bool currentDone) {
    context.read<TaskProvider>().toggleTask(taskId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentDone ? 'Task unmarked' : 'Task completed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => context.read<TaskProvider>().toggleTask(taskId),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _deleteTask(BuildContext context, task) {
    context.read<TaskProvider>().deleteTask(task.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${task.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => context.read<TaskProvider>().restoreTask(task),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with progress ring
              Row(
                children: [
                  Consumer<TaskProvider>(
                    builder: (context, provider, _) => ProgressRing(
                      completed: provider.completedCount,
                      total: provider.totalCount,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'PocketTasks',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Add task input
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _taskController,
                          decoration: InputDecoration(
                            hintText: 'Add Task',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onSubmitted: (_) => _addTask(context),
                          onChanged: (_) {
                            if (_addTaskError != null) {
                              setState(() {
                                _addTaskError = null;
                              });
                            }
                          },
                        ),
                        if (_addTaskError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 16),
                            child: Text(
                              _addTaskError!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => _addTask(context),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Search box
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) => context.read<TaskProvider>().setSearchQuery(value),
              ),

              const SizedBox(height: 20),

              // Filter chips
              Consumer<TaskProvider>(
                builder: (context, provider, _) => Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: provider.currentFilter == TaskFilter.all,
                      onSelected: () => provider.setFilter(TaskFilter.all),
                    ),
                    const SizedBox(width: 12),
                    _FilterChip(
                      label: 'Active',
                      isSelected: provider.currentFilter == TaskFilter.active,
                      onSelected: () => provider.setFilter(TaskFilter.active),
                    ),
                    const SizedBox(width: 12),
                    _FilterChip(
                      label: 'Done',
                      isSelected: provider.currentFilter == TaskFilter.done,
                      onSelected: () => provider.setFilter(TaskFilter.done),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Task list
              Expanded(
                child: Consumer<TaskProvider>(
                  builder: (context, provider, _) {
                    if (provider.filteredTasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tasks found',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: provider.filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = provider.filteredTasks[index];
                        return Dismissible(
                          key: Key(task.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Theme.of(context).colorScheme.error,
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.onError,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _deleteTask(context, task),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () => _toggleTask(context, task.id, task.title, task.done),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: task.done
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.outline,
                                      width: 2,
                                    ),
                                    color: task.done
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                  ),
                                  child: task.done
                                      ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  )
                                      : null,
                                ),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.done ? TextDecoration.lineThrough : null,
                                  color: task.done
                                      ? Theme.of(context).colorScheme.outline
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              onTap: () => _toggleTask(context, task.id, task.title, task.done),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
