import 'package:flutter/material.dart';

class AdminEnrollmentDetailRow extends StatelessWidget {
  final IconData icon;
  final String text; 
  final String tooltip;

  const AdminEnrollmentDetailRow({Key key, this.icon, this.text, this.tooltip}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: <Widget>[
          Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              size: 18.0,
              color: Colors.blue[700],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(text),
            ),
          )
        ],
      ),
    );
  }
}