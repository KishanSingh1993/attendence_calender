import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, String> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _showActivityDialog(selectedDay);
              });
            },
            eventLoader: (day) {
              return _events[day] != null ? [ _events[day]! ] : [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return _buildMarker(date, events.first.toString());
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMarker(DateTime date, String event) {
    Color color;
    switch (event) {
      case 'Present':
        color = Colors.green;
        break;
      case 'Absent':
        color = Colors.red;
        break;
      case 'Holiday':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return Positioned(
      right: 1,
      bottom: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        width: 16.0,
        height: 16.0,
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(Colors.green, 'Present'),
          _buildLegendItem(Colors.red, 'Absent'),
          _buildLegendItem(Colors.blue, 'Holiday'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          width: 16.0,
          height: 16.0,
        ),
        const SizedBox(width: 8.0),
        Text(text),
      ],
    );
  }

  void _showActivityDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.check, color: Colors.green),
                title: Text('Present'),
                onTap: () {
                  _setActivity(date, 'Present');
                },
              ),
              ListTile(
                leading: Icon(Icons.close, color: Colors.red),
                title: Text('Absent'),
                onTap: () {
                  _setActivity(date, 'Absent');
                },
              ),
              ListTile(
                leading: Icon(Icons.beach_access, color: Colors.blue),
                title: Text('Holiday'),
                onTap: () {
                  _setActivity(date, 'Holiday');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setActivity(DateTime date, String activity) {
    setState(() {
      _events[date] = activity;
    });
    Navigator.of(context).pop();
  }
}