import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/build_build_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_pictures_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_fields_create_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/photo_functions.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_text_field.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_event_fields.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import '../../helpers/photo_functions.dart' as photoFunctions;

class EditBulletinItem extends StatefulWidget {
  final BulletinItemData bulletinItem;

  const EditBulletinItem(this.bulletinItem);

  @override
  _EditBulletinItemState createState() => _EditBulletinItemState();
}

class _EditBulletinItemState extends State<EditBulletinItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController =
      new TextEditingController();
  final TextEditingController _endDateController = new TextEditingController();
  final TextEditingController _startTimeController =
      new TextEditingController();
  final TextEditingController _endTimeController = new TextEditingController();
  ItemFieldsCreate itemFieldsValue;
  List<ImageInfoData> _imageFiles = [];
  List<ImageInfoData> _imageFilesDelete = [];
  bool _showOverlay = false;
  String _overlayText = "";

  @override
  void initState() {
    super.initState();
    itemFieldsValue = ItemFieldsCreate.fromBulletinItem(widget.bulletinItem);

    if (itemFieldsValue.type == BulletinType.news) {
      _imageFiles = (widget.bulletinItem as BulletinNewsItemData)
          .images
          .map<ImageInfoData>((BulletinImageData data) {
        return ImageInfoData.fromBulletinImageData(data);
      }).toList();
    }

    if (itemFieldsValue.type == BulletinType.event) {
      _imageFiles.add(ImageInfoData.fromBulletinImageData(
          (widget.bulletinItem as BulletinEventItemData).eventImage));
    }
  }

  @override
  void dispose() {
    photoFunctions.removeImagesFromCacheAndStorage(_imageFiles);
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  String _getTitle(BuildContext context, BulletinType type) {
    String title = "";
    if (type == BulletinType.news)
      title = FlutterI18n.translate(
          context, "bulletin.bulletinEdititemMain.title1");
    if (type == BulletinType.event)
      title = FlutterI18n.translate(
          context, "bulletin.bulletinEdititemMain.title2");
    if (type == BulletinType.play)
      title = FlutterI18n.translate(context, "bulletin.bulletinEdititemMain.title3");
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _getTitle(context, itemFieldsValue.type), 
        body: LoaderSpinnerOverlay(
          show: _showOverlay,
          text: _overlayText,
          child: _main(),
        )
      );
  }

  Widget _main() {
    List<Widget> widgets = [
      _createBulletinItemForm(context),
    ];

    if (itemFieldsValue.type == BulletinType.news)
      widgets.add(BulletinItemPictures(
        type: BulletinImageType.network,
        useSquareOnOddImageCount: true,
        images: _imageFiles,
        onTapImageSelected: (image) {
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
    if (itemFieldsValue.type == BulletinType.event) {
      widgets.add(_eventFields());
      widgets.add(_textField());
    } else {
      widgets.add(_textField());
    }

    return widgets;
  }

  Widget _eventFields() {
    _startDateController.text =
        DateTimeHelpers.ddmmyyyy(itemFieldsValue.eventStartDate);
    _endDateController.text =
        DateTimeHelpers.ddmmyyyy(itemFieldsValue.eventEndDate);
    _startTimeController.text =
        DateTimeHelpers.hhnn(itemFieldsValue.eventStartTime);
    _endTimeController.text =
        DateTimeHelpers.hhnn(itemFieldsValue.eventEndTime);
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
        initalValue: itemFieldsValue.body,
        onPressedSave: (_) {
          _saveMain();
        },
        onPressedPhoto:
            itemFieldsValue.type == BulletinType.news ? _addPhoto : null,
        onSave: (String value) {
          itemFieldsValue.body = value;
        },
        showPhotoButton: itemFieldsValue.type == BulletinType.news);
  }

  void _saveMain() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _overlayText = FlutterI18n.translate(context, "bulletin.bulletinEdititemMain.string1");
        _showOverlay = true;              
      });
      _formKey.currentState.save();

      await _saveBulletinItem();
      setState(() {
        _showOverlay = false;              
      });
      Navigator.of(context).pop();
    }
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

    await _removeExistingPhotosOnSave();
    _imageFilesDelete.clear();
    _imageFiles.clear();
    return data.save(MainInherited.of(context).loggedInUser);
  }

  void _addPhoto() async {
    setState(() {
      _overlayText = FlutterI18n.translate(context, "bulletin.createItemMain.string2");
      _showOverlay = true;
    });

    ImageInfoData imageInfo =
        await photoFunctions.addPhoto(context, itemFieldsValue.type, imageStartProcessing);

    if (imageInfo != null && imageInfo.linkFirebaseStorage.isNotEmpty) {
      _imageFiles.add(imageInfo);
    }

    setState(() {
      _showOverlay = false;
    });
  }

  void imageStartProcessing(bool value) {
    setState(() {
      _overlayText = FlutterI18n.translate(context, "bulletin.bulletinEdititemMain.string3");          
    });
  }

  Future<void> _removePhoto(ImageInfoData image) async {
    setState(() {
      _overlayText = FlutterI18n.translate(context, "bulletin.bulletinEdititemMain.string4");          
      _showOverlay = true;
    });

    PhotoAction action = await photoFunctions.removePhoto(context);

    if (action != null && action == PhotoAction.delete) {
      if (image.state == ImageInfoState.exists) {
        _imageFilesDelete.add(image);
        _imageFiles.remove(image);
      } else {
        await ImageHelpers.deleteImageFromCacheAndStorage(image);
        _imageFiles.remove(image);
      }
    }

    setState(() {
      _showOverlay = false;
    });
  }

  Future<void> _removeExistingPhotosOnSave() async {
    _imageFilesDelete.forEach((ImageInfoData image) async {
      await ImageHelpers.deleteImageFromCacheAndStorage(image);
    });
  }
}
