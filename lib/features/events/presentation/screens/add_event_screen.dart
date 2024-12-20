import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/event_repo_local.dart';
import '../../data/datasources/event_repo_remote.dart';
import '../../data/models/event_model.dart';

class AddEventScreen extends StatefulWidget {
  final EventModel? event; // Optional EventModel for editing

  const AddEventScreen({Key? key, this.event}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  late TextEditingController eventName;
  late TextEditingController eventLocation;
  late TextEditingController eventDesc;
  late TextEditingController eventDate;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with pre-filled data if editing
    eventName = TextEditingController(text: widget.event?.name ?? "");
    eventLocation = TextEditingController(text: widget.event?.location ?? "");
    eventDesc = TextEditingController(text: widget.event?.desc ?? "");
    eventDate = TextEditingController(text: widget.event?.date ?? "");
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    eventName.clear();
    eventLocation.clear();
    eventDesc.clear();
    eventDate.clear();
  }

  void saveEvent() async {
    if (_formKey.currentState!.validate()) {
      var userUID = _auth.currentUser!.uid;

      // Create a new event or update the existing one
      final EventModel event = EventModel(
        id: widget.event?.id ?? userUID + eventName.text,
        name: eventName.text,
        location: eventLocation.text,
        desc: eventDesc.text,
        userId: widget.event?.userId ?? userUID,
        date: eventDate.text,
        isPublic: widget.event?.isPublic ?? false,
      );

      final localRepo = EventRepoLocal();
      final remoteRepo = EventRepoRemote();

      // Add or Update Logic
      if (widget.event == null) {
        // Add Event
        await localRepo.saveEvent(event);
      } else {
        // Edit Event
        await localRepo.updateEventById(event);
        if (event.isPublic) await remoteRepo.saveEvent(event);
      }

      // Notify success and close modal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.event == null
              ? 'Event Added Successfully!'
              : 'Event Updated Successfully!'),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.event != null
          ? DateTime.parse(widget.event!.date)
          : DateTime.now().add(const Duration(days: 2)),
      firstDate: DateTime.now().add(const Duration(days: 2)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate != null) {
      setState(() {
        eventDate.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;

    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              isEditing ? "Edit Event" : "Create New Event",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade300, thickness: 1),

            // Form Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Event Name
                      TextFormField(
                        key: Key("eventNameField"),
                        controller: eventName,
                        decoration: const InputDecoration(
                          labelText: 'Event Name',
                          prefixIcon: Icon(Icons.event),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return 'Event name must be at least 3 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Event Location
                      TextFormField(
                        key: Key("eventLocationField"),
                        controller: eventLocation,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Description
                      TextFormField(
                        key: Key("eventDescField"),
                        controller: eventDesc,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 15),

                      // Event Date
                      TextFormField(
                        key: Key("eventDateField"),
                        controller: eventDate,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Event Date',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        onTap: _selectDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select the event date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Save Button
                          ElevatedButton.icon(
                            key: Key("saveEventButt"),
                            onPressed: saveEvent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: Text(
                              isEditing ? 'Update Event' : 'Save Event',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          // Reset Button (only in Add mode)
                          if (!isEditing)
                            OutlinedButton.icon(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              label: const Text('Clear Form',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
