import 'package:http/http.dart' show Client;
import 'dart:async';
import 'dart:convert';

import 'package:yamisok/component/globals.dart';

Client client = Client();

class ApiServiceProfilePicture{

	static Future<String> saveProfilePicture(String username, int playerId, String token, String url, String status) async {

		Map params = {
			"image": url,
		};

		var reqBody = json.encode(params);

		final response = await client.post('$urlUpdateProfilePicture',
			headers: {
				"content-type": "application/json",
				"token": token,
				"playerid": "$playerId"
			},
			body: reqBody
		);

		final statusCode = response.statusCode;

		if(statusCode == 200){
			Map map = {
				"status": 200,
			};
			return json.encode(map);
		}else{
			var respJson = json.decode(response.body);
			var message = respJson["messages"];

			Map map = {
				"status": statusCode,
				"messages": message
			};

			return json.encode(map);
		}

	}

	static Future<String> updateStatus(String username, int playerId, String token, String status) async {

		Map params = {
			"short_bio": status,
			"token": token
		};

		var reqBody = json.encode(params);

		final response = await client.put('$urlUpdateStatus/$username',
				headers: {
					"content-type": "application/json",
				},
				body: reqBody
		);

		final statusCode = response.statusCode;

		if(statusCode == 200){
			Map map = {
				"status": 200,
			};
			return json.encode(map);
		}else{
			var respJson = json.decode(response.body);
			var message = respJson["messages"];

			Map map = {
				"status": statusCode,
				"message": message
			};

			return json.encode(map);
		}

	}
}