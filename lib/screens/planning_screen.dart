import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../widgets/main_drawer.dart';

/// The hove page which hosts the calendar
class planningScreen extends StatefulWidget {
  static const routeName = '/planning';
  /// Creates the home page to display teh calendar widget.
  const planningScreen({Key key}) : super(key: key);

  @override
  planningScreenState createState() => planningScreenState();
}

class planningScreenState extends State<planningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Planning"),
        ),
        drawer: MainDrawer(),
        body: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_getDataSource()),
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime startTime2 = DateTime(today.year, today.month, today.day, 14, 0, 0);
    final DateTime startTime3 = DateTime(today.year, today.month, today.day, 16, 0, 0);
    final DateTime startTime4 = DateTime(today.year, today.month, today.day+1, 11, 0, 0);
    final DateTime startTime5 = DateTime(today.year, today.month, today.day+2, 10, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting('Bridge', startTime2, endTime, const Color(0xFF0F8622), false));
    meetings.add(Meeting('Chirurgie', startTime3, endTime, const Color(0xFF0F8622), false));
    meetings.add(Meeting('Chirurgie', startTime4, endTime, const Color(0xFF0F8622), false));
    meetings.add(Meeting('Chirurgie', startTime5, endTime, const Color(0xFF0F8622), false));
    return meetings;
  }
}

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