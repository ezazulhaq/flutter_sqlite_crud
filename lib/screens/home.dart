import 'package:flutter/material.dart';
import 'package:sqlite_crud/components/submit_button.dart';
import 'package:sqlite_crud/constant.dart';
import 'package:sqlite_crud/models/contact.dart';

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
                        press: () {
                          var form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            setState(() {
                              _contacts.add(
                                Contact(
                                  id: null,
                                  name: _contact.name,
                                  mobile: _contact.mobile,
                                ),
                              );
                            });
                            form.reset();
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
                          trailing: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.more_vert_sharp),
                          ),
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
