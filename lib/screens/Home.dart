import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geeky_news_mobile/services/HackerNewsProvider.dart';
import 'package:geeky_news_mobile/models/HackerNewsItem.dart';
import 'package:timeago/timeago.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _stories = List<HackerNewsItem>();
  var _isRefreshing = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          title: Text("Geeky News"),
          elevation: 0.7,
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  _refreshIndicatorKey.currentState.show();
                }
            ),
          ],
        ),
        body:
//        _buildList(),
        RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: _buildList(),

        )
    );
  }

  Widget _buildList() {
    return  ListView.builder(
      itemCount: _stories.length,
      itemBuilder: (context, index) {
        final story = _stories[index];

//        if (index == _stories.length - 1) {
//          _getTopList();
//        }
        return _buildRow(story);
      },
    );
  }

  Widget _buildRow(HackerNewsItem story) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(story.time * 1000);
    final subTitle = story.author + " - " + timeAgo(date) ;


    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
//            leading: CircleAvatar(
//              child: Image.network(
//                  "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-1/p480x480/31706598_1727513840671187_8718130024231731200_n.png?_nc_cat=0&oh=38e4cd08b14034627ff7e84190726c57&oe=5B60B74A",
//                  width: 40.0),
//            ),
            title: Text(story.title),
            subtitle: Text(subTitle),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.thumb_up,
                color: Theme.of(context).primaryColor,),
                Text(story.score.toString()),
              ],
            ),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Future<Null> _getTopList() async {
    this.setState(() {
      this._isRefreshing = true;
    });

    try {
      final api = HackerNewsProvider();
      final list = await api.getHotNews()
          .then((ids) => ids.take(20)
          .map ((id) async => await api.getItem(id)));

      List<HackerNewsItem> items = await Future.wait(list);
      print(items);
      setState(() {
        this._stories.addAll(items);
        this._isRefreshing = false;
      });
      return null;
    } catch (e) {
      print(e);
      this._isRefreshing = false;
      return null;
    }
  }

  Future<Null> _handleRefresh() async {
      this.setState(() {
        this._stories.clear();
      });

      return this._getTopList();
  }
}
