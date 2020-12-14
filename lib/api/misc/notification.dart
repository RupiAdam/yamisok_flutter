import 'package:http/http.dart' show Client;
import 'dart:io' show Platform;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

import 'package:yamisok/component/keyStore.dart';

Client client = Client();

class ApiNotification{

	static sendNotification(String selfToken, String selfId, String targetId, String title, String message, String type) async {

		Map<String, String> headers = {
			"content-type": "application/json",
			"token": selfToken,
			"playerid": selfId,
		};

		Map params = {
			"player_id": targetId,
			"title": title,
			"body": message,
			"type": type,
		};

		var bodyJson = json.encode(params);

		final response = await client.post(
			globals.URL_SEND_NOTIFICATION,
			headers: headers,
			body: bodyJson,
		);

		final statusCode = response.statusCode;
		print('status code: $statusCode');

	}
}