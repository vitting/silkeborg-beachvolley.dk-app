import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_detail_row.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_payment_data.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';

class AdminEnrollmentDetailPayments extends StatelessWidget {
  final EnrollmentUserData enrollment;
  final ValueChanged<EnrollmentPaymentData> onLongPressEditComment;
  final ValueChanged<EnrollmentPaymentData> onPressedDeletePayment;

  const AdminEnrollmentDetailPayments(
      {Key key,
      this.enrollment,
      this.onLongPressEditComment,
      this.onPressedDeletePayment})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Text(
          "Der er ikke registeret nogen betalinger for det pågældende medlem.",
          textAlign: TextAlign.center)
    ];
    if (enrollment.payment.isNotEmpty) {
      widgets =
          enrollment.paymentSorted.map<Widget>((EnrollmentPaymentData payment) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ChipHeader(
                    payment.year.toString(),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ListTile(
              trailing: Column(
                children: <Widget>[
                  IconButton(
                    tooltip: "Slet betaling",
                    color: Colors.deepOrange,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      onPressedDeletePayment(payment);
                    },
                  ),
                  IconButton(
                    tooltip: "Rediger kommentar",
                    color: Colors.deepOrange,
                    icon: Icon(Icons.comment),
                    iconSize: 20.0,
                    onPressed: () {
                      onLongPressEditComment(payment);
                    },
                  )
                ],
              ),
              title: ListBody(
                children: <Widget>[
                  AdminEnrollmentDetailRow(
                    icon: Icons.calendar_today,
                    text: DateTimeHelpers.ddmmyyyyHHnn(payment.createdDate),
                    tooltip: "Dato medlem er oprettet",
                  ),
                  AdminEnrollmentDetailRow(
                    icon: FontAwesomeIcons.idCard,
                    text: payment.approvedUserId,
                    tooltip: "Id på den person der har godkendt betalingen",
                  ),
                  AdminEnrollmentDetailRow(
                    icon: Icons.comment,
                    text: payment.comment.isEmpty
                        ? "Ingen kommentar"
                        : payment.comment,
                    tooltip: "Kommentar fra administrator",
                  )
                ],
              ),
            ),
          ],
        );
      }).toList();
    }

    return ListBody(
      children: widgets,
    );
  }
}
