import 'package:flutter/material.dart';

class SortDialog extends StatefulWidget {
  List<String> sortOptions;
  int selected;

  SortDialog({this.sortOptions, this.selected});
  @override
  _SortDialogState createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text("Sort"),
      content: Container(
        height: 170.0,
        width: 250.0,
        child: ListView.builder(
          itemCount: widget.sortOptions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Container(
                child: Row(
                  children: <Widget>[
                    widget.selected == index
                        ? Icon(Icons.radio_button_checked)
                        : Icon(Icons.radio_button_unchecked),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text("${widget.sortOptions[index]}")
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context, index);
              },
            );
          },
        ),
      ),
    );
  }
}