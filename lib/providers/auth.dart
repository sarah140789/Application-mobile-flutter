import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {
  DateTime _expiryDate;
  String _userId;
  String _erreur;
  Timer _authTimer;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth {
    return _userId != null;
  }

  String get userId {
    return _userId;
  }

  String get erreur {
    return _erreur;
  }


  Future<void> signup(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User user = FirebaseAuth.instance.currentUser;
      TraceUser(email, user.uid,"signup");
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        DateTime today = new DateTime.now();
        String dateSlug ="${today.day.toString().padLeft(2,'0')}-${today.month.toString().padLeft(2,'0')}-${today.year.toString()}";
        await
        FirebaseFirestore.instance.collection('utilisateurs').doc(email).collection('rdv').doc("0").set({
          'Title ': "Bienvenue premiere connexion",
          'datev': dateSlug,
        }).catchError((e) {
          print(e);
        });;
        return null;
      } else{
        return user.uid;}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('le mot de passe n\'est pas assez securisé.');
      } else if (e.code == 'email-already-in-use') {
        print('Le compte existe deja pour cet email.');
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<String> login(final String email, final String password) async {
    final myPrefs = await SharedPreferences.getInstance();
    String erreur="No";
    myPrefs.setString("email", email);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User user = FirebaseAuth.instance.currentUser;
      if (!user.emailVerified) {
        erreur="Vous Devez cliquer sur le lien envoye par Mail pour activer votre compte";
      }
      TraceUser(email, user.uid,"login");

      this._userId=user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        erreur="Aucun utilisateur enregistré avec cet email ";
      } else if (e.code == 'wrong-password') {
        erreur="Mauvais Mot de Passe  ";
      }
    }
    this._erreur=erreur;
    myPrefs.setString("erreur", erreur);
    notifyListeners();
    return _userId;
  }


  Future<void> TraceUser(String email, String userid,String action) async {
    await FirebaseFirestore.instance.collection("users").add({
      'email': email,
      'uid': userid,
      'action': action,
      'connect': DateTime.now(),
    });
  }

  Future<void> logout() async {
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }
}
