import 'package:flutter/material.dart';
import 'package:recodo/model/record.dart';
import 'package:recodo/util/database_helper.dart';

class RecordScreen extends StatefulWidget {
  final Record record;
  RecordScreen(this.record);

  @override
  State<StatefulWidget> createState() => new _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  DatabaseHelper db = new DatabaseHelper();

  TextEditingController _titleController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.record.title);
    _descriptionController =
        new TextEditingController(text: widget.record.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.record.id != null) ? Text('Update') : Text('Add'),
              onPressed: () {
                if (widget.record.id != null) {
                  db
                      .updateRecord(Record.fromMap({
                    'id': widget.record.id,
                    'title': _titleController.text,
                    'description': _descriptionController.text
                  }))
                      .then((_) {
                    Navigator.pop(context, 'update');
                  });
                } else {
                  db
                      .saveRecord(Record(
                          _titleController.text, _descriptionController.text))
                      .then((_) {
                    Navigator.pop(context, 'save');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
