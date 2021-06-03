import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/category/bloc/allcategory/bloc.dart';
import 'package:todo_flutter/category/domain/model/category.dart';
import 'package:todo_flutter/common/widgets/date_time_picker.dart';
import 'package:todo_flutter/task/bloc/addtodo/add_todo_bloc.dart';
import 'package:todo_flutter/task/bloc/addtodo/bloc.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';

class AddTodoPage extends StatefulWidget {
  static const String tag = '/add-todo';

  const AddTodoPage({Key key, this.pageController, this.categories}) : super(key: key);

  final PageController pageController;
  final List<Category> categories;

  @override
  AddTodoPageState createState() => new AddTodoPageState();
}

class AddTodoPageState extends State<AddTodoPage> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final selectedDate = DateTime.now();

  final _myControllerTitle = TextEditingController();
  final _myControllerDesc = TextEditingController();
  AddTodoBloc _addTodoBloc;
  CategoryBloc _categoryBloc;
  List<Category> categories;
  Category _currentValue;

  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = const TimeOfDay(hour: 07, minute: 28);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
    _addTodoBloc = BlocProvider.of<AddTodoBloc>(context);
    _myControllerTitle.addListener(_onTitleChanged);
    _myControllerDesc.addListener(_onDescriptionChanged);
    if (_categoryBloc.state is CategoryLoaded) {
      categories = _categoryBloc.state.props.first;
    } else {
      categories = widget.categories;
    }
    _currentValue = categories.first;
  }

  bool get isPopulated =>
      _myControllerTitle.text.isNotEmpty && _myControllerDesc.text.isNotEmpty;

  bool isAddTodoButtonEnabled(AddTodoState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _onTitleChanged() {
    _addTodoBloc.add(
      TitleChanged(title: _myControllerTitle.text),
    );
  }

  void _onDescriptionChanged() {
    _addTodoBloc.add(
      DescriptionChanged(description: _myControllerDesc.text),
    );
  }

  void _onFormSubmitted() {
    _addTodoBloc.add(
      AddTodoButtonPressed(
          title: _myControllerTitle.text,
          description: _myControllerDesc.text,
          endDate: _endDate,
          endTime: _endTime,
          category: _currentValue),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myControllerTitle.dispose();
    _myControllerDesc.dispose();
    super.dispose();
  }

  final Function decoration = (String text, Icon icon) => InputDecoration(
        prefixIcon: icon,
        hintText: text,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.pageController.previousPage(
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
        title: Text('Add new Todo'),
        actions: <Widget>[],
      ),
      body: BlocListener<AddTodoBloc, AddTodoState>(
        listener: (context, state) async {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(state.message),
                      ),
                      Icon(Icons.error)
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: Duration(minutes: 5),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Adding Todo...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Todo added successfully ...'),
                      Icon(Icons.check)
                    ],
                  ),
                ),
              );
            await Future.delayed(Duration(seconds: 3));

            widget.pageController.animateToPage(1,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
            BlocProvider.of<TodoBloc>(context)..add(RefreshTodo());
          }
        },
        child: BlocBuilder<AddTodoBloc, AddTodoState>(
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 48.0),
                    Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        TextFormField(
                          maxLength: 25,
                          controller: _myControllerTitle,
                          keyboardType: TextInputType.text,
                          autovalidate: true,
                          autocorrect: false,
                          autofocus: false,
                          decoration: decoration('Enter title',
                              new Icon(Icons.title, color: Colors.green)),
                          validator: (_) {
                            return !state.isTitleValid ? 'Invalid Title' : null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          maxLength: 150,
                          minLines: 5,
                          maxLines: 6,
                          controller: _myControllerDesc,
                          keyboardType: TextInputType.multiline,
                          autovalidate: true,
                          autocorrect: false,
                          autofocus: false,
                          decoration: decoration('Enter description',
                              new Icon(Icons.description, color: Colors.green)),
                          validator: (_) {
                            return !state.isDescriptionValid
                                ? 'Invalid Description'
                                : null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        new DropdownButton<Category>(
                          isExpanded: true,
                          value: _currentValue,
                          items: categories != null ? categories.map((Category value) {
                            return new DropdownMenuItem<Category>(
                              value: value,
                              child: new Text(value.name),
                            );
                          }).toList() : null,
                          onChanged: (Category newValue) {
                            setState(() {
                              this._currentValue = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 8.0),
                        new DateTimePicker(
                          labelText: 'Choose Dead Line',
                          selectedDate: _endDate,
                          selectedTime: _endTime,
                          selectDate: (DateTime date) {
                            setState(() {
                              _endDate = date;
                            });
                          },
                          selectTime: (TimeOfDay time) {
                            setState(() {
                              _endTime = time;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ButtonTheme(
                            minWidth: double.infinity,
                            child: Builder(
                              builder: (context) => RaisedButton(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: isAddTodoButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                                padding: EdgeInsets.all(12),
                                color: Colors.green,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(height: 48.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
