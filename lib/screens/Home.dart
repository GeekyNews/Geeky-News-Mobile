import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: new Icon(Icons.cake),
          title: new Text("Geeky News"),
          elevation: 0.7,
          actions: <Widget>[
            new IconButton(icon:
            new Icon(Icons.home),
                tooltip: 'Hi',
                onPressed: () => {})
          ],
        ),

        body: new ListView.builder(
          itemCount: 20,
          itemBuilder: (context, rowNumber) {
            return new Container(
              child: Column(
                children: <Widget>[
                  new ListTile(
                    leading: new CircleAvatar(child: Image.network("https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-1/p480x480/31706598_1727513840671187_8718130024231731200_n.png?_nc_cat=0&oh=38e4cd08b14034627ff7e84190726c57&oe=5B60B74A"
                        , width: 40.0),),
                    title: new Text("row $rowNumber"),
                    subtitle: new Text("Daniel - $rowNumber hours ago"),
                    trailing: new Icon(Icons.comment),
                  ),
                  new Divider(height: 1.0,),
                ],
              ),
            );
          },
        )
    );
  }
}