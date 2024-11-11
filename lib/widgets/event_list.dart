import 'package:flutter/material.dart';
import '../models/event.dart';

class EventList extends StatelessWidget {
  final List<Event> events;

  EventList({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(child: Text('Keine Ereignisse an diesem Tag'));
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index].title),
        );
      },
    );
  }
}
