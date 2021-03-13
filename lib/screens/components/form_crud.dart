import 'package:flutter/material.dart';
import 'package:sqlite_crud/components/submit_button.dart';
import 'package:sqlite_crud/models/contact.dart';

class FormCRUD extends StatefulWidget {
  const FormCRUD({
    Key key,
    this.formKey,
    this.contact,
    this.contacts,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Contact contact;
  final List<Contact> contacts;

  @override
  _FormCRUDState createState() => _FormCRUDState();
}

class _FormCRUDState extends State<FormCRUD> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
      child: Container(
        color: Colors.white,
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter Full Name",
                ),
                onSaved: (newValue) {
                  setState(() {
                    widget.contact.name = newValue;
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
                    widget.contact.mobile = newValue;
                  });
                },
                validator: (value) =>
                    value.length < 10 ? "Atleast 10 characters Required" : null,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: double.infinity,
                height: 50.0,
                child: SubmitButton(
                  press: () {
                    var form = widget.formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      widget.contacts.add(widget.contact);
                      print(widget.contact.name);
                    }
                  },
                  text: "Submit",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
