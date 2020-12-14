// Reducer
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/page/redux/action.dart';
// import 'package:yamisok/page/redux/reducer.dart';


AppState reducer(AppState prev, dynamic action) {
  //prev.quote = 'This is from reducer';
  Map current_state = prev.state;
//  print("show current state $current_state");
  return prev;
}
