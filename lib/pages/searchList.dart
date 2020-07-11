import 'package:feiyu/app/model/movie.dart';
import 'package:feiyu/app/model/player.dart';
import 'package:feiyu/app/model/site.dart';
import 'package:feiyu/app/tool/search.dart';
import 'package:feiyu/app/widget/myBottomInput.dart';
import 'package:feiyu/app/widget/myImage.dart';
import 'package:feiyu/app/widget/myText.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import 'detail.dart';

class SearchList extends StatefulWidget {
  final String title;
  final Player player;
  final List<Site> sites;
  SearchList(this.title, {@required this.sites, @required this.player});
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _tabs = [];
  bool loading = false;
  bool api = true;

  List<Movie> movies = [];
  String keyword = '';
  List<List<Movie>> tabMovies = [];
  double screenWidth = ScreenUtil.getInstance().screenWidth;
  double screenHeight = ScreenUtil.getInstance().screenHeight;

  @override
  void initState() {
    super.initState();
    keyword = widget.title;
    _tabs = widget.sites.map<String>((site) => site.name).toList();
    _tabs.sort(); //排序
    tabMovies = new List<List<Movie>>(_tabs.length);
    //tab切换controller
    _tabController = new TabController(vsync: this, length: _tabs.length);
    setState(() {}); //刷新界面
    setListener();
    search(); //首次搜索
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void setListener() {
    _tabController.addListener(() async {
      var i = _tabController.index;
      //监听页面被切换时
      if (tabMovies[i] != null) {
        //再次切换
        movies = tabMovies[i];
        setState(() {});
        return;
      }
      //首次切换
      await search();
    });

    ///监听TabController的动画，实时刷新，这样选中背景就能跟随移动了
    _tabController.animation.addListener(() {
      if (!(_tabController.animation.value % 1 == 0)) {
        loading = true;
      } else {
        loading = false;
      }
      setState(() {});
    });
  }

  Future<void> search() async {
    loading = true;
    setState(() {});
    String siteName = _tabs[_tabController.index];
    if (api) {
      movies = await Search.api(keyword,
          widget.sites[widget.sites.indexWhere((s) => s.name == siteName)]);
    } else {
      movies = await Search.web(keyword,
          widget.sites[widget.sites.indexWhere((s) => s.name == siteName)]);
    }
    tabMovies[_tabController.index] = movies;
    loading = false;
    setState(() {});
  }

  onTapSearch() async {
    keyword = '';
    var s = await myBottomInput(context,
        title: '搜索', hint: '请输入电影名称...', autoFocus: true);
    if (s != null) {
      keyword = s;
      //重置搜索结果
      tabMovies = new List<List<Movie>>(_tabs.length);
      await search();
    }
  }

  void play(Movie movie) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Detail(movie, player: widget.player),
      ),
    );
  }

  Widget myMovieItem(Movie movie) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        play(movie);
      },
      child: Container(
        margin: EdgeInsets.all(screenWidth / 20 * 0.5),
        child: ListTile(
          leading: Hero(
              tag: movie.cover + 'bg',
              child: Container(
                  width: screenWidth / 20 * 2.4,
                  height: screenWidth / 20 * 4,
                  child: MyImage(movie.cover, fit: BoxFit.cover))),
          title: Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            movie.desp,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          trailing: Container(
            margin: EdgeInsets.all(screenWidth / 20),
            child:
                Icon(Icons.play_circle_filled, size: 32, color: Colors.yellow),
          ),
        ),
      ),
    );
  }

  Widget loadingPage() {
    return Container(
        width: screenWidth,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(child: SizedBox()),
            Offstage(
              offstage: !loading,
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 24),
            myText(loading ? '搜索中...' : '啥都没搜到~', color: Colors.black),
            Expanded(flex: 2, child: SizedBox()),
          ],
        ));
  }

  Widget myBody() {
    return (loading || movies.length < 1)
        ? loadingPage()
        : RefreshIndicator(
            onRefresh: search,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == movies.length - 1)
                    return Container(
                        height: screenHeight,
                        alignment: Alignment.topCenter,
                        child: myMovieItem(movies[index]));
                  return myMovieItem(movies[index]);
                }));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: myText(keyword,
              size: 18, overflow: TextOverflow.ellipsis, big: FontWeight.bold),
          actions: <Widget>[
            IconButton(
                icon: myText(api ? 'A' : 'W', size: 16, big: FontWeight.bold),
                onPressed: () async {
                  setState(() {
                    api = !api;
                  });
                  //重新搜索
                  await search();
                })
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(20),
            indicatorWeight: 10,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black54,
            controller: this._tabController,
            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
          ),
        ),
        body: TabBarView(
          controller: this._tabController,
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return myBody();
                },
              ),
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: onTapSearch, 
          child: Icon(Icons.search,color: Colors.white),
        ),
      ),
    );
  }
}
