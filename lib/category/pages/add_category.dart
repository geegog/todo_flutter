import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/category/bloc/addcategory/bloc.dart';
import 'package:todo_flutter/category/bloc/allcategory/bloc.dart';

class AddCategoryPage extends StatefulWidget {
  static const String tag = '/add-category-page';

  AddCategoryPage({Key key}) : super(key: key);

  @override
  AddCategoryPageState createState() => AddCategoryPageState();
}

class AddCategoryPageState extends State<AddCategoryPage> {

  final _formKey = new GlobalKey<FormState>();
  final _myControllerName = TextEditingController();
  AddCategoryBloc _addCategoryBloc;

  final Function decoration = (String text, Icon icon) => InputDecoration(
    prefixIcon: icon,
    hintText: text,
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addCategoryBloc = BlocProvider.of<AddCategoryBloc>(context);
    _myControllerName.addListener(_onNameChanged);
  }

  bool get isPopulated =>
      _myControllerName.text.isNotEmpty;

  bool isAddCategoryButtonEnabled(AddCategoryState state) {
    return state.isFormValid && isPopulated;
  }

  void _onNameChanged() {
    _addCategoryBloc.dispatch(
      NameChanged(name: _myControllerName.text),
    );
  }

  void _onFormSubmitted() {
    _addCategoryBloc.dispatch(
      AddCategoryButtonPressed(
          name: _myControllerName.text,),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _myControllerName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Categories'),
      ),
      body: BlocListener<AddCategoryBloc, AddCategoryState>(
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
                      Text('Adding Category...'),
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
                      Text('Category added successfully ...'),
                      Icon(Icons.check)
                    ],
                  ),
                ),
              );
            await Future.delayed(Duration(seconds: 3));
            BlocProvider.of<CategoryBloc>(context)..dispatch(RefreshCategory());
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<AddCategoryBloc, AddCategoryState>(
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
                          controller: _myControllerName,
                          keyboardType: TextInputType.text,
                          autovalidate: true,
                          autocorrect: false,
                          autofocus: false,
                          decoration: decoration('Enter name',
                              new Icon(Icons.title, color: Colors.green)),
                          validator: (_) {
                            return !state.isNameValid ? 'Invalid Category Name' : null;
                          },
                        ),
                        SizedBox(height: 8.0),
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
                                onPressed: isAddCategoryButtonEnabled(state)
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
