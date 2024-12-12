// import 'package:flutter/material.dart';
// import 'package:hedeyety/models/user.dart';
//
// import 'BoringAvatars.dart';
//
// class Friendrow extends StatelessWidget {
//   Person person = Person("Mark", 5);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: ListTile(
//         leading: BoringAvatar(name: "Mark"),
//         title: Text(
//           person.name,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         trailing: _buildMessageCounter(),
//       ),
//     );
//   }
//
//   // Helper method to display the message counter
//   Widget _buildMessageCounter() {
//     return person.events > 0
//         ? Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: Colors.green,
//               shape: BoxShape.circle,
//             ),
//             child: Text(
//               person.events.toString(),
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           )
//         : const SizedBox(); // If no messages, display an empty widget
//   }
// }
