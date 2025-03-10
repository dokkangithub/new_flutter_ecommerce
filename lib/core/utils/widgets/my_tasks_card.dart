import 'package:laravel_ecommerce/core/utils/extension/responsive_extension.dart';
import 'package:flutter/material.dart';

import '../../../config/themes.dart/theme.dart';
import '../../providers/localization/app_localizations.dart';
import '../constants/app_assets.dart';
import 'custom_border_container_idget.dart';

class MyTasksCard extends StatelessWidget {
  final List<TaskModel> tasks;

  const MyTasksCard({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBorderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            spacing: 4,
            children: [
              const Icon(Icons.list,color: AppTheme.primaryColor,size: 24),
              Text(
                AppLocalizations.of(context).translate('my_tasks'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fixed height container with scroll
          SizedBox(
            height: context.responsive(180),
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Enable vertical scrolling
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // Enable horizontal scrolling
                  child: DataTable(
                    columnSpacing: 24,
                    headingRowHeight: 36,
                    columns: [
                      DataColumn(
                        label: Text(
                          "${AppLocalizations.of(context).translate('task')}#",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of(context).translate('task'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of(context).translate('status'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of(context).translate('due_date'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                    rows: tasks.map((task) {
                      return DataRow(cells: [
                        DataCell(
                          Text(
                            task.taskNumber,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Text(
                                task.taskDescription.length > 30
                                    ? "${task.taskDescription.substring(0, 30)}..."
                                    : task.taskDescription,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (task.label != null) // Show label if available
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    task.label!,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              const Icon(Icons.circle,
                                  color: Colors.red, size: 10),
                              const SizedBox(width: 6),
                              Text(
                                task.status,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            task.dueDate,
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Task Model
class TaskModel {
  final String taskNumber;
  final String taskDescription;
  final String? label;
  final String status;
  final String dueDate;

  TaskModel({
    required this.taskNumber,
    required this.taskDescription,
    this.label,
    required this.status,
    required this.dueDate,
  });
}
