import 'package:flutter/material.dart';
import 'package:sqlite_crud/components/submit_button.dart';
import 'package:sqlite_crud/constant.dart';
import 'package:sqlite_crud/models/contact.dart';
import 'package:sqlite_crud/models/util/database_helper.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  Contact _contact = Contact();
  List<Contact> _contacts = [];
  final _controlName = TextEditingController();
  final _controlMobile = TextEditingController();

  DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();

    setState(() {
      _databaseHelper = DatabaseHelper.instance;
      _databaseHelper.deleteAllData();
      _refrestContactList();
    });
  }

  _refrestContactList() async {
    List<Contact> x = await _databaseHelper.fetchContacts();
    _contacts = x;
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _controlName.clear();
      _controlMobile.clear();
      _contact.id = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controlName,
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Enter Full Name",
                      ),
                      onSaved: (newValue) {
                        setState(() {
                          _contact.name = newValue;
                        });
                      },
                      validator: (value) =>
                          value.length == 0 ? "This field is Required" : null,
                    ),
                    TextFormField(
                      controller: _controlMobile,
                      decoration: InputDecoration(
                        labelText: "Mobile No.",
                        hintText: "Enter Mobile Number",
                      ),
                      onSaved: (newValue) {
                        setState(() {
                          _contact.mobile = newValue;
                        });
                      },
                      validator: (value) => value.length < 10
                          ? "Atleast 10 characters Required"
                          : null,
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 50.0,
                      child: SubmitButton(
                        press: () async {
                          var form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            // setState(() {
                            //   _contacts.add(
                            //     Contact(
                            //       id: null,
                            //       name: _contact.name,
                            //       mobile: _contact.mobile,
                            //     ),
                            //   );
                            // });
                            if (_contact.id == null)
                              await _databaseHelper.insertContact(_contact);
                            else
                              await _databaseHelper.updateContact(_contact);

                            _refrestContactList();
                            _resetForm();
                          }
                        },
                        text: "Submit",
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            color: kPrimaryColor,
                            size: 40.0,
                          ),
                          title: Text(
                            _contacts[index].name.toUpperCase(),
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            _contacts[index].mobile,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_sweep),
                            onPressed: () async {
                              await _databaseHelper
                                  .deleteContact(_contacts[index]);
                              _resetForm();
                              _refrestContactList();
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _contact = _contacts[index];
                              _controlName.text = _contacts[index].name;
                              _controlMobile.text = _contacts[index].mobile;
                            });
                          },
                        ),
                        Divider(
                          height: 5.0,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
