import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_aplication/data/local/task.dart';
import 'package:todo_aplication/main.dart';
import 'package:todo_aplication/models/screens/edit/cubit/edit_task_cubit.dart';

class EditTaskList extends StatefulWidget {
  const EditTaskList({
    Key? key,
  }) : super(key: key);

  @override
  State<EditTaskList> createState() => _EditTaskListState();
}

class _EditTaskListState extends State<EditTaskList> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: themeData.colorScheme.surface,
          foregroundColor: themeData.colorScheme.onSurface,
          title: const Text('Edit Task')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EditTaskCubit>().onSaveChangesClick();

            Navigator.of(context).pop();
          },
          label: Row(
            children: const [
              Text('Save Change'),
              Icon(
                CupertinoIcons.check_mark,
                size: 18,
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.periority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Periority.high);
                          },
                          label: 'High',
                          color: highPriority,
                          isSelected: priority == Periority.high,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Periority.normal);
                          },
                          label: 'Normal',
                          color: normalPriority,
                          isSelected: priority == Periority.normal,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Periority.low);
                          },
                          label: 'Low',
                          color: lowPriority,
                          isSelected: priority == Periority.low,
                        )),
                  ],
                );
              },
            ),
            TextField(
              controller: _textEditingController,
              onChanged: (value) {
                context.read<EditTaskCubit>().onTextChanged(value);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Text(
                    'Add a Task For Today ...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(fontSizeFactor: 1.2),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {Key? key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                width: 2, color: secondryTextColor.withOpacity(0.2))),
        child: Stack(children: [
          Center(
            child: Text(label),
          ),
          Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                  child: CheckBoxShape(
                value: isSelected,
                color: color,
              )))
        ]),
      ),
    );
  }
}

class CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const CheckBoxShape({Key? key, required this.value, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Builder(builder: (context) {
      return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: color),
          child: value
              ? Icon(
                  CupertinoIcons.check_mark,
                  color: themeData.colorScheme.onPrimary,
                  size: 12,
                )
              : null);
    });
  }
}
