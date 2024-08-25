import 'package:flutter/material.dart';

class CustomPopup extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;

  const CustomPopup({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: Responsive.isMobileLarge(context) ? 300 : 600,
        height: Responsive.isMobileLarge(context) ? 400 : 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Responsive {
  static bool isMobileLarge(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
}
