
    
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'github_search_api.dart';
import 'github_search_widget.dart';
import 'redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';



final store = new Store<SearchState>(
  searchReducer,
  initialState: new SearchState.initial(), 
  middleware: [
//        SearchMiddleware(GithubApi()),
    EpicMiddleware<SearchState>(SearchEpic(GithubApi())),
  ]);

    
class SearchRedux extends StatefulWidget {
  final Store<SearchState> store;

   SearchRedux({Key key, this.store}) : super(key: key);

  @override
  _SearchReduxState createState() => _SearchReduxState();
}

class _SearchReduxState extends State<SearchRedux> {
  
  void initState() {
    
    super.initState();
    
      // _datanew="new";
      //  _loopingListData();
    // _listAchievment= _listAchievment;
    //da
    store:store;
    
  }
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<SearchState>(
      store: store,
      child: new MaterialApp(
        title: 'RxDart Search',
        theme: new ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
        ),
        home: new SearchScreen(),
      ),
    );
  }
}


