import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_detail_payments.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_detail_row.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_payment_data.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import './admin_enrollment_functions.dart' as adminEnrollmentFunctions;

class EnrollmentDetail extends StatefulWidget {
  final EnrollmentUserData enrollment;

  const EnrollmentDetail({Key key, this.enrollment}) : super(key: key);

  @override
  EnrollmentDetailState createState() {
    return new EnrollmentDetailState();
  }
}

class EnrollmentDetailState extends State<EnrollmentDetail> {
  int _selectedYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: FlutterI18n.translate(
            context, "enrollment.adminEnrollmentDetailMain.string1"),
        body: _main());
  }

  Widget _main() {
    return Builder(
      builder: (BuildContext context) {
        return Card(
          child: ListView(
            children: <Widget>[
              Container(
                child: ListTile(
                  title: ListBody(
                    children: <Widget>[
                      _memberDetailInfo(context),
                      Divider(),
                      _addPaymentButton(context),
                      Divider(),
                      _paymentList(context)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _memberDetailInfo(BuildContext contex) {
    return Column(
      children: <Widget>[
        AdminEnrollmentDetailRow(
          icon: FontAwesomeIcons.idCard,
          text: widget.enrollment.id,
          tooltip: FlutterI18n.translate(
              context, "enrollment.adminEnrollmentDetailMain.string2"),
        ),
        AdminEnrollmentDetailRow(
          icon: Icons.calendar_today,
          text: DateTimeHelpers.ddmmyyyyHHnn(
              widget.enrollment.creationDate.toDate()),
          tooltip: FlutterI18n.translate(
              context, "enrollment.adminEnrollmentDetailMain.string3"),
        ),
        AdminEnrollmentDetailRow(
          icon: Icons.person,
          text: widget.enrollment.name,
          tooltip: FlutterI18n.translate(
              context, "enrollment.adminEnrollmentDetailMain.string4"),
        ),
        AdminEnrollmentDetailRow(
          icon: Icons.location_city,
          text:
              "${widget.enrollment.street}\n${widget.enrollment.postalCode} ${widget.enrollment.city}",
          tooltip: FlutterI18n.translate(
              context, "enrollment.adminEnrollmentDetailMain.string5"),
        ),
        AdminEnrollmentDetailRow(
          icon: Icons.email,
          text: widget.enrollment.email,
          tooltip: FlutterI18n.translate(
              context, "enrollment.adminEnrollmentDetailMain.string6"),
        ),
        AdminEnrollmentDetailRow(
          icon: Icons.phone,
          text: widget.enrollment.phone.toString(),
          tooltip: FlutterI18n.translate(
              context, "enrollment.adminEnrollmentDetailMain.string7"),
        ),
        AdminEnrollmentDetailRow(
          icon: Icons.cake,
          text:
              "${DateTimeHelpers.ddmmyyyy(widget.enrollment.birthdate)} / ${widget.enrollment.age} ${FlutterI18n.translate(context, "enrollment.adminEnrollmentDetailMain.string8")}",
          tooltip: FlutterI18n.translate(
              context, "enrollment.adminEnrollmentDetailMain.string9"),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: AdminEnrollmentDetailRow(
                icon: Icons.comment,
                text: widget.enrollment.comment.isEmpty
                    ? FlutterI18n.translate(context,
                        "enrollment.adminEnrollmentDetailMain.string10")
                    : widget.enrollment.comment,
                tooltip: FlutterI18n.translate(
                    context, "enrollment.adminEnrollmentDetailMain.string11"),
              ),
            ),
            IconButton(
              icon: Icon(Icons.comment),
              iconSize: 20.0,
              color: Colors.deepOrange,
              onPressed: () {
                _editComment(context, widget.enrollment);
              },
            )
          ],
        )
      ],
    );
  }

  Widget _addPaymentButton(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                textColor: Colors.deepOrange,
                onPressed: () async {
                  if (!widget.enrollment.paymentExists(_selectedYear)) {
                    widget.enrollment.addPayment(_selectedYear);
                    await widget.enrollment
                        .save(MainInherited.of(context).loggedInUser.uid);
                    await widget.enrollment.refresh();
                    if (mounted) {
                      setState(() {});
                    }
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${FlutterI18n.translate(context, "enrollment.adminEnrollmentDetailMain.string12")} $_selectedYear."),
                      duration: Duration(seconds: 4),
                    ));
                  }
                },
                icon: Icon(Icons.add_circle),
                label: Text(
                    "${FlutterI18n.translate(context, "enrollment.adminEnrollmentDetailMain.string13")} $_selectedYear"),
              ),
              IconButton(
                tooltip: FlutterI18n.translate(
                    context, "enrollment.adminEnrollmentDetailMain.string14"),
                color: Colors.deepOrange[800],
                icon: Icon(FontAwesomeIcons.calendarAlt),
                onPressed: () {
                  _chooseYear(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _paymentList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: AdminEnrollmentDetailPayments(
        enrollment: widget.enrollment,
        onPressedDeletePayment: (EnrollmentPaymentData data) {
          _deletePayment(context, data);
        },
        onLongPressEditComment: (EnrollmentPaymentData data) {
          _editComment(context, data);
        },
      ),
    );
  }

  void _chooseYear(BuildContext context) async {
    int result = await adminEnrollmentFunctions.chooseYear(context);
    if (result != null) {
      if (mounted) {
        setState(() {
          _selectedYear = result;
        });
      }
    }
  }

  _deletePayment(BuildContext context, EnrollmentPaymentData payment) async {
    bool result =
        await adminEnrollmentFunctions.deletePayment(context, payment);
    if (result) {
      if (mounted) {
        setState(() {
          widget.enrollment.payment.remove(payment);
          widget.enrollment.save(MainInherited.of(context).loggedInUser.uid);
        });
      }
    }
  }

  _editComment(BuildContext context, var item) async {
    print(item.comment);
    String result =
        await adminEnrollmentFunctions.editComment(context, item.comment);
    if (result != null) {
      item.comment = result;
      widget.enrollment.save(MainInherited.of(context).loggedInUser.uid);
    }
  }
}
