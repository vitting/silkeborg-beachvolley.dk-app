import 'dart:async';

abstract class BaseData {
  BaseData();
  Map<String, dynamic> toMap();
  Future<void> save();
  Future<void> delete();
}