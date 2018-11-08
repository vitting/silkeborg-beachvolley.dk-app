import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/build_build_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_pictures_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_fields_create_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/photo_functions.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_event_fields.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/get_bulletin_text_field.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import '../../helpers/photo_functions.dart' as photoFunctions;

class CreateBulletinItem extends StatefulWidget {
  final BulletinType bulletinType;

  const CreateBulletinItem(this.bulletinType);

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
  bool _loadingImage = false;
  @override
  void initState() {
    super.initState();

    itemFieldsValue.type = widget.bulletinType;
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
      title = FlutterI18n.translate(context, "bulletin.createItemMain.title1");
    if (type == BulletinType.event)
      title = FlutterI18n.translate(context, "bulletin.createItemMain.title2");
    if (type == BulletinType.play)
      title = FlutterI18n.translate(context, "bulletin.createItemMain.title3");
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _getTitle(context, widget.bulletinType),
        body: LoaderSpinnerOverlay(
          show: _saving,
          child: _main(),
          text:
              FlutterI18n.translate(context, "bulletin.createItemMain.string1"),
        ));
  }

  Widget _main() {
    List<Widget> widgets = [
      _createBulletinItemForm(context),
    ];

    if (widget.bulletinType == BulletinType.news)
      widgets.add(LoaderSpinnerOverlay(
        show: _loadingImage,
        showModalBarrier: false,
        text: FlutterI18n.translate(context, "bulletin.createItemMain.string2"),
        child: BulletinItemPictures(
          type: BulletinImageType.file,
          useSquareOnOddImageCount: true,
          images: _imageFiles,
          onTapImageSelected: (image) {
            if (image != null && image is ImageInfoData) {
              _removePhoto(image);
            }
          },
        ),
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
      widgets.add(_textField(context));
    } else {
      widgets.add(_textField(context));
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

  Widget _textField(BuildContext context) {
    return BulletinTextField(
        onPressedSave: () async {
          if (_formKey.currentState.validate()) {
            SystemHelpers.hideKeyboardWithFocus();
            _formKey.currentState.save();
            if (mounted) {
              setState(() {
                _saving = true;
              });
            }
            await _saveBulletinItem(context);
            if (mounted) {
              setState(() {
                _saving = false;
              });
            }

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

  Future<void> _saveBulletinItem(BuildContext context) async {
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
    return data.save(MainInherited.of(context).loggedInUser);
  }

  void _addPhoto() async {
    if (mounted) {
      setState(() {
        _loadingImage = true;
      });
    }
    ImageInfoData imageInfo =
        await photoFunctions.addPhoto(context, itemFieldsValue.type);

    if (imageInfo != null && imageInfo.linkFirebaseStorage.isNotEmpty) {
      if (mounted) {
        setState(() {
          _loadingImage = false;
          _imageFiles.add(imageInfo);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _loadingImage = false;
        });
      }
    }
  }

  void _removePhoto(ImageInfoData image) async {
    if (mounted) {
      setState(() {
        _loadingImage = true;
      });
    }
    PhotoAction action = await photoFunctions.removePhoto(context);

    if (action != null && action == PhotoAction.delete) {
      await ImageHelpers.deleteImageFromCacheAndStorage(image);
      if (mounted) {
        setState(() {
          _loadingImage = false;
          _imageFiles.remove(image);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _loadingImage = false;
        });
      }
    }
  }
}
