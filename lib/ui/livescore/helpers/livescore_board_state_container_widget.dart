// import 'package:flutter/material.dart';

// class Item {
//    int reference;

//    Item(this.reference);
// }

// class _MyInherited extends InheritedWidget {
//   _MyInherited({
//     Key key,
//     @required Widget child,
//     @required this.data,
//   }) : super(key: key, child: child);

//   final MyInheritedWidgetState data;

//   @override
//   bool updateShouldNotify(_MyInherited oldWidget) {
//     return true;
//   }
// }

// class MyInheritedWidget extends StatefulWidget {
//   MyInheritedWidget({
//     Key key,
//     this.child,
//   }): super(key: key);

//   final Widget child;

//   @override
//   MyInheritedWidgetState createState() => new MyInheritedWidgetState();

//   static MyInheritedWidgetState of(BuildContext context){
//     return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
//   }
// }

// class MyInheritedWidgetState extends State<MyInheritedWidget>{
//   /// List of Items
//   List<Item> _items = <Item>[];

//   /// Getter (number of items)
//   int get itemsCount => _items.length;

//   /// Helper method to add an Item
//   void addItem(int reference){
//     setState((){
//       _items.add(new Item(reference));
//     });
//   }

//   @override
//   Widget build(BuildContext context){
//     return new _MyInherited(
//       data: this,
//       child: widget.child,
//     );
//   }
// }