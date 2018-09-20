import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Test1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "test1",
      body: Container(
      child: RaisedButton(
        onPressed: () {
          Test2Main a = Test2Main("idSerewr", "namedfsdfsdf", 45, "streetdfsdfsdf");
          Test1Main b = a;
          b.save();
        },
        child: Text("Test1"),
      ),
    ),
    );
  }
}

class Test1Main {
  String id;
  String name;

  Test1Main(this.id, this.name);
  
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name
    };
  }

  void save() {
    Firestore.instance.collection("test").add(this.toMap());
  }
}

class Test2Main extends Test1Main {
  int age;
  String street;
  Test2Main(String id, String name, this.age, this.street) : super(id, name);
  
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      "age": age,
      "street": street
    });
    return map;
  }
}