import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/helpers/searchbar_widget.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_detail_main.dart';
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
      title: "Medlemmer",
      body: ListView(
        children: <Widget>[
          SearchBar(
            searchValue: _search,
          ),
          _enrollmentList()
        ],
      ),
    );
  }

  Widget _enrollmentList() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int position) {
          EnrollmentUserData item = _data[position];
          return GestureDetector(
            child: _row(item),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => EnrollmentDetail(enrollment: item)
              ));
            },
          );
        },
      ),
    );
  }

  Widget _row(EnrollmentUserData item) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(DateTimeHelpers.ddmmyyyyHHnn(item.creationDate))
              ],
            ),
            Row(
              children: <Widget>[Text(item.name)],
            ),
            Row(
              children: <Widget>[Text(item.street)],
            ),
            Row(
              children: <Widget>[Text(item.postalCode.toString())],
            ),
          ],
        ),
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
}
