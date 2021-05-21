import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../widgets/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:math';


import 'dart:convert';

/// The hove page which hosts the calendar
class planningScreen extends StatefulWidget {
  static const routeName = '/planning';
  /// Creates the home page to display teh calendar widget.
  const planningScreen({Key key}) : super(key: key);

  @override
  planningScreenState createState() => planningScreenState();
}

DataSource _meetings;


class planningScreenState extends State<planningScreen> {
  DataSnapshot querySnapshot;
  List<Meeting> dbmeetings;
  List<Meeting> collectionM;
  List<Color> _colorCollection;
  dynamic data;


  @override
  void initState() {


        () async {
          dbmeetings=  await getRDVFromDatabase();
          print('longueur=='+dbmeetings.length.toString());
      setState(() {
        collectionM=dbmeetings;
      });
    } ();

    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Planning"),
        ),
        drawer: MainDrawer(),
        body: _showCalendar(),
    );
  }


  _showCalendar() {

      return SfCalendar(
        view: CalendarView.timelineMonth ,
        allowedViews: [
          CalendarView.timelineDay,
          CalendarView.timelineWeek,
          CalendarView.timelineMonth,
        ],


        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0, 0) ,
        dataSource: MeetingDataSource(collectionM),
        monthViewSettings: MonthViewSettings(showAgenda: true),
      );
    }
  }



List<Meeting>  _getCalendarDataSource([List<Meeting> collection]) {
  List<Meeting> meetings = collection ?? <Meeting>[];
  List<CalendarResource> resourceColl = <CalendarResource>[];

  return meetings;
}

Future getRDVFromDatabase() async {
    List<Meeting> dbmeetings = [];
    Meeting m;

   await FirebaseFirestore.instance
        .collection('planning')
        .get()
        .then((QuerySnapshot querySnapshot) {
     List<Meeting> col;
      querySnapshot.docs.forEach((doc) {
        final DateTime startTimef = DateTime(int.parse(doc["an"]), int.parse(doc["mois"]), int.parse(doc["jour"]), int.parse(doc["heure"]),int.parse(doc["min"]), 0);
        final duree= int.parse(doc["duree"]);
        final DateTime endTimef = startTimef.add(Duration(minutes:duree));
        var couleur= Color(0xFF0F8622);

        if(int.parse(doc["douleur"])>10) couleur=Colors.deepOrange;
         final titre= doc["titre"]+":"+doc["heure"];
        Meeting m=new Meeting(titre, startTimef, endTimef, couleur, false);
        dbmeetings.add(m);
      });
    });
    return dbmeetings;
  }










  /*
     final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime startTime2 = DateTime(today.year, today.month, today.day, 14, 0, 0);
    final DateTime startTime3 = DateTime(today.year, today.month, today.day, 16, 0, 0);
    final DateTime startTime4 = DateTime(today.year, today.month, today.day+1, 11, 0, 0);
    final DateTime startTime5 = DateTime(today.year, today.month, today.day+2, 10, 0, 0);
    final DateTime endTime = startTime.add(const Duration(minutes: 30));
    collection.add(Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    collection.add(Meeting('Bridge', startTime2, endTime, const Color(0xFF0F8622), false));
    collection.add(Meeting('Chirurgie', startTime3, endTime, const Color(0xFF0F8622), false));
    collection.add(Meeting('Chirurgie', startTime4, endTime, const Color(0xFF0F8622), false));
    collection.add(Meeting('Chirurgie', startTime5, endTime, const Color(0xFF0F8622), false));
*/



/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }



  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}


class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments[index].isAllDay;

  @override
  String getSubject(int index) => appointments[index].eventName;

  @override
  String getStartTimeZone(int index) => appointments[index].startTimeZone;

  @override
  String getNotes(int index) => appointments[index].description;

  @override
  String getEndTimeZone(int index) => appointments[index].endTimeZone;

  @override
  Color getColor(int index) => appointments[index].background;

  @override
  DateTime getStartTime(int index) => appointments[index].from;

  @override
  DateTime getEndTime(int index) => appointments[index].to;
}


/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}