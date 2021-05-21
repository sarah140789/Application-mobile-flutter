import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../screens/planning_screen.dart';
import '../providers/events.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class rdvScreen extends StatefulWidget {
  static const routeName = '/rdv';
  @override
  rdvScreenState createState() => rdvScreenState();
}
class rdvScreenState extends State {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final  _fbKey = GlobalKey<FormBuilderState>();
  Map<String, String> _RdvData = {
    'nom': '',
    'prenom': '',
    'mobile': '',
    'dateRDV': '',
    'heureRDV': '',
    'soin': '',
    'age': '',
  };
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
                      name: 'nom',
                      style: Theme.of(context).textTheme.body1,
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context),
                        FormBuilderValidators.match(context,
                            r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$",
                            errorText: 'Le Nom contient uniquement des lettre')
                      ]),
                      decoration: InputDecoration(labelText: "Nom "),
                      onSaved: (value) {
                        _RdvData['nom'] = value;
                      },
                    ),
                    FormBuilderTextField(
                      name: 'prenom',
                      style: Theme.of(context).textTheme.body1,
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context),
                        FormBuilderValidators.match(context,
                            r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$",
                            errorText: 'Le Prenom contient uniquement des lettre')
                      ]),
                      decoration: InputDecoration(labelText: "Prenom "),
                      onSaved: (value) {
                        _RdvData['prenom'] = value;
                      },
                    ),

                    FormBuilderTextField(
                      name: 'mobile',
                      style: Theme.of(context).textTheme.body1,
                      validator:FormBuilderValidators.compose( [
                        FormBuilderValidators.numeric(context),
                        FormBuilderValidators.minLength(context,7),
                        FormBuilderValidators.maxLength(context,10),
                      ]),
                      decoration: InputDecoration(labelText: "Mobile "),
                      onSaved: (value) {
                        _RdvData['mobile'] = value;
                      },
                    ),

                    FormBuilderDateTimePicker(
                      name: "dateRDV",
                      style: Theme.of(context).textTheme.body1,
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(labelText: "date de RDV souhaité"),
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                      locale: Locale.fromSubtags(languageCode: 'fr'),
                      onSaved: (value) {
                        _RdvData['dateRDV'] = value.toString();
                      },
                    ),

                    FormBuilderSlider(
                      name: "slider2",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.min(context, 8),
                        FormBuilderValidators.max(context, 19),
                      ]),
                      min: 8.0,
                      max: 20.0,
                      initialValue: 9.0,
                      divisions: 12,
                      decoration: InputDecoration(
                          labelStyle:   Theme.of(context).textTheme.body1,
                          labelText: "Heure RDV"),

                      onSaved: (value) {
                        _RdvData['heureRDV'] = (value).toString();
                      },

                    ),

                    FormBuilderDropdown(
                      name: "Typesoins",
                      style: Theme.of(context).textTheme.body1,
                      decoration: InputDecoration(labelText: "But"),
                      // initialValue: 'Male',
                      hint: Text('choisissez le but du RDV'),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                      items: ['Urgence', 'Soins', 'Implants','Bridge', 'Couronnes','Lasers','Esthetique']
                          .map((gender) => DropdownMenuItem(
                          value: gender, child: Text("$gender")))
                          .toList(),
                      onSaved: (value) {
                        _RdvData['soin'] = value;
                      },
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
                      onSaved: (value) {
                        _RdvData['age']=value;
                      },
                    ),
                    FormBuilderSlider(
                      name: "slider",
                      min: 0.0,
                      max: 20.0,
                      initialValue: 1.0,
                      divisions: 20,
                      decoration: InputDecoration(
                          labelStyle:   Theme.of(context).textTheme.body1,
                          labelText: "Niveau de douleur"),
                      onSaved: (value) {
                        _RdvData['douleur']=value.toString();
                      },
                    ),



                    FormBuilderCheckboxGroup (
                      decoration:
                      InputDecoration(labelText: "Langues parlées",labelStyle: Theme.of(context).textTheme.body1,),
                      name: "Info Patient :",
                      initialValue: ["Français"],
                      options: [
                        FormBuilderFieldOption(value: "Deja Patient"),
                        FormBuilderFieldOption(value: "Nouveau patient"),
                        FormBuilderFieldOption(value: "Urgence"),
                        FormBuilderFieldOption(value: "Mutuelle"),
                        FormBuilderFieldOption(value: "Secu")
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
                        await Provider.of<Events>(context, listen: false).rdvdemande( _RdvData['identite'],"bitan",_RdvData['soin']);
                        await Provider.of<Events>(context, listen: false).rdvplanning( _RdvData['douleur'],_RdvData['nom'],_RdvData['prenom'],_RdvData['soin'],_RdvData['dateRDV'],_RdvData['heureRDV']);
                        Navigator.of(context).pushReplacementNamed(planningScreen.routeName);
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
