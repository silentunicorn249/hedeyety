import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddGiftScreen extends StatefulWidget {
  final String eventId;

  const AddGiftScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<AddGiftScreen> createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitGift() {
    final name = nameController.text.trim();
    final category = categoryController.text.trim();
    final description = descriptionController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (name.isEmpty ||
        category.isEmpty ||
        description.isEmpty ||
        price == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select an image."),
        ),
      );
      return;
    }

    Navigator.pop(context, {
      "name": name,
      "category": category,
      "description": description,
      "price": price,
      "eventId": widget.eventId,
      "imagePath": _selectedImage!.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Gift"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add a New Gift",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              // Gift Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Text(
                            "Tap to select an image",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Gift Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Gift Name",
                  prefixIcon: Icon(Icons.card_giftcard),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Gift Category
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: "Category",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Gift Description
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              // Gift Price
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Price",
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitGift,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Gift"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
