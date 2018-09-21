import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/build_build_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_fields_create_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/photo_functions.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_pictures.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_event_fields.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_text_field.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import '../../helpers/photo_functions.dart' as photoFunctions;

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

  @override
  void initState() {
    super.initState();

    itemFieldsValue.type = widget.bulletinType;
  }

  @override
  void dispose() {
    super.dispose();
    photoFunctions.removeImagesFromCacheAndStorage(_imageFiles);
  }

  String _getTitle(BulletinType type) {
    String title = "";
    if (type == BulletinType.news) title = "Opret nyhed";
    if (type == BulletinType.event) title = "Opret begivenhed";
    if (type == BulletinType.play) title = "Opret spil";
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(title: _getTitle(widget.bulletinType), body: _main());
  }

  Widget _main() {
    List<Widget> widgets = [
      _createBulletinItemForm(context),
    ];

    if (widget.bulletinType == BulletinType.news)
      widgets.add(BulletinNewsItemPictures(
        type: BulletinImageType.file,
        useSquareOnOddImageCount: true,
        images: _imageFiles,
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
        onPressedSave: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _formKey.currentState.reset();

            await _saveBulletinItem();
            Navigator.of(context).pop();
          }
        },
        onPressedPhoto:
            widget.bulletinType == BulletinType.news ? _addPhoto : null,
        onSave: (String value) {
          itemFieldsValue.body = value;
        },
        showPhotoButton: widget.bulletinType == BulletinType.news);
  }

  Future<void> _saveBulletinItem() async {
    var data;
    if (itemFieldsValue.type == BulletinType.news) {
      data = BuildBulletinItem.buildNewsItem(itemFieldsValue, _imageFiles);
    }

    if (itemFieldsValue.type == BulletinType.event) {
      data = BuildBulletinItem.buildEventItem(itemFieldsValue, _imageFiles);
    }

    if (itemFieldsValue.type == BulletinType.play) {
      data = BuildBulletinItem.buildPlayItem(itemFieldsValue);
    }

    _imageFiles.clear();
    return data.save();
  }

  void _addPhoto() async {
    ImageInfoData imageInfo =
        await photoFunctions.addPhoto(context, itemFieldsValue.type);

    if (imageInfo.linkFirebaseStorage.isNotEmpty) {
      setState(() {
        _imageFiles.add(imageInfo);
      });
    }
  }

  void _removePhoto(ImageInfoData image) async {
    PhotoAction action = await photoFunctions.removePhoto(context);

    if (action != null && action == PhotoAction.delete) {
      await ImageHelpers.deleteImageFromCacheAndStorage(image);
      setState(() {
        _imageFiles.remove(image);
      });
    }
  }
}
