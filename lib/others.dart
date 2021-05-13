import 'package:flutter/material.dart';

class HomePageAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0, // in logical pixels
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: Colors.blue[500]),
        // Row is a horizontal, linear layout.
        child: Row(
          // <Widget> is the type of items in the list.
          children: <Widget>[
            Expanded(
              child: Text(
                  'Things To Do',
                  style: Theme.of(context) //
                      .primaryTextTheme
                      .headline6
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              tooltip: 'Search',
              onPressed: null,
            ),
            IconButton(
              icon: Icon(
                IconData(
                    0xe9fe,
                    fontFamily: 'MaterialIcons',
                    matchTextDirection: true
                ),
                color: Colors.white,
              ),
              onPressed: null,
            )
          ],
        )
    );
  }
}

class DetailPageAppBar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0, // in logical pixels
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: Colors.blue[500]),
        // Row is a horizontal, linear layout.
        child: Row(
          // <Widget> is the type of items in the list.
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              tooltip: 'Back',
              onPressed: null,
            ),
            Expanded(
              child: Text(
                  'New',
                  style: Theme.of(context) //
                      .primaryTextTheme
                      .headline6
              ),
            ),
          ],
        )
    );
  }
}