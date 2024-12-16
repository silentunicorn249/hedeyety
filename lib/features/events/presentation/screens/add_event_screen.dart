import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedeyety/features/events/data/datasources/event_repo_local.dart';
import 'package:hedeyety/features/events/data/models/event_model.dart';

class AddEventScreen extends StatefulWidget {
  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();
  final TextEditingController eventDesc = TextEditingController();
  final TextEditingController eventDate = TextEditingController();

  void _resetForm() {
    _formKey.currentState?.reset();
    eventName.clear();
    eventLocation.clear();
    eventDesc.clear();
    eventDate.clear();
  }

  void saveEvent() {
    if (_formKey.currentState!.validate()) {
      print(eventName.text);
      print(eventLocation.text);
      print(eventDesc.text);
      print(eventDate.text);
      var userUID = _auth.currentUser!.uid;
      print(userUID);
      final repo = EventRepoLocal();
      repo.saveEvent(EventModel(
        id: userUID + eventName.text,
        name: eventName.text,
        location: eventLocation.text,
        desc: eventDesc.text,
        userId: userUID,
        date: eventDate.text,
        isPublic: false,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event Saved Successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Add Event",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: eventName,
                  decoration: const InputDecoration(labelText: 'Event name'),
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'Username must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: eventLocation,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextFormField(
                  controller: eventDesc,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: eventDate,
                  decoration: const InputDecoration(labelText: 'Event Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 2)),
                      firstDate: DateTime.now().add(const Duration(days: 2)),
                      lastDate:
                          DateTime.now().add(const Duration(days: 1 * 30)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        eventDate.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the event date';
                    }
                    List<String> parts = value.split('-');
                    DateTime dob = DateTime(
                      int.parse(parts[0]),
                      int.parse(parts[1]),
                      int.parse(parts[2]),
                    );
                    DateTime today = DateTime.now();
                    if (dob.isBefore(today)) {
                      return 'Event date cannot be a past date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: saveEvent,
                      child: const Text('Save Event'),
                    ),
                    OutlinedButton(
                      onPressed: _resetForm,
                      child: const Text('Clear Form'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
