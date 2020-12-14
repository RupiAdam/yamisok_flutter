import 'package:http/http.dart' show Client;
import 'dart:io' show Platform;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

import 'package:yamisok/component/keyStore.dart';

Client client = Client();

class ApiChatting{

	static sendMetrics(String selfToken, String selfId, String targetId) async {

		Map<String, String> headers = {
			"content-type": "application/json",
			"token": selfToken,
			"playerid": selfId,
		};

		Map params = {
			"player_from": selfId,
			"player_to": targetId,
		};

		var bodyJson = json.encode(params);

		final response = await client.post(
			globals.URL_CHAT_METRICS,
			headers: headers,
			body: bodyJson,
		);

		final statusCode = response.statusCode;
		print('status code: $statusCode');

	}
}