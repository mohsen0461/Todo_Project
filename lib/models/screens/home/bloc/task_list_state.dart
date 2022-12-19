part of 'task_list_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListSuccess extends TaskListState {
  final List<TaskEntity> items;

  TaskListSuccess(this.items);
}

class TaskListEmpty extends TaskListState {}

class TaskListErorr extends TaskListState {
  final String erorrMessage;

  TaskListErorr(this.erorrMessage);
}
