import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppiz/main.dart';

import '../widgets/main_drawer.dart';

import '../widgets/badge.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/events.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/events';
  @override
  EventScreenState createState() => EventScreenState();
}
class EventScreenState extends State {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final  _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demande de RDV"),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'text',
                      style: Theme.of(context).textTheme.body1,
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                      decoration: InputDecoration(labelText: "Nom    Prénom"),
                    ),
                    FormBuilderDateTimePicker(
                      name: "date de RDV souhaité",
                      style: Theme.of(context).textTheme.body1,
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                      format: DateFormat("dd-MM-yyyy"),
                      decoration: InputDecoration(labelText: "date de RDV souhaité"),
                    ),
                    FormBuilderDropdown(
                      name: "Type de soins",
                      style: Theme.of(context).textTheme.body1,
                      decoration: InputDecoration(labelText: "But"),
                      // initialValue: 'Male',
                      hint: Text('choisissez le but du RDV'),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                      items: ['Urgence', 'Soins', 'Implants','Bridge', 'Couronnes','Lasers','Esthetique']
                          .map((gender) => DropdownMenuItem(
                          value: gender, child: Text("$gender")))
                          .toList(),
                    ),
                    FormBuilderTextField(
                      name: "age",
                      style: Theme.of(context).textTheme.body1,
                      decoration: InputDecoration(labelText: "Age"),
                      keyboardType: TextInputType.number,
                      validator:FormBuilderValidators.compose( [
                        FormBuilderValidators.numeric(context),
                        FormBuilderValidators.max(context,70),
                      ]),
                    ),
                    FormBuilderSlider(
                      name: "slider",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.min(context, 6),
                      ]),
                      min: 0.0,
                      max: 20.0,
                      initialValue: 1.0,
                      divisions: 20,
                      decoration: InputDecoration(
                          labelStyle:   Theme.of(context).textTheme.body1,
                          labelText: "Niveau de douleur"),
                    ),



                    FormBuilderCheckboxGroup (
                      decoration:
                      InputDecoration(labelText: "Langues parlées",labelStyle: Theme.of(context).textTheme.body1,),
                      name: "languages",
                      initialValue: ["Français"],
                      options: [
                        FormBuilderFieldOption(value: "Français"),
                        FormBuilderFieldOption(value: "English"),
                        FormBuilderFieldOption(value: "Arabic"),
                        FormBuilderFieldOption(value: "Espagnol"),
                        FormBuilderFieldOption(value: "Other")
                      ],
                    ),

                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      title: Text(
                        "je confirme la veracité de mes données ",),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators. required(
                          context,
                          errorText:
                          'Confirmation des termes exigée',
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    child: Text("Submit",style: TextStyle(color: Colors.white),),
                    color: Colors.green,
                    onPressed: () async {
                      _fbKey.currentState.save();
                      if (_fbKey.currentState.validate()) {
                        await Provider.of<Events>(context, listen: false).rdvdemande("sarah","bitan","rdv mal odent");
                      }
                    },
                  ),
                  MaterialButton(
                    child: Text("Reset",style: TextStyle(color: Colors.white),),
                    color: Colors.deepOrange,
                    onPressed: () {
                      _fbKey.currentState.reset();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
