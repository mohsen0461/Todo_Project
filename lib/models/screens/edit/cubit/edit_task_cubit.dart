
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_aplication/data/Repo/repository.dart';
import 'package:todo_aplication/data/local/task.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EditTaskCubit(this._task, this.repository) : super(EditTaskInitial(_task));

  void onSaveChangesClick() {
    repository.createOrUpdate(_task);
  }

  void onTextChanged(String text) {
    _task.name = text;
  }

  void onPriorityChanged(Periority prioryty) {
    _task.periority = prioryty;
    emit(EditTaskPriorityChange(_task));
  }
}
