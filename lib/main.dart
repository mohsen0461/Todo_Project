import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_aplication/data/Repo/repository.dart';
import 'package:todo_aplication/data/local/task.dart';
import 'package:todo_aplication/data/source/hive_task_source.dart';
import 'package:todo_aplication/models/screens/home/home.dart';

const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PeriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryContainerColor));
  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) {
        return Repository<TaskEntity>(
            HiveTaskDataSource(Hive.box(taskBoxName)));
      },
      child: const MyApp()));
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryContainerColor = Color(0xff5C0AFF);
const secondryTextColor = Color(0xffAFBED0);
const normalPriority = Color(0xffF09819);
const lowPriority = Color(0xff3BE1F1);
const highPriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
              headline6: TextStyle(fontWeight: FontWeight.bold))),
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              iconColor: secondryTextColor,
              labelStyle: TextStyle(color: secondryTextColor)),
          colorScheme: const ColorScheme.light(
              primary: primaryColor,
              primaryContainer: primaryContainerColor,
              background: Color(0xffF3F5F8),
              onSurface: primaryTextColor,
              onPrimary: Colors.white,
              onBackground: primaryTextColor,
              secondary: primaryColor,
              onSecondary: Colors.white),
        ),
        home: HomeScreen());
  }
}
