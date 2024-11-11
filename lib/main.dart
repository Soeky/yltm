import 'package:flutter/material.dart';
import '../api/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final int _userId = 1; // Dummy user ID, adjust as needed

  List<dynamic> _tasks = [];
  List<dynamic> _events = [];

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _taskDueDateController = TextEditingController();
  final TextEditingController _eventStartController = TextEditingController();
  final TextEditingController _eventEndController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final tasks = await _apiService.getTasks(_userId);
    final events = await _apiService.getEvents(_userId);
    setState(() {
      _tasks = tasks;
      _events = events;
    });
  }

  Future<void> _createTask() async {
    await _apiService.createTask(
      _userId,
      _taskTitleController.text,
      _taskDueDateController.text,
    );
    _taskTitleController.clear();
    _taskDueDateController.clear();
    _fetchData(); // Refresh data after adding
  }

  Future<void> _createEvent() async {
    await _apiService.createEvent(
      _userId,
      _eventTitleController.text,
      _eventStartController.text,
      _eventEndController.text,
    );
    _eventTitleController.clear();
    _eventStartController.clear();
    _eventEndController.clear();
    _fetchData(); // Refresh data after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Manager')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Input for tasks
            TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _taskDueDateController,
              decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: _createTask,
              child: Text('Create Task'),
            ),

            // Input for events
            TextField(
              controller: _eventTitleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _eventStartController,
              decoration: InputDecoration(labelText: 'Start Time (YYYY-MM-DD HH:MM:SS)'),
            ),
            TextField(
              controller: _eventEndController,
              decoration: InputDecoration(labelText: 'End Time (YYYY-MM-DD HH:MM:SS)'),
            ),
            ElevatedButton(
              onPressed: _createEvent,
              child: Text('Create Event'),
            ),

            // Display tasks
            Expanded(
              child: ListView(
                children: [
                  Text('Tasks:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._tasks.map((task) => ListTile(
                        title: Text(task['title']),
                        subtitle: Text('Due: ${task['due_date']}\nCompleted: ${task['completed']}'),
                      )),
                ],
              ),
            ),

            // Display events
            Expanded(
              child: ListView(
                children: [
                  Text('Events:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._events.map((event) => ListTile(
                        title: Text(event['title']),
                        subtitle: Text(
                            'Start: ${event['start_time']}\nEnd: ${event['end_time']}'),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
