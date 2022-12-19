import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_aplication/data/Repo/repository.dart';
import 'package:todo_aplication/data/local/task.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        final String searchTerm;

        emit(TaskListLoading());

        await Future.delayed(const Duration(seconds: 1));

        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          final items = await repository.getAll(searchKeyWord: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListErorr('خطای نا مشخص'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      } else if (event is TaskListDelete) {
        await repository.delete(event.item);
      }
    });
  }
}
