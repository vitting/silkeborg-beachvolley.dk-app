import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/searchbar_widget.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_detail_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_edit_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class AdminEnrollment extends StatefulWidget {
  static String routeName = "admin_enrollment";
  @override
  _AdminEnrollmentState createState() => _AdminEnrollmentState();
}

class _AdminEnrollmentState extends State<AdminEnrollment> {
  static String routeName = "admin_enrollment";
  List<EnrollmentUserData> _data = [];
  List<EnrollmentUserData> _dataCache = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    _dataCache = await EnrollmentUserData.getAll();
    if (mounted) {
      setState(() {
        _data = _dataCache.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Administrer medlemmer",
      body: _main(),
    );
  }

  Widget _main() {
    return Container(
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: _data.length + 1,
          itemBuilder: (BuildContext context, int position) {
            if (position == 0) {
              return SearchBar(
                searchValue: _search,
              );
            }

            EnrollmentUserData item = _data[position - 1];
            return GestureDetector(
              child: _row(item),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) =>
                        EnrollmentDetail(enrollment: item)));
              },
              onLongPress: () {
                _popupMenu(context, item);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _row(EnrollmentUserData item) {
    return ListItemCard(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(DateTimeHelpers.ddmmyyyyHHnn(item.creationDate)),
          Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(item.street),
          Text("${item.postalCode.toString()} ${item.city}")
        ],
      ),
    );
  }

  void _search(String text) async {
    var search;
    if (text.isEmpty) {
      search = _dataCache.toList();
    } else {
      search = _dataCache.where((EnrollmentUserData data) {
        return data.name.toLowerCase().contains(text);
      }).toList();
    }

    if (mounted) {
      setState(() {
        _data = search;
      });
    }
  }

  void _popupMenu(BuildContext context, EnrollmentUserData item) async {
    EnrollmentPopMenuAction result =
        await showModalBottomSheet<EnrollmentPopMenuAction>(
            context: context,
            builder: (BuildContext contextModal) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text("Rediger"),
                      leading: Icon(Icons.edit),
                      onTap: () {
                        Navigator.of(contextModal)
                            .pop(EnrollmentPopMenuAction.edit);
                      },
                    ),
                  ],
                ),
              );
            });

    switch (result) {
      case EnrollmentPopMenuAction.edit:
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => EnrollmentEdit(item)));
        break;
      default:
    }
  }
}

enum EnrollmentPopMenuAction { edit, delete }
