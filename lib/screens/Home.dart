import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geeky_news_mobile/services/HackerNewsProvider.dart';
import 'package:geeky_news_mobile/models/HackerNewsItem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _stories = List<HackerNewsItem>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
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
                }),
          ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: _buildList(),
        ));
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _stories.length,
      itemBuilder: (context, index) {
        final item = _stories[index];

//        if (index == _stories.length - 1) {
//          _getTopList();
//        }
        return _buildRow(item);
      },
    );
  }

  Widget _buildRow(HackerNewsItem item) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
    final subTitle = item.author + " - " + timeago.format(date);

    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
//            leading: CircleAvatar(
//              child: Image.network(
//                  "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-1/p480x480/31706598_1727513840671187_8718130024231731200_n.png?_nc_cat=0&oh=38e4cd08b14034627ff7e84190726c57&oe=5B60B74A",
//                  width: 40.0),
//            ),
            title: Text(item.title),
            subtitle: Text(subTitle),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.thumb_up,
                  color: Theme.of(context).primaryColor,
                ),
                Text(item.score.toString()),
              ],
            ),
            onTap: () {
              this._launchDetail(item);
            },
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Future<Null> _getTopList() async {
    try {
      final api = HackerNewsProvider();
      final list = await api
          .getHotNews()
          .then((ids) => ids.take(50).map((id) async => await api.getItem(id)));

      List<HackerNewsItem> items = await Future.wait(list);
      print(items);
      setState(() {
        this._stories.addAll(items);
      });
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Null> _handleRefresh() async {
    this.setState(() {
      this._stories.clear();
    });

    return this._getTopList();
  }

  // Open URL

  _launchDetail(HackerNewsItem item) async {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (_) => new WebviewScaffold(
              url: item.url,
              appBar: AppBar(
                title: Text(item.title),
              ),
              withJavascript: true,
              withLocalStorage: true,
              withZoom: true,
            ),
      ),
    );
  }
}
