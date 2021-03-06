import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/event_datetime_type_enum.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
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
  const BulletinEventFields(
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
    return _main(context);
  }

  Widget _main(BuildContext context) {
    return Column(
      children: <Widget>[
        _getImageWidget(context),
        _getTitleTextFieldWidget(context),
        Row(
          children: <Widget>[
            Flexible(
                child: _getDateTextFieldWidget(
                    context,
                    widget.startDateController,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string1"),
                    DateTimeType.startDate,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string2"))),
            SizedBox(width: 20.0),
            Flexible(
                child: _getDateTextFieldWidget(
                    context,
                    widget.endDateController,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string3"),
                    DateTimeType.endDate,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string4")))
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
                child: _getTimeTextFieldWidget(
                    context,
                    widget.startTimeController,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string5"),
                    DateTimeType.startTime,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string6"))),
            SizedBox(width: 20.0),
            Flexible(
                child: _getTimeTextFieldWidget(
                    context,
                    widget.endTimeController,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string7"),
                    DateTimeType.endTime,
                    FlutterI18n.translate(
                        context, "bulletin.getBulletinEventFields.string8")))
          ],
        ),
        _getLocationTextField(context),
      ],
    );
  }

  Widget _getImageWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                widget.onTapImage(widget.eventImage);
              },
              child: Tooltip(
                message: FlutterI18n.translate(
                    context, "bulletin.getBulletinEventFields.string9"),
                child: Container(
                  width: 200.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                      color: Colors.grey,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: _getImageProvider())),
                  child: Icon(
                    widget.eventImage == null
                        ? Icons.add_a_photo
                        : Icons.delete,
                    color: SilkeborgBeachvolleyTheme.buttonTextColor,
                  ),
                ),
              ),
            ),
          ),
          Text(FlutterI18n.translate(
              context, "bulletin.getBulletinEventFields.string10"))
        ],
      ),
    );
  }

  Widget _getTitleTextFieldWidget(BuildContext context) {
    return TextFormField(
      initialValue: widget.itemFieldsValue.eventTitle,
      keyboardType: TextInputType.text,
      maxLength: 50,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "bulletin.getBulletinEventFields.string11")),
      onSaved: (value) {
        widget.itemFieldsValue.eventTitle = value;
      },
      validator: (value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "bulletin.getBulletinEventFields.string12");
      },
    );
  }

  Widget _getDateTextFieldWidget(
      BuildContext context,
      TextEditingController controller,
      String label,
      DateTimeType type,
      String validatorText) {
    return TextFormField(
        keyboardType: TextInputType.datetime,
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today,
                  color: SilkeborgBeachvolleyTheme.buttonTextColor),
              onPressed: () async {
                _selectDate(context, type);
              },
            )),
        validator: (value) {
          if (value.isEmpty) return validatorText;
        });
  }

  Widget _getTimeTextFieldWidget(
      BuildContext context,
      TextEditingController controller,
      String label,
      DateTimeType type,
      String validatorText) {
    return TextFormField(
        keyboardType: TextInputType.datetime,
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            suffixIcon: IconButton(
              icon: Icon(Icons.access_time,
                  color: SilkeborgBeachvolleyTheme.buttonTextColor),
              onPressed: () async {
                _selectTime(context, type);
              },
            )),
        validator: (value) {
          if (value.isEmpty) return validatorText;
        });
  }

  Widget _getLocationTextField(BuildContext context) {
    return TextFormField(
      initialValue: widget.itemFieldsValue.eventLocation,
      keyboardType: TextInputType.text,
      maxLength: 100,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "bulletin.getBulletinEventFields.string13")),
      onSaved: (value) {
        widget.itemFieldsValue.eventLocation = value;
      },
      validator: (value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "bulletin.getBulletinEventFields.string14");
      },
    );
  }

  ImageProvider<dynamic> _getImageProvider() {
    ImageProvider<dynamic> imageProvider = MemoryImage(kTransparentImage);
    try {
      if (widget.eventImage != null) {
        if (widget.eventImage.state == ImageInfoState.none &&
            widget.eventImage.imageFile != null)
          imageProvider = FileImage(widget.eventImage.imageFile);
        if (widget.eventImage.state == ImageInfoState.exists &&
            widget.eventImage.linkFirebaseStorage != null &&
            widget.eventImage.linkFirebaseStorage.isNotEmpty)
          imageProvider =
              CachedNetworkImageProvider(widget.eventImage.linkFirebaseStorage);
      }
    } catch (e) {
      print(e);
    }

    return imageProvider;
  }

  DateTime _setDate(DateTimeType eventDateTimeType) {
    DateTime date = DateTime.now();
    if (widget.itemFieldsValue.eventStartDate != null &&
        eventDateTimeType == DateTimeType.startDate) {
      date = widget.itemFieldsValue.eventStartDate;
    }

    if (widget.itemFieldsValue.eventEndDate != null &&
        eventDateTimeType == DateTimeType.endDate) {
      date = widget.itemFieldsValue.eventEndDate;
    }

    return date;
  }

  TimeOfDay _setTime(DateTimeType eventDateTimeType) {
    TimeOfDay day = TimeOfDay.now();

    if (widget.itemFieldsValue.eventStartTime != null &&
        eventDateTimeType == DateTimeType.startTime) {
      if (widget.itemFieldsValue.eventStartTime is TimeOfDay)
        day = widget.itemFieldsValue.eventStartTime;
      if (widget.itemFieldsValue.eventStartTime is DateTime)
        day = TimeOfDay(
            hour: (widget.itemFieldsValue.eventStartTime as DateTime).hour,
            minute: (widget.itemFieldsValue.eventStartTime as DateTime).minute);
    }

    if (widget.itemFieldsValue.eventEndTime != null &&
        eventDateTimeType == DateTimeType.endTime) {
      if (widget.itemFieldsValue.eventEndTime is TimeOfDay)
        day = widget.itemFieldsValue.eventEndTime;
      if (widget.itemFieldsValue.eventEndTime is DateTime)
        day = TimeOfDay(
            hour: (widget.itemFieldsValue.eventEndTime as DateTime).hour,
            minute: (widget.itemFieldsValue.eventEndTime as DateTime).minute);
    }

    return day;
  }

  Future<Null> _selectDate(
      BuildContext context, DateTimeType eventDateTimeType) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _setDate(eventDateTimeType),
        firstDate: new DateTime(DateTime.now().year),
        lastDate: new DateTime(DateTime.now().year + 1),
        initialDatePickerMode: DatePickerMode.day);

    if (picked != null) {
      if (mounted) {
        setState(() {
          String formattedDate = DateTimeHelpers.ddmmyyyy(picked);
          switch (eventDateTimeType) {
            case DateTimeType.startDate:
              widget.startDateController.text = formattedDate;
              widget.endDateController.text = formattedDate;
              widget.itemFieldsValue.eventStartDate = picked;
              widget.itemFieldsValue.eventEndDate = picked;
              break;
            case DateTimeType.endDate:
              widget.endDateController.text = formattedDate;
              widget.itemFieldsValue.eventEndDate = picked;
              break;
            default:
              print(formattedDate);
          }
        });
      }
    }
  }

  Future<Null> _selectTime(
      BuildContext context, DateTimeType eventDateTimeType) async {
    TimeOfDay picked = await showTimePicker(
        context: context, initialTime: _setTime(eventDateTimeType));

    if (picked != null) {
      if (mounted) {
        setState(() {
          switch (eventDateTimeType) {
            case DateTimeType.startTime:
              widget.startTimeController.text = picked.format(context);
              widget.endTimeController.text =
                  picked.replacing(hour: picked.hour + 2).format(context);
              widget.itemFieldsValue.eventStartTime = picked;
              widget.itemFieldsValue.eventEndTime =
                  picked.replacing(hour: picked.hour + 2);
              break;
            case DateTimeType.endTime:
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
}
