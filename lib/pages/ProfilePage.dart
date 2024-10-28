import 'package:flutter/material.dart';
import 'package:hedeyety/components/BoringAvatars.dart';

import '../models/Person.dart';

class ProfilePage extends StatelessWidget {
  Person person = Person("Mark", 5, age: 25, biography: "Flutter enthusiast");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: BoringAvatar(
            name: "name",
            size: 140,
          ),
        ),
        // Center the Row containing the name and age
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers the content horizontally
          children: [
            Text(
              person.name,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            Text(
              " - ",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            // SizedBox(width: 10), // Adds spacing between name and age
            Text(
              person.age.toString(),
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 20), // Adds some vertical spacing
        Text(
          person.biography,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
        )
      ],
    );
  }
}
