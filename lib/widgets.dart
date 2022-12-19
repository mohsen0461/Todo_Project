import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_aplication/main.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/task_khub.png",
          width: 290,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Your Task List Is Empty",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Insert a Task ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        const Icon(
          CupertinoIcons.download_circle,
          size: 30,
        )
      ],
    );
  }
}


class MyCheckBox extends StatelessWidget {
  final bool value;
  final Function() onTap;
  const MyCheckBox({Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: !value
                  ? Border.all(color: secondryTextColor, width: 2)
                  : null,
              color: value ? primaryColor : null),
          child: value
              ? Icon(
                  CupertinoIcons.check_mark,
                  color: themeData.colorScheme.onPrimary,
                  size: 16,
                )
              : null),
    );
  }
}