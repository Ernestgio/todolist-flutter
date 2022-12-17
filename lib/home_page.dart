import 'package:flutter/material.dart';
import 'package:todolist/todo.dart';
import 'package:todolist/todo_card.dart';
import 'package:todolist/database_helper.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'add_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Todo>> _displayedTodos;
  bool isDoneFilterOn;

  Widget appBarTitle;
  IconData appBarSearchIcon;
  Future<Map<String, dynamic>> locData;

  @override
  void initState(){
    super.initState();
    _updateTodoList(false);
    appBarSearchIcon = Icons.search;
    appBarTitle = Text('Things to do');
    isDoneFilterOn = false;
    _queryData();
  }

  _updateTodoList(statusFilter) {
    if(statusFilter){
      setState(() {
        _displayedTodos = DatabaseHelper.instance.getDoneTodoList();
      });
    }
    else{
      setState(() {
        _displayedTodos = DatabaseHelper.instance.getTodoList();
      });
    }
  }

  _searchTodoList(queryString){
    setState(() {
      _displayedTodos = DatabaseHelper.instance.searchTodoList(queryString);
      appBarSearchIcon = Icons.search;
      appBarTitle = Text('Things to do');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
              icon: Icon(
                appBarSearchIcon,
                color: Colors.white,
              ),
              tooltip: 'Search',
              onPressed: (){
                if (appBarSearchIcon == Icons.search) {
                  setState(() {
                    appBarSearchIcon = Icons.close;
                    appBarTitle = TextField(
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Search todos",
                          isDense: true,
                          contentPadding: EdgeInsets.all(4.0),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onSubmitted: (searchKey){
                        _searchTodoList(searchKey);
                      },
                    );
                  });
                }
                else{
                  setState(() {
                    appBarSearchIcon = Icons.search;
                    appBarTitle = Text('Things to do');
                  });
                }

              },
          ),
          PopupMenuButton(
            icon: Icon(
              IconData(
                  0xe9fe,
                  fontFamily: 'MaterialIcons',
                  matchTextDirection: true
              ),
              color: Colors.white,

            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Expanded(child: Text('Status')),
                    Checkbox(value: isDoneFilterOn, onChanged: (newValue){
                      setState(() {
                        isDoneFilterOn = newValue;
                      });
                      _updateTodoList(isDoneFilterOn);
                    })
                  ],
                ),
              ),
              PopupMenuItem(
                child: Text('Date'),
              ),
              PopupMenuItem(
                child: Text('Priority'),
              ),
            ],
          )
        ],
      ),
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder<Map<String,dynamic>>(
                future: locData,
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Text('Location loading...');
                  } else if (snapshot.hasError) {
                    return Text('Error');
                  }
                  return Center(
                        child: Text(
                          "Hello from " +
                          snapshot.data['deviceAdress'],
                          style: TextStyle(fontSize: 14.0),
                        ),
                  );
                }
              ),
              FutureBuilder<List<Todo>>(
                future: _displayedTodos,
                builder: (context,snapshot) {
                  if (!snapshot.hasData){
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){
                      return TodoCard(todo: snapshot.data[index],updateTodos: _updateTodoList,);
                    },
                  ),
                );}
              ),
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[400],
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddPage(updateTodos: _updateTodoList)));
          },
          child: Icon(Icons.add),
        ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Map<String, dynamic>> _trackLocation() async {
    Position currentPosition = await _determinePosition();
    List<Placemark> adressess = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    var pickedAdress = adressess[0];
    var deviceAdress =
        '${pickedAdress.name} ${pickedAdress.street} ${pickedAdress.postalCode} ${pickedAdress.locality} ${pickedAdress.country}';
    print(deviceAdress);
    return {
      "latitude": currentPosition.latitude,
      "longitude": currentPosition.longitude,
      "deviceAdress": deviceAdress
    };
  }

  _queryData() async {
    setState(() {
      locData = _trackLocation();
    });
  }
}
