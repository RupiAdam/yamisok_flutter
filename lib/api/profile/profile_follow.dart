import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:yamisok/page/redux/action.dart';
import 'dart:async';
import 'dart:convert';
import 'package:yamisok/page/redux/appstate.dart';
import 'package:yamisok/component/globals.dart' as globals;

Client client = Client();

class ApiServiceProfileFollow{

	static Future<String> getFollowing(String otherId, String selfId, String token) async {

		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-following?id=$otherId&offset=0&limit=50",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": "$selfId"
			},
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {

			var data = respJson["result"];
			Map map = {
				"status": 200,
				"data": data
			};

			return json.encode(map);

		}else {
			var message = respJson["messages"];

			Map map = {
				"status": statusCode,
				"messages": message
			};

			return json.encode(map);
		}

	}

	static Future<String> getFollowers(String otherId, String selfId, String token) async {
		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-follower?id=$otherId&offset=0&limit=50",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": "$selfId"
			},
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {

			var data = respJson["result"];
			Map map = {
				"status": 200,
				"data": data
			};

			return json.encode(map);

		}else {
			var message = respJson["messages"];

			Map map = {
				"status": statusCode,
				"messages": message
			};

			return json.encode(map);
		}
	}

	static Future<String> loadMoreFollowing(String otherId, String selfId, String token, int page) async {

		int _offset = page * 50;
		int _limit = _offset + 50;

		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-following?id=$otherId&offset=$_offset&limit=$_limit",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": selfId
			},
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {

			var data = respJson["result"];
			Map map = {
				"status": 200,
				"data": data
			};

			return json.encode(map);

		}else {
			var message = respJson["messages"];

			Map map = {
				"status": statusCode,
				"messages": message
			};

			return json.encode(map);
		}

	}

	static Future<String> loadMoreFollowers(String otherId, String selfId, String token, int page) async {

		int _offset = page * 50;
		int _limit = _offset + 50;

		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-follower?id=$otherId&offset=$_offset&limit=$_limit",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": selfId
			},
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {

			var data = respJson["result"];
			Map map = {
				"status": 200,
				"data": data
			};

			return json.encode(map);

		}else {
			var message = respJson["messages"];

			Map map = {
				"status": statusCode,
				"messages": message
			};

			return json.encode(map);
		}

	}

	static Future<Null> initSearchFollowing(BuildContext context, String otherId, String selfId, String token, String keyword) async {
		var store = StoreProvider.of<AppState>(context);

		// to show shimmer effect
		store.state.list_following.clear();

		int _offset = 0;
		int _limit = _offset + 50;

		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-following?id=$otherId&offset=$_offset&limit=$_limit&key=$keyword",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": selfId
			},
		);


		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(ReplaceSearchFollowingAction(data: data));
		}

	}

	static Future<Null> loadMoreSearchFollowing(BuildContext context, String otherId, String selfId, String token, int page, String keyword) async {
		var store = StoreProvider.of<AppState>(context);

		int _offset = page * 50;
		int _limit = _offset + 50;
		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-following?id=$otherId&offset=$_offset&limit=$_limit&key=$keyword",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": selfId
			},
		);


		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(AddMoreSearchFollowing(data: data));
		}

	}

	static Future<Null> initSearchFollowers(BuildContext context, String otherId, String selfId, String token, String keyword) async {
		var store = StoreProvider.of<AppState>(context);

		// to show shimmer effect
		store.state.list_followers.clear();

		int _offset = 0;
		int _limit = _offset + 50;
		var baseUrlAPI = globals.baseUrlApi;

		final response = await client.get(
			"$baseUrlAPI/v1/users/get-follower?id=$otherId&offset=$_offset&limit=$_limit&key=$keyword",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": selfId
			},
		);


		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(ReplaceSearchFollowersAction(data: data));
		}

	}

	static Future<Null> loadMoreSearchFollowers(BuildContext context, String otherId, String selfId, String token, int page, String keyword) async {
		var store = StoreProvider.of<AppState>(context);

		int _offset = page * 50;
		int _limit = _offset + 50;
		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-follower?id=$otherId&offset=$_offset&limit=$_limit&key=$keyword",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": selfId
			},
		);


		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(AddMoreSearchFollowers(data: data));
		}

	}

	static Future<Null> followUser(BuildContext context, int playerId, String token, int itemPosition, String followId) async {
		var store = StoreProvider.of<AppState>(context);

		store.dispatch(ReplaceFollowingStatus(position: itemPosition, status: true));

		Map params = {
			"token": token,
			"player_id": followId
		};

		var reqBody = json.encode(params);
		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.post(
			'$baseUrlAPI/v1/users/follow',
			headers: {
				"content-type": "application/json"
			},
			body: reqBody,
		);

		final statusCode = response.statusCode;

		if(statusCode == 200){
			store.dispatch(ReplaceFollowingStatus(position: itemPosition, status: true));
		}else{
			store.dispatch(ReplaceFollowingStatus(position: itemPosition, status: false));
		}

	}

	static Future<Null> getFollowingFollowers(BuildContext context, int player_id, String token) async {

		var store = StoreProvider.of<AppState>(context);
		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
			"$baseUrlAPI/v1/users/get-follower-following-combine?id=$player_id&key=&limit=50&offset=0",
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": "$player_id"
			}
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(ReplaceFollowingFollowers(data: data));
		}
	}

	static Future<Null> loadMoreFollowingFollowers(BuildContext context, int playerId, String token, int page) async {

		var store = StoreProvider.of<AppState>(context);

		int _offset = page * 50;
		int _limit = _offset + 50;
		var baseUrlAPI = globals.baseUrlApi;
		var url = "$baseUrlAPI/v1/users/get-follower-following-combine?id=$playerId&offset=$_offset&limit=$_limit";
		final response = await client.get(
				url,
				headers: {
					"content-type": "application/json",
					"token": token,
					"playerid": "$playerId"
				}
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(AddMoreFollowingFollowers(data: data));
		}

	}

	static Future<Null> searchFollowingFollowers(BuildContext context, int playerId, String token, String keyword) async {

		var store = StoreProvider.of<AppState>(context);

		int _offset = 0;
		int _limit = 50;

		// to show shimmer effect
		store.state.list_following_followers.clear();
		var baseUrlAPI = globals.baseUrlApi;
		final response = await client.get(
				"$baseUrlAPI/v1/users/get-follower-following-combine?id=$playerId&offset=$_offset&limit=$_limit&key=$keyword",
				headers: {
					"content-type": "application/json",
					"token": token,
					"playerid": "$playerId"
				}
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		print('ressssss: $statusCode ${respJson}');

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(ReplaceFollowingFollowers(data: data));
		}
	}

	static Future<Null> loadMoreSearchFollowingFollowers(BuildContext context, int playerId, String token, int page, String keyword) async {

		var store = StoreProvider.of<AppState>(context);

		int _offset = page * 50;
		int _limit = _offset + 50;
		var baseUrlAPI = globals.baseUrlApi;
		var url = "$baseUrlAPI/v1/users/get-follower-following-combine?id=$playerId&offset=$_offset&limit=$_limit&key=$keyword";
		final response = await client.get(
				url,
				headers: {
					"content-type": "application/json",
					"token": token,
					"playerid": "$playerId"
				}
		);

		final statusCode = response.statusCode;

		var respJson = json.decode(response.body);

		if (statusCode == 200) {
			var data = respJson["result"];
			store.dispatch(AddMoreFollowingFollowers(data: data));
		}

	}
}
