import 'package:flutter/material.dart';

class AddGiftScreen extends StatelessWidget {
  final String eventId;

  const AddGiftScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Gift"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Gift Name"),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Capture the input values
                final name = nameController.text.trim();
                final category = categoryController.text.trim();
                final description = descriptionController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (name.isEmpty ||
                    category.isEmpty ||
                    description.isEmpty ||
                    price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please fill all fields correctly")),
                  );
                  return;
                }

                // Pop and send the gift data back
                Navigator.pop(context, {
                  "name": name,
                  "category": category,
                  "description": description,
                  "price": price,
                  "eventId": eventId,
                });
              },
              child: const Text("Add Gift"),
            ),
          ],
        ),
      ),
    );
  }
}
