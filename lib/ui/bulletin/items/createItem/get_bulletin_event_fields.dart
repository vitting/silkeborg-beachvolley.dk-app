import 'dart:async';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_fields_create_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/create_item_main.dart';

class BulletinEventFields extends StatefulWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final ItemFieldsCreate itemFieldsValue;
  final Function onTapImage;
  final ImageInfoData eventImage;
  BulletinEventFields(
      {@required this.startDateController,
      @required this.endDateController,
      @required this.startTimeController,
      @required this.endTimeController,
      @required this.itemFieldsValue, @required this.onTapImage, @required this.eventImage});

  @override
  _BulletinEvetFieldsState createState() => _BulletinEvetFieldsState();
}

class _BulletinEvetFieldsState extends State<BulletinEventFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  widget.onTapImage(widget.eventImage);
                },
                child: Tooltip(
                  message: "Vælg et billede. Det er ikke påkrævet.",
                  child: Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0
                  ),
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: widget.eventImage == null ? MemoryImage(kTransparentImage) : FileImage(widget.eventImage.imageFile)
                  )
                ),
                child: Icon(
                  widget.eventImage == null ? Icons.add_a_photo : Icons.delete,
                  color: Colors.white,
                ),
              ),
                ),
              )
            ],
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          maxLength: 50,
          decoration: InputDecoration(labelText: "Titel"),
          onSaved: (value) {
            widget.itemFieldsValue.eventTitle = value;
          },
          validator: (value) {
            if (value.isEmpty) return "Titel skal udfyldes";
          },
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  controller: widget.startDateController,
                  decoration: InputDecoration(
                      labelText: "Start dato",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          _selectDate(context, EventDateTimeType.startDate);
                        },
                      )),
                  validator: (value) {
                    if (value.isEmpty) return "Udfyld Start dato";
                  }),
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  controller: widget.endDateController,
                  decoration: InputDecoration(
                      labelText: "Slut dato",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          _selectDate(context, EventDateTimeType.endDate);
                        },
                      )),
                  validator: (value) {
                    if (value.isEmpty) return "Udfyld Slut dato";
                  }),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  controller: widget.startTimeController,
                  decoration: InputDecoration(
                      labelText: "Start tid",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () async {
                          _selectTime(context, EventDateTimeType.startTime);
                        },
                      )),
                  validator: (value) {
                    if (value.isEmpty) return "Udfyld Start tid";
                  }),
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                textAlign: TextAlign.center,
                controller: widget.endTimeController,
                decoration: InputDecoration(
                    labelText: "Slut tid",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () async {
                        _selectTime(context, EventDateTimeType.endTime);
                      },
                    )),
                validator: (value) {
                  if (value.isEmpty) return "Udfyld Slut tid";
                },
                onSaved: (value) {},
              ),
            )
          ],
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          maxLength: 100,
          decoration: InputDecoration(labelText: "Sted"),
          onSaved: (value) {
            widget.itemFieldsValue.eventLocation = value;
          },
          validator: (value) {
            if (value.isEmpty) return "Sted skal udfyldes";
          },
        )
      ],
    );
  }

  Future<Null> _selectDate(
      BuildContext context, EventDateTimeType eventDateTimeType) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(DateTime.now().year),
        lastDate: new DateTime(DateTime.now().year + 1),
        initialDatePickerMode: DatePickerMode.day);

    if (picked != null) {
      setState(() {
        String formattedDate = DateTimeHelpers.ddmmyyyy(picked);
        switch (eventDateTimeType) {
          case EventDateTimeType.startDate:
            widget.startDateController.text = formattedDate;
            widget.endDateController.text = formattedDate;
            widget.itemFieldsValue.eventStartDate = picked;
            widget.itemFieldsValue.eventEndDate = picked;
            break;
          case EventDateTimeType.endDate:
            widget.endDateController.text = formattedDate;
            widget.itemFieldsValue.eventEndDate = picked;
            break;
          default:
            print(formattedDate);
        }
      });
    }
  }

  Future<Null> _selectTime(
      BuildContext context, EventDateTimeType eventDateTimeType) async {
    TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        switch (eventDateTimeType) {
          case EventDateTimeType.startTime:
            widget.startTimeController.text = picked.format(context);
            widget.endTimeController.text =
                picked.replacing(hour: picked.hour + 2).format(context);
            widget.itemFieldsValue.eventStartTime = picked;
            widget.itemFieldsValue.eventEndTime =
                picked.replacing(hour: picked.hour + 2);
            break;
          case EventDateTimeType.endTime:
            widget.endTimeController.text = picked.format(context);
            widget.itemFieldsValue.eventEndTime = picked;
            break;
          default:
            print(picked);
        }
      });
    }
  }
}
