import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/event_datetime_type_enum.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_fields_create_class.dart';

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
      @required this.itemFieldsValue,
      @required this.onTapImage,
      @required this.eventImage});

  @override
  _BulletinEvetFieldsState createState() => _BulletinEvetFieldsState();
}

class _BulletinEvetFieldsState extends State<BulletinEventFields> {
  @override
  Widget build(BuildContext context) {
    return _main();
  }

  Widget _main() {
    return Column(
      children: <Widget>[
        _getImageWidget(),
        _getTitleTextFieldWidget(),
        Row(
          children: <Widget>[
            Flexible(
              child: _getDateTextFieldWidget(context, widget.startDateController, "Start dato", EventDateTimeType.startDate, "Udfyld Start dato")
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: _getDateTextFieldWidget(context, widget.endDateController, "Slut dato", EventDateTimeType.endDate, "Udfyld Slut dato")
            )
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: _getTimeTextFieldWidget(context, widget.startTimeController, "Start tid", EventDateTimeType.startTime, "Udfyld Start tid")
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: _getTimeTextFieldWidget(context, widget.endTimeController, "Slut tid", EventDateTimeType.endTime, "Udfyld Slut tid")
            )
          ],
        ),
        _getLocationTextField()
      ],
    );
  }

  Widget _getImageWidget() {
    return Padding(
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
                        border: Border.all(color: Colors.grey, width: 2.0),
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill, image: _getImageProvider())),
                    child: Icon(
                      widget.eventImage == null
                          ? Icons.add_a_photo
                          : Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
  }

  Widget _getTitleTextFieldWidget() {
    return TextFormField(
          initialValue: widget.itemFieldsValue.eventTitle,
          keyboardType: TextInputType.text,
          maxLength: 50,
          decoration: InputDecoration(labelText: "Titel"),
          onSaved: (value) {
            widget.itemFieldsValue.eventTitle = value;
          },
          validator: (value) {
            if (value.isEmpty) return "Titel skal udfyldes";
          },
        );
  }

  Widget _getDateTextFieldWidget(BuildContext context, TextEditingController controller, String label, EventDateTimeType type, String validatorText) {
    return TextFormField(
        keyboardType: TextInputType.datetime,
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                _selectDate(context, type);
              },
            )),
        validator: (value) {
          if (value.isEmpty) return validatorText;
        });
  }

  Widget _getTimeTextFieldWidget(BuildContext context, TextEditingController controller, String label, EventDateTimeType type, String validatorText) {
    return TextFormField(
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: label,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () async {
                          _selectTime(context, type);
                        },
                      )),
                  validator: (value) {
                    if (value.isEmpty) return validatorText;
                  });
  }

  Widget _getLocationTextField() {
    return TextFormField(
          initialValue: widget.itemFieldsValue.eventLocation,
          keyboardType: TextInputType.text,
          maxLength: 100,
          decoration: InputDecoration(labelText: "Sted"),
          onSaved: (value) {
            widget.itemFieldsValue.eventLocation = value;
          },
          validator: (value) {
            if (value.isEmpty) return "Sted skal udfyldes";
          },
        );
  }

  ImageProvider<dynamic> _getImageProvider() {
    ImageProvider<dynamic> imageProvider = MemoryImage(kTransparentImage);
    if (widget.eventImage != null) {
      if (widget.eventImage.state == ImageInfoState.none &&
          widget.eventImage.imageFile != null)
        imageProvider = FileImage(widget.eventImage.imageFile);
      if (widget.eventImage.state == ImageInfoState.exists &&
          widget.eventImage.linkFirebaseStorage != null)
        imageProvider =
            CachedNetworkImageProvider(widget.eventImage.linkFirebaseStorage);
    }
    return imageProvider;
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
