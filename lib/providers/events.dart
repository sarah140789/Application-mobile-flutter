import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Events extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> rdvdemande(String email, String userid,String action) async {
    await FirebaseFirestore.instance.collection("rdvdemande").add({
      'email': email,
      'uid': userid,
      'action': action,
      'date': DateTime.now(),
    });
  }


  //////////////////////////////////////////////////
  ////// RDV
  //////////////////////////////////////////////////
  Future<void>  rdvplanning( String douleur, String nom, String prenom,String soin,String dateRDV,String heureRDV) async {

    var dateTime1 = DateFormat('yyyy-MM-dd').parse(dateRDV);


    await FirebaseFirestore.instance.collection("planning").add({
      'titre': soin,
      'nom': nom,
      'prenom': prenom,
      'douleur': douleur.toString().substring(0,douleur.toString().indexOf('.')),
      'jour': dateTime1.day.toString(),
      'mois': dateTime1.month.toString(),
      'an': dateTime1.year.toString(),
      'heure': heureRDV.toString().substring(0,douleur.toString().indexOf('.')),
      'min': '0',
      'duree': '60',
    });
  }



  //////////////////////////////////////////////////
  ////// ARTICLE
  //////////////////////////////////////////////////
  Future<void>  edition(String typaticle, String titre, String resume, String corps,String imurl,String impath, String priorite,String publication) async {

    await FirebaseFirestore.instance.collection("Allarticles").add({
      'typaticle':typaticle,
      'titre':titre,
      'resume':resume,
      'corps':corps,
      'imurl':imurl,
      'impath':impath ,
      'publication':publication,
      'priorite':priorite,
    });
  }

///////////////////////////////////////////////////////////
///// isadmin
/////////////////////////////////////////////////////////////
  isadmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('auteur');
    if(stringValue=="metaladmin")return true; else false;
  }


  }