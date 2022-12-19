import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_aplication/data/Repo/repository.dart';
import 'package:todo_aplication/data/local/task.dart';
import 'package:todo_aplication/main.dart';
import 'package:todo_aplication/models/screens/edit/cubit/edit_task_cubit.dart';
import 'package:todo_aplication/models/screens/edit/edit_task.dart';
import 'package:todo_aplication/models/screens/home/bloc/task_list_bloc.dart';
import 'package:todo_aplication/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider<EditTaskCubit>(
                      create: (context) => EditTaskCubit(
                          TaskEntity(), context.read<Repository<TaskEntity>>()),
                      child: const EditTaskList(),
                    )));
          },
          label: Row(
            children: const [Text('Add New Task'), Icon(Icons.add)],
          )),
      body: BlocProvider<TaskListBloc>(
        create: (BuildContext context) =>
            TaskListBloc(context.read<Repository<TaskEntity>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  themeData.colorScheme.primary,
                  themeData.colorScheme.primaryContainer
                ])),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.headline6!
                                .apply(color: themeData.colorScheme.onPrimary),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: themeData.colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20)
                            ]),
                        child: TextField(
                          onChanged: (value) {
                            context
                                .read<TaskListBloc>()
                                .add(TaskListSearch(value));
                          },
                          controller: textEditingController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(CupertinoIcons.search),
                              label: Text('Search tasks ...')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(child: Consumer<Repository<TaskEntity>>(
                builder: (context, value, child) {
                  context.read<TaskListBloc>().add(TaskListStarted());
                  return BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {
                      if (state is TaskListSuccess) {
                        return TaskList(
                            items: state.items, themeData: themeData);
                      } else if (state is TaskListEmpty) {
                        return EmptyState(
                          key: key,
                        );
                      } else if (state is TaskListLoading ||
                          state is TaskListInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TaskListErorr) {
                        return Center(child: Text(state.erorrMessage));
                      } else {
                        throw Exception('state is not Valid ...');
                      }
                    },
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.items,
    required this.themeData,
  }) : super(key: key);

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: themeData.textTheme.headline6!
                          .apply(fontSizeFactor: 0.8),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: themeData.primaryColor,
                          borderRadius: BorderRadius.circular(1.5)),
                      width: 70,
                      height: 3,
                    )
                  ],
                ),
                MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteAll());
                  },
                  color: const Color(0xffEAEFF5),
                  textColor: secondryTextColor,
                  child: Row(
                    children: const [
                      Text('Delete All'),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        CupertinoIcons.delete_solid,
                        size: 18,
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            final TaskEntity task = items[index - 1];
            return TaskItem(task: task);
          }
        });
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 74;
  static const double borderRadius = 8;
  final TaskEntity task;
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Color priorityColor;

    switch (widget.task.periority) {
      case Periority.low:
        priorityColor = lowPriority;
        break;
      case Periority.normal:
        priorityColor = normalPriority;
        break;
      case Periority.high:
        priorityColor = highPriority;
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(
                    widget.task, context.read<Repository<TaskEntity>>()),
                child: const EditTaskList())));
      },
      onLongPress: () {
        context.read<TaskListBloc>().add(TaskListDelete(widget.task));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(
          left: 16,
        ),
        height: TaskItem.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TaskItem.borderRadius),
            color: themeData.colorScheme.surface,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.2))
            ]),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 5,
              height: TaskItem.height,
              decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(TaskItem.borderRadius),
                      bottomRight: Radius.circular(TaskItem.borderRadius))),
            )
          ],
        ),
      ),
    );
  }
}
