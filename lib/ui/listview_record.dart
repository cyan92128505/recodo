import 'package:flutter/material.dart';
import 'package:recodo/model/record.dart';
import 'package:recodo/util/database_helper.dart';
import 'package:recodo/ui/record_screen.dart';

class ListViewRecord extends StatefulWidget {
  @override
  _ListViewRecordState createState() => new _ListViewRecordState();
}

class _ListViewRecordState extends State<ListViewRecord> {
  List<Record> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getAllRecords().then((records) {
      setState(() {
        records.forEach((record) {
          items.add(Record.fromMap(record));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSA ListView Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListView Demo'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].title}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${items[position].description}',
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(10.0)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 15.0,
                            child: Text(
                              '${items[position].id}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _deleteRecord(
                                  context, items[position], position)),
                        ],
                      ),
                      onTap: () => _navigateToRecord(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewRecord(context),
        ),
      ),
    );
  }

  void _deleteRecord(BuildContext context, Record record, int position) async {
    db.deleteRecord(record.id).then((records) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToRecord(BuildContext context, Record record) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordScreen(record)),
    );

    if (result == 'update') {
      db.getAllRecords().then((records) {
        setState(() {
          items.clear();
          records.forEach((_record) {
            items.add(Record.fromMap(_record));
          });
        });
      });
    }
  }

  void _createNewRecord(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordScreen(Record('', ''))),
    );

    if (result == 'save') {
      db.getAllRecords().then((records) {
        setState(() {
          items.clear();
          records.forEach((record) {
            items.add(Record.fromMap(record));
          });
        });
      });
    }
  }
}
