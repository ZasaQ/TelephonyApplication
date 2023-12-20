import 'package:flutter/material.dart';
import 'package:telephon_application/controllers/crud_services.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  TextEditingController _nameController=TextEditingController();
  TextEditingController _phoneNumberController=TextEditingController();
  TextEditingController _emailController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj kontakt"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children:[
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                    return null;
                  },
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.contacts),
                    label: Text("Nazwa"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                    return null;
                  },
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.phone),
                    label: Text("+48 500600700"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                    return null;
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                    label: Text("E-mail"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      CrudServices().addContacts(_nameController.text, _phoneNumberController.text, _emailController.text);
                      _nameController.clear();
                      _emailController.clear();
                      _phoneNumberController.clear();
                    }
                  },
                  child: Text(
                    "Dodaj",
                    style:TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}