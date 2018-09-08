import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletinItemCreator_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestorage.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_fields_create_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_news_item_pictures.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_choose_type.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_event_fields.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_text_field.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

enum EventDateTimeType { startDate, endDate, startTime, endTime }

String radioGroupValue = BulletinType.news;

class CreateBulletinItem extends StatefulWidget {
  @override
  _CreateBulletinItemState createState() => _CreateBulletinItemState();
}

class _CreateBulletinItemState extends State<CreateBulletinItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController =
      new TextEditingController();
  final TextEditingController _endDateController = new TextEditingController();
  final TextEditingController _startTimeController =
      new TextEditingController();
  final TextEditingController _endTimeController = new TextEditingController();
  final ItemFieldsCreate itemFieldsValue = ItemFieldsCreate();
  List<ImageInfoData> _imageFiles = [];
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley",
        body: ModalProgressHUD(
            opacity: 0.5, child: _main(), inAsyncCall: _saving));
  }

  Widget _main() {
    return Card(
      child: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          BulletinChooseType(
            onChange: (value) {
              setState(() {
                itemFieldsValue.type = value;
                radioGroupValue = value;
              });
            },
            radioGroupValue: radioGroupValue,
          ),
          _createBulletinItemForm(context),
          BulletinNewsItemPictures(
            imageInfoData: _imageFiles,
            onLongpressImageSelected: (image) {
              if (image is ImageInfoData) {
                print(image.filename);
                _removePhoto(image);
              }
            },
          )
        ],
      ),
    );
  }

  Widget _createBulletinItemForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: _fieldsToShowInForm(context)),
    );
  }

  List<Widget> _fieldsToShowInForm(BuildContext context) {
    List<Widget> widgets = [];

    if (radioGroupValue == BulletinType.event) {
      widgets.add(
        BulletinEventFields(
        startDateController: _startDateController,
        endDateController: _endDateController,
        startTimeController: _startTimeController,
        endTimeController: _endTimeController,
        itemFieldsValue: itemFieldsValue,
      )
      );
      widgets.add(_textField());
    } else {
      widgets.add(_textField());
    }

    return widgets;
  }

  Widget _textField() {
    return BulletinTextField(
        onPressedSave: _textFieldOnpressedSave,
        onPressedPhoto: radioGroupValue == BulletinType.news ? _addPhoto : null,
        onSave: _textFieldOnSave
      );
  }

_textFieldOnSave(String value){
itemFieldsValue.body = value;
}

_textFieldOnpressedSave() async {
if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _formKey.currentState.reset();

                    setState(() {
                      _saving = true;
                    });
                    await _saveBulletinItem();
                    setState(() {
                      radioGroupValue = BulletinType.news;
                      _saving = false;
                    });
                    Navigator.of(context).pop();
                  }
  }
  
  Future<void> _saveBulletinItem() async {
    var item = await BulletinItemCreator.createBulletinItem(
        body: itemFieldsValue.body,
        type: itemFieldsValue.type,
        eventTitle: itemFieldsValue.eventTitle,
        eventLocation: itemFieldsValue.eventLocation,
        eventStartDate: itemFieldsValue.eventStartDate,
        eventEndDate: itemFieldsValue.eventEndDate,
        eventStartTime: itemFieldsValue.eventStartTime,
        eventEndTime: itemFieldsValue.eventEndTime,
        images: _imageFiles.map<String>((ImageInfoData data) {
          return data.linkFirebaseStorage;
        }).toList()
        );

    await BulletinFirestore.saveBulletinItem(item);
  }

  _addPhoto() async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("Indsæt billede fra"),
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Galleri"),
                  onTap: () async {
                    print("Galleri");
                    Navigator.of(context).pop();
                    _selectPhoto("gallery");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Kamera"),
                  onTap: () async {
                    print("Kamera");
                    Navigator.of(context).pop();
                    _selectPhoto("camera");
                  },
                )
              ],
            ),
          );
        });
  }

  void _selectPhoto(String mode) async {
    File imageFile = await ImagePicker.pickImage(
        source: mode == "gallery" ? ImageSource.gallery : ImageSource.camera);

    ImageInfoData imageInfoData =
        await ImageHelpers.processNewsImage(imageFile);

    if (imageInfoData.imageFile != null) {
      imageInfoData.linkFirebaseStorage = await BulletinFireStorage.saveToFirebaseStorage(imageInfoData.imageFile, imageInfoData.filename);

      if (imageInfoData.linkFirebaseStorage.isNotEmpty) {
        setState(() {
          _imageFiles.add(imageInfoData);
        });
      }
      
    }
  }

  void _removePhoto(ImageInfoData image) async {
    setState(() {
      if (_imageFiles.remove(image)) {
        try {
          image.imageFile.delete();  
          BulletinFireStorage.deleteFromFirebaseStorage(image.filename);
        } catch (e) {
          print("_removePhoto: $e");
        }
      }          
    });
  }
}
