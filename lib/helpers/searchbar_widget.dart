import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> searchValue;

  const SearchBar({Key key, this.searchValue}) : super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _showSearchClearButton = false;
  bool _showSearchButton = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (String value) {
          if (value.isNotEmpty && _showSearchClearButton == false) {
            if (mounted) {
              setState(() {
                _showSearchClearButton = true;
                _showSearchButton = true;
              });
            }
          }
        },
        controller: _searchController,
        decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _showSearchClearButton
                      ? () {
                          _search("");
                          _searchController.text = "";

                          if (mounted) {
                            setState(() {
                              _showSearchClearButton = false;
                              _showSearchButton = false;
                            });
                          }
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _showSearchButton
                      ? () {
                          _search(_searchController.text.toLowerCase());
                        }
                      : null,
                )
              ],
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            hintText: "Søg"),
      ),
    );
  }

  _search(String value) {
    widget.searchValue(value);
  }
}
