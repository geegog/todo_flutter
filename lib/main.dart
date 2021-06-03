import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/authentication/bloc.dart';
import 'package:todo_flutter/category/bloc/addcategory/add_category_bloc.dart';
import 'package:todo_flutter/category/bloc/addcategory/add_category_state.dart';
import 'package:todo_flutter/category/bloc/allcategory/bloc.dart';
import 'package:todo_flutter/common/bloc/register/bloc.dart';
import 'package:todo_flutter/common/bloc/simple_bloc_delegate.dart';
import 'package:todo_flutter/common/pages/home.dart';
import 'package:todo_flutter/common/pages/login_page.dart';
import 'package:todo_flutter/task/bloc/addtodo/add_todo_bloc.dart';
import 'package:todo_flutter/task/bloc/addtodo/add_todo_state.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';
import 'package:todo_flutter/task/bloc/comment/add_comment_bloc.dart';
import 'package:todo_flutter/task/bloc/comment/add_comment_state.dart';
import 'category/domain/model/category.dart';
import 'category/services/category_service.dart';
import 'common/bloc/login/bloc.dart';
import 'common/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  await setupLocator();

  List<Category> categories = await CategoryService().getCategories();
  //print(categories.first);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc()..add(AppStarted()),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider<AddTodoBloc>(
          create: (context) => AddTodoBloc(),
        ),
        BlocProvider<AddCategoryBloc>(
          create: (context) => AddCategoryBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider<AddCommentBloc>(
          create: (context) => AddCommentBloc(),
        ),
      ],
      child: MyApp(categories: categories,),
    ),
  );
}

class MyApp extends StatelessWidget {

  final List<Category> _categories;

  MyApp({Key key, @required List<Category> categories})
      : assert(categories != null),
        _categories = categories,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previousState, currentState) {
          return true;
        },
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider(
              create: (context) => TodoBloc()..add(FetchTodo()),
              child: TodoHomePage(categories: this._categories,),
            );
          } else {
            return BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(LoginState.empty()),
              child: LoginPage(),
            );
          }
        },
      ),
    );
  }
}
