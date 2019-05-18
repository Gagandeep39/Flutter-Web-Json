import 'package:flutter_web/material.dart';
import 'dart:convert';
import 'dart:async';
import "package:http/http.dart" as http;

void main() => runApp(MyApps());

class MyApps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JSON Parse"),
      ),
      body: Center(
        child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) { //Connection state=> none, active, waiting, done
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Check source code :p');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ));
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  return ListViewWidget(snapshot.data);
              }
            },
            future: getJson()),
      ),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  final _data;
  ListViewWidget(this._data);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: _data.length,
      itemBuilder: (BuildContext context, int position) {
//          Below 2 lines required when using ListView.builder , when using ListView.separated this extra problem is removed
//          if (position.isOdd) return Divider();
//          final index = position ~/ 2; //used since the order is getting messaed up because of above Divider (previously items were 1,3,5,7) and now (1,2,3,4,5)
        final index = position;

        return ListTile(
          contentPadding: EdgeInsets.all(16.0),
          title: Text("${_data[index]['title']}"),
          subtitle: Text("${_data[index]['body']}"),
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child:
            Text("${_data[index]['title'][0].toString().toUpperCase()}"),
          ),
          onTap: () {
            _showOnTap(context, "${_data[index]['title']}");
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {return Divider();},
    );
  }
}

///   Sample JSON data
///[
///  {
///    "userId": 1,
///    "id": 1,
///    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
///    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
///  }]
Future<List> getJson() async {
  String apiUrl = "http://jsonplaceholder.typicode.com/posts";
  http.Response response = await http.get(
      apiUrl); //data will be stored in response object only after getting a response fo url tht is because of await
  return jsonDecode(response.body);
}

void _showOnTap(BuildContext context, String message) {
  var alert = new AlertDialog(
    title: Text("Aler Dialog"),
    content: Text(message),
    actions: <Widget>[
      RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Ok"),
        color: Colors.blue,
        textColor: Colors.white,
      ),
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel"),
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
}