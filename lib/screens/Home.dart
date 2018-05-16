import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geeky_news_mobile/services/HackerNewsProvider.dart';
import 'package:geeky_news_mobile/models/HackerNewsItem.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _stories = List<HackerNewsItem>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getTopList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.cake),
          title: Text("Geeky News"),
          elevation: 0.7,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home), tooltip: 'Hi', onPressed: () => {})
          ],
        ),
        body:
        _buildList()
    );
  }

  Widget _buildList() {
    return  ListView.builder(
      itemCount: _stories.length,
      itemBuilder: (context, index) {
        final story = _stories[index];

        if (index == _stories.length - 1) {
          _getTopList();
        }
        return _buildRow(story);
      },
    );
  }

  Widget _buildRow(HackerNewsItem story) {
    final subTitle = story.author + " - " ;

    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Image.network(
                  "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-1/p480x480/31706598_1727513840671187_8718130024231731200_n.png?_nc_cat=0&oh=38e4cd08b14034627ff7e84190726c57&oe=5B60B74A",
                  width: 40.0),
            ),
            title: Text(story.title),
            subtitle: Text(subTitle),
            trailing: Icon(Icons.comment),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }


  _getTopList() async {
    try {
      final api = HackerNewsProvider();
      final list = await api.getLatestNews()
          .then((ids) => ids.take(10)
          .map ((id) async => await api.getItem(id)));

      List<HackerNewsItem> items = await Future.wait(list);
      setState(() {
        this._stories.addAll(items);
      });
    } catch (e) {
      print(e);
    }
  }
}
