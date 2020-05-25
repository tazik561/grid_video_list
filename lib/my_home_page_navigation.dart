import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

import 'model/category_item_model.dart';
import 'model/category_model.dart';
import 'provider/home_tab_provider.dart';

class MyHomePageNavigation extends StatefulWidget {
  MyHomePageNavigation({Key key}) : super(key: key);

  @override
  _MyHomePageNavigationState createState() => _MyHomePageNavigationState();
}

class _MyHomePageNavigationState extends State<MyHomePageNavigation> {
  CategoryModel _categories;
  int _selectedCat = 1;


  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  void _getCategory() async {
    _categories = await HomeTabProvider().getCategories();
    _selectedCat = _categories.pagination.currentPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        brightness: Brightness.light,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextFormField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tap to search",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // bottomOpacity: 1,
      ),
      body: _categories == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  height: 50.0,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.data.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {
                                _selectedCat = _categories.data[index].id;
                                setState(() {
                                  print("selectedCat $_selectedCat");
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                child: Text(
                                  _categories.data[index].title,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedCat == _categories.data[index].id ? Colors.black : Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          _selectedCat == _categories.data[index].id ? Container(
                            width: 30.0,
                            height: 2.0,
                            color: Colors.purple,
                          ): Container(),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(child: CatItemWidget(selectedCat: _selectedCat))
              ],
            ),
    );
  }
}

class CatItemWidget extends StatefulWidget {
  final int selectedCat;
  const CatItemWidget({@required this.selectedCat});

  @override
  _CatItemWidgetState createState() => _CatItemWidgetState();
}

class _CatItemWidgetState extends State<CatItemWidget> {
  Future _futureCategory;

  @override
  void initState() {
    _getCategoryItem();
    super.initState();
  }

  @override
  void didUpdateWidget(CatItemWidget oldWidget) {
    print("oldWidget.searchTerm is ${oldWidget.selectedCat}");
    _getCategoryItem();
    super.didUpdateWidget(oldWidget);
  }

  void _getCategoryItem() async {
    _futureCategory = HomeTabProvider().getCategoryItems(widget.selectedCat);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<CategoryItemModel>(
        future: _futureCategory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (ctx, index) => GridItemWidget(
                data: snapshot.data,
                index: index,
              ),
            );
          } else {
            return Center(
              child: Text("Something wrong"),
            );
          }
        },
      ),
    );
  }
}

class GridItemWidget extends StatefulWidget {
  final CategoryItemModel data;
  final int index;

  const GridItemWidget({this.data, this.index});

  @override
  _GridItemWidgetState createState() => _GridItemWidgetState();
}

class _GridItemWidgetState extends State<GridItemWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.network(widget.data.data[widget.index].source)
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: _controller.value.initialized
          ? Container(
              width: 100.0,
              height: 86.0,
              child: VideoPlayer(_controller),
            )
          : Center(child: CircularProgressIndicator()),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.data.data[widget.index].title,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: Text("${widget.data.data[widget.index].product.price}\$",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: RichText(
                  text: TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 18,
                    )),
                    TextSpan(
                        text: "${widget.data.data[widget.index].rate}\$",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
