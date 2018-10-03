import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/chip_header.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_payment_data.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import "../../../helpers/confirm_dialog_functions.dart" as confirmActions;
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
      title: "Medlemsinfo",
      body: Card(
        child: ListView(
          children: <Widget>[
            Container(
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _row(FontAwesomeIcons.idCard, widget.enrollment.id, "Medlems id"),
                    _row(
                        Icons.calendar_today,
                        DateTimeHelpers.ddmmyyyyHHnn(
                            widget.enrollment.creationDate), "Dato medlem er oprettet"),
                    _row(Icons.person, widget.enrollment.name, "Medlems navn"),
                    _row(Icons.location_city,
                        "${widget.enrollment.street}\n${widget.enrollment.postalCode} ${widget.enrollment.city}", "Medlems adresse"),
                    _row(Icons.email, widget.enrollment.email, "Medlems e-mail adresse"),
                    _row(Icons.phone, widget.enrollment.phone.toString(), "Medlems mobilnummer"),
                    _row(Icons.cake,
                        "${DateTimeHelpers.ddmmyyyy(widget.enrollment.birthdate)} / ${widget.enrollment.age} år", "Medlems fødselsdato og alder"),
                    Divider(),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onLongPress: () {
                              _chooseYear(context);
                            },
                            child: FlatButton.icon(
                              onPressed: () {
                                widget.enrollment.addPayment(_selectedYear);
                                widget.enrollment.save();
                                if (mounted) {
                                  setState(() {
                                    widget.enrollment.refresh();
                                  });
                                }
                                
                                //CHRISTIAN: 
                                //og hvis ikke payments bliver opdateret så kan vi lave en enrollemntUserData.refresh() 
                                //En måde at tilføje kommentar
                                //Skal payment gemmes som 2018: {data}
                              },
                              icon: Icon(Icons.add_circle),
                              label:
                                  Text("Registere betaling for $_selectedYear"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: _payments(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _payments() {
    List<Widget> widgets = [
      ChipHeader("Der er endnu ikke registeret nogen betalinger for det pågældende medlem.",
      textAlign: TextAlign.center
      )
    ];
    if (widget.enrollment.payment.isNotEmpty) {
      widgets =
          widget.enrollment.payment.map<Widget>((EnrollmentPaymentData data) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ChipHeader(data.year.toString(), textAlign: TextAlign.center, fontWeight: FontWeight.bold,),
                ),
              ],
            ),
            ListTile(
              trailing: IconButton(
                tooltip: "Slet betaling",
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  
                },
              ),
              title: ListBody(
                children: <Widget>[
                  _row(Icons.calendar_today, DateTimeHelpers.ddmmyyyyHHnn(data.createdDate), "Dato medlem er oprettet"),
                  _row(FontAwesomeIcons.idCard, data.approvedUserId, "Id på den person der har godkendt betalingen"),
                  GestureDetector(
                    child: _row(Icons.comment, data.comment.isEmpty ? "Ingen kommentar" : data.comment, "Kommentar fra administrator"),
                    onLongPress: () {
                      _editComment(context, data);
                    },
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

  Widget _row(IconData icon, String text, String tooltip) {
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

  _chooseYear(BuildContext context) async {
    int currentYear = DateTime.now().year;

    List<Widget> widgets = List.generate(3, (int value) {
      int year = currentYear - value;
      return ListTile(
          title: FlatButton(
        child: Text(year.toString(), textAlign: TextAlign.center),
        onPressed: () {
          Navigator.of(context).pop(year);
        },
      ));
    }).toList();

    int result = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext contextModal) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          );
        });

    if (result != null) {
      if (mounted) {
        setState(() {
          _selectedYear = result;
        });
      }
    }
  }

  _editComment(BuildContext context, EnrollmentPaymentData item) async {
    TextEditingController _commentController= TextEditingController(text: item.comment);
    ConfirmDialogAction result = await confirmActions.confirmDialog(context, 
      title: Text("Kommentar"),
       barrierDismissible: false,
       body: <Widget>[
         Container(
           child: TextField(
             controller: _commentController,
             maxLength: 1000,
             maxLines: 4,
             decoration: InputDecoration(
               labelText: "Kommentar",
               suffixIcon: IconButton(
                 icon: Icon(Icons.send),
                 onPressed: () {
                   Navigator.of(context).pop(ConfirmDialogAction.save);
                 },
               )
             ),
           ),
         )
       ]
    );

    if (result != null  && result == ConfirmDialogAction.save) {
      item.comment = _commentController.text;
      widget.enrollment.save();
    }
  }
}
