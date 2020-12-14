import 'package:http/http.dart' show Client;
import 'dart:io' show Platform;
import 'package:yamisok/component/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

import 'package:yamisok/component/keyStore.dart';

Client client = Client();

class ApiServiceFirebase{

	static saveToken(token,deviceId,osName,typeHp,merkHp) async {

		Map params = {
			"token": token,
			"agent": Platform.isAndroid ? 'Android' : 'iOS',
      "device_id":deviceId,
      "os_name":osName,
      "type_hp":typeHp,
      "merk_hp":merkHp


		};

		var bodyJson = json.encode(params);

		keyStore.getToken().then((userToken) {

			keyStore.getPlayerId().then((playerId) async {

				final response = await client.post(
					globals.URL_SAVE_TOKEN_FIREBASE,
					headers: {
						"content-type": "application/json",
						"token": userToken,
						"playerid": "$playerId",
					},
					body: bodyJson,
				);

				final statusCode = response.statusCode;
				print('status code token firebase: $statusCode token: $token');

			});

		});

	}
}