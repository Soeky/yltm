import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event.dart';
import '../widgets/event_list.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _addEvent(String title) {
    final event = Event(title);
    setState(() {
      _events[_selectedDay!] = _getEventsForDay(_selectedDay!)..add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalender')),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8),
          Expanded(child: EventList(events: _getEventsForDay(_selectedDay ?? _focusedDay))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final title = await _showAddEventDialog(context);
                if (title != null) {
                  _addEvent(title);
                }
              },
              child: Text('Neues Ereignis hinzufügen'),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showAddEventDialog(BuildContext context) async {
    String? eventTitle;
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Neues Ereignis'),
        content: TextField(
          onChanged: (value) => eventTitle = value,
          decoration: InputDecoration(hintText: 'Ereignis Titel'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, eventTitle),
            child: Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }
}
