import 'package:flutter/material.dart';
import 'package:hedeyety/features/gifts/data/models/gift_model.dart';

class GiftDetailsScreen extends StatelessWidget {
  final GiftModel gift;

  const GiftDetailsScreen({super.key, required this.gift});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Curved Header Background
                ClipPath(
                  clipper: CurvedClipper(),
                  child: Container(
                    height: size.height * 0.35,
                    width: size.width,
                    color: Colors.deepPurple,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: size.width / 2 - 60,
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0x00),
                        child: gift.imageUrl != null
                            ? Image.network(
                                gift.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset("images/img.png");
                                },
                              )
                            : Image.asset("images/img.png"),
                      )),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            // Gift Name
            Text(
              gift.name,
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.02),
            // Gift Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailTile(
                    icon: Icons.category,
                    label: 'Category',
                    value: gift.category,
                  ),
                  DetailTile(
                    icon: Icons.description,
                    label: 'Description',
                    value: gift.description,
                  ),
                  DetailTile(
                    icon: Icons.price_check,
                    label: 'Price',
                    value: '\$${gift.price.toStringAsFixed(2)}',
                  ),
                  DetailTile(
                    icon: Icons.emoji_people,
                    label: 'Pledged',
                    value: gift.pledgedId.isNotEmpty ? "✅ Yes" : "❌ No",
                    valueColor:
                        gift.pledgedId.isNotEmpty ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.03),
            // Back Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: ElevatedButton(
                key: Key("giftBackButt"),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8, 50),
                ),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const DetailTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Row(
        children: [
          Icon(icon, size: size.width * 0.06),
          SizedBox(width: size.width * 0.04),
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// CurvedClipper for the header
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
