import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_fields_create_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_helper_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_pictures.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_event_fields.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_text_field.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

enum EventDateTimeType { startDate, endDate, startTime, endTime }

class CreateBulletinItem extends StatefulWidget {
  final BulletinType bulletinType;

  CreateBulletinItem(this.bulletinType);

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
  void initState() {
    super.initState();

    itemFieldsValue.type = widget.bulletinType;
  }

  @override
  void dispose() {
    super.dispose();
    _removeImagesFromCacheAndStorage();
  }

  _removeImagesFromCacheAndStorage() {
    if (_imageFiles.length > 0) {
      _imageFiles.forEach((ImageInfoData image) async {
        await ImageHelpers.deleteImageFromCacheAndStorage(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Opret nyhed",
        body: ModalProgressHUD(
            opacity: 0.5, child: _main(), inAsyncCall: _saving));
  }

  Widget _main() {
    List<Widget> widgets = [
      _createBulletinItemForm(context),
    ];

    if (widget.bulletinType == BulletinType.news)
      widgets.add(BulletinNewsItemPictures(
        useSquareOnOddImageCount: true,
        imageInfoData: _imageFiles,
        onLongpressImageSelected: (image) {
          if (image != null && image is ImageInfoData) {
            _removePhoto(image);
          }
        },
      ));

    return Card(
      child: ListView(
        padding: EdgeInsets.all(10.0),
        children: widgets,
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
    if (widget.bulletinType == BulletinType.event) {
      
      widgets.add(_eventFields());
      widgets.add(_textField());
    } else {
      widgets.add(_textField());
    }

    return widgets;
  }

  Widget _eventFields() {
    return BulletinEventFields(
      startDateController: _startDateController,
      endDateController: _endDateController,
      startTimeController: _startTimeController,
      endTimeController: _endTimeController,
      itemFieldsValue: itemFieldsValue,
      eventImage: _imageFiles.length != 0 ? _imageFiles[0] : null,
      onTapImage: (ImageInfoData data) {
        if (data == null) {
          _addPhoto();
        } else {
          _removePhoto(data);
        }
      },
    );
  }

  Widget _textField() {
    return BulletinTextField(
        onPressedSave: _textFieldOnpressedSave,
        onPressedPhoto: widget.bulletinType == BulletinType.news ? _addPhoto : null,
        onSave: _textFieldOnSave,
        showPhotoButton: widget.bulletinType == BulletinType.news);
  }

  _textFieldOnSave(String value) {
    itemFieldsValue.body = value;
  }

  _textFieldOnpressedSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _formKey.currentState.reset();

      await _saveBulletinItem();
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveBulletinItem() async {
    if (itemFieldsValue.type == BulletinType.news) {
      BulletinNewsItemData data = BulletinNewsItemData(
        body: itemFieldsValue.body,
        type: itemFieldsValue.type,
        imageLinks: _imageFiles.map<String>((ImageInfoData data) {
          return data.linkFirebaseStorage;
        }).toList(),
        images: _imageFiles.map<BulletinImageData>((ImageInfoData data) {
          return BulletinImageData(name: data.filename, folder: data.imagesStoreageFolder);
        }).toList()
      );

      _imageFiles.clear();
      return data.save();
      
    }

    if (itemFieldsValue.type == BulletinType.event) {
      BulletinEventItemData data = BulletinEventItemData(
        body: itemFieldsValue.body,
        type: itemFieldsValue.type,
        eventTitle: itemFieldsValue.eventTitle,
        eventLocation: itemFieldsValue.eventLocation,
        eventStartDate: itemFieldsValue.eventStartDate,
        eventEndDate: itemFieldsValue.eventEndDate,
        eventStartTime: itemFieldsValue.eventStartTime,
        eventEndTime: itemFieldsValue.eventEndTime,
        eventImageLink: _imageFiles.length != 0 ? _imageFiles[0].linkFirebaseStorage : "",
        eventImage: _imageFiles.length != 0 ? BulletinImageData(name: _imageFiles[0].filename, folder: _imageFiles[0].imagesStoreageFolder) : null
      );

      _imageFiles.clear();
      return data.save();
    }

    if (itemFieldsValue.type == BulletinType.play) {
      BulletinPlayItemData data = BulletinPlayItemData(
        body: itemFieldsValue.body,
        type: itemFieldsValue.type,
      );

      return data.save();
    }
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
                    Navigator.of(context).pop();
                    _selectPhoto("gallery");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Kamera"),
                  onTap: () async {
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
    if (imageFile != null) {
      ImageInfoData imageInfo = await ImageHelpers.saveImage(
          imageFile,
          BulletinImageHelper.getImageSize(widget.bulletinType),
          BulletinImageHelper.getStorageFolder(widget.bulletinType));
      if (imageInfo.linkFirebaseStorage.isNotEmpty) {
        setState(() {
          _imageFiles.add(imageInfo);
        });
      }
    }
  }

  void _removePhoto(ImageInfoData image) async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Fjern billede"),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _deleteImage(image, true);
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  _deleteImage(ImageInfoData image, bool removeFromList) async {
    if (removeFromList) {
      setState(() {
        _imageFiles.remove(image);
      });
    }

    ImageHelpers.deleteImageFromCacheAndStorage(image);
  }
}
