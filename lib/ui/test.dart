
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_firebase_class.dart';
import 'package:uuid/uuid.dart';

final Firestore firestore = Firestore.instance;
final uuid = new Uuid();
List<UserInfoFirebase> userInfos = [
  UserInfoFirebase(id: uuid.v4(), displayName: "Martin Jensen", email: "martin@hotmail.com", photoUrl: "https://picsum.photos/200/200/?random"),
  UserInfoFirebase(id: uuid.v4(), displayName: "Knud Madsen", email: "knud@hotmail.com", photoUrl: "https://picsum.photos/200/200/?random"),
  UserInfoFirebase(id: uuid.v4(), displayName: "Bettina Revenfelt", email: "bettina@hotmail.com", photoUrl: "https://picsum.photos/200/200/?random"),
  UserInfoFirebase(id: uuid.v4(), displayName: "Julie Madsen", email: "julie@hotmail.com", photoUrl: "https://picsum.photos/200/200/?random")
];

//We Use Firebaseuser uid as key;
List<Map<String, dynamic>> users = [
  {
    "displayName": "Christian Nicolaisen",
    "email": "cvn@hotmail.com",
    "photoUrl": "https://picsum.photos/200/200/?random"
  },
  {
    "displayName": "Anders Nielsen",
    "email": "anders@hotmail.com",
    "photoUrl": "https://picsum.photos/200/200/?random"
  },
  {
    "displayName": "Irene Hansen",
    "email": "irene@hotmail.com",
    "photoUrl": "https://picsum.photos/200/200/?random"
  },
  {
    "displayName": "Mathilde Markussen",
    "email": "mathilde@hotmail.com",
    "photoUrl": "https://picsum.photos/200/200/?random"
  },
  {
    "displayName": "Michael Tygesen",
    "email": "michael@hotmail.com",
    "photoUrl": "https://picsum.photos/200/200/?random"
  }
];

List<Map<String, dynamic>> users3 = [
  {
    "date": DateTime.now(),
    "displayName": "Hans Hansen",
    "email": "hans@hotmail.com",
    "photoUrl": "https://picsum.photos/200/200/?random"
  },
  {
    "date": DateTime.now(),
    "displayName": "Lone Schults",
    "email": "lone@hotmail.com",
    "photoUrl": "https://picsum.photos/200/200/?random"
  }
];



class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // child: RaisedButton(
        //   onPressed: () {
        //         users3.forEach((user) async {
        //           await firestore.collection("users").document(uuid.v4()).setData(user);
        //         });            
        //   },
        // ),
      child: StreamBuilder(
        stream: firestore.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return ListView(
            children: snapshot.data.documents.map<Widget>((DocumentSnapshot document){
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),

                  child: Image.network(
                  document["photoUrl"],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                  ),
                ),
                title: Text(document["email"]),
                subtitle: Text(document.documentID),
                contentPadding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
              );
            }).toList(),            
          );
        },
      ),
      
    ),
    );
  }
}

// class TestWidget extends StatelessWidget {
//   final uuid = new Uuid();
//   final Firestore firestore = Firestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         constraints: BoxConstraints.expand(),
//         color: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             RaisedButton(
//               child: Text("Indsæt brugere"),
//               onPressed: () {
//                 users.forEach((user) async {
//                   await firestore.collection("users").document(uuid.v4()).setData(user);
//                 });
//               },
//             ),
//             RaisedButton(
//               child: Text("Indsæt brugere2"),
//               onPressed: () {
//                 userInfos.forEach((user) async {
//                   await firestore.collection("users").document(user.id).setData(user.toMap());
//                 });
//               },
//             ),
//             RaisedButton(
//               child: Text("Get brugere"),
//               onPressed: () async {
//                 QuerySnapshot snapshot = await firestore.collection("users").getDocuments();
//                 snapshot.documents.forEach((document) {
//                   // print("${document.data.toString()}");
//                   print("${document.documentID}");
//                 });
//               },
//             ),
//             // StreamBuilder(
//             //   stream: firestore.collection("users").snapshots(),
//             //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             //     return Text("Lalala");
//             //     // if (!snapshot.hasData) return new Text('Loading...');
//             //     // return ListView(
//             //     //   children: snapshot.data.documents.map<Widget>((DocumentSnapshot document){
//             //     //     return new ListTile(
//             //     //       title: document["name"],
//             //     //       subtitle: document["email"],
//             //     //       leading: Image.network(document["photoUrl"]),
//             //     //     );
//             //     //   }).toList()
//             //     // );
//             //   },
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }
//   Future<Null> _askedToLead(BuildContext context) async {
//     final _formKey = GlobalKey<FormState>();

//     var result = await showDialog<int>(
//         context: context,
//         builder: (BuildContext context) {
//           return new SimpleDialog(
//             title: const Text('Opret nyhed'),
//             children: <Widget>[
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: <Widget>[
//                     TextFormField(
//                       decoration: InputDecoration(labelText: "Titel"),
//                       onSaved: (String value) {},
//                     ),
//                     TextFormField(
//                       decoration: InputDecoration(labelText: "Titel"),
//                       onSaved: (String value) {},
//                     )
//                   ],
//                 ),
//               )
//             ],
//           );
//         });

//     print(result);
//   }
// }
