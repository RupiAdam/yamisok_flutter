import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseUtil {
	DatabaseReference _userRef;
	DatabaseReference _personalChatRef;
	FirebaseDatabase database = FirebaseDatabase();
	DatabaseError error;

	static final FirebaseDatabaseUtil _instance = FirebaseDatabaseUtil.internal();

	FirebaseDatabaseUtil.internal();

	factory FirebaseDatabaseUtil() {
		return _instance;
	}

	void initState() {

		database.setPersistenceEnabled(true);
//		database.setPersistenceCacheSizeBytes(10000000);

		_userRef = database.reference().child('user');
		_personalChatRef = database.reference().child("chat/new/personal");

	}

	DatabaseError getError() {
		return error;
	}

	DatabaseReference getUser() {
		return _userRef;
	}

	DatabaseReference getPersonalChat(){
		return _personalChatRef;
	}

	DatabaseReference getPersonalChatHistory(String userid){
		var res = 'players/$userid/chat_histories';
		return database.reference().child(res);
	}

	DatabaseReference getTeamChatHistory(String userid){
		return database.reference().child('players/$userid/chat_team_histories');
	}

	DatabaseReference getPersonalChatDetail(String roomId){
		return database.reference().child("chat/new/personal/$roomId/messages");
	}

	DatabaseReference getTeamChatDetail(String roomId){
		return database.reference().child("chat/new/team/$roomId/messages");
	}

	DatabaseReference getPersonalChatHistoryDetail(String userId, String roomId){
		return database.reference().child('players/$userId/chat_histories/$roomId');
	}

	DatabaseReference getTeamChatHistoryDetail(String userId, String roomId){
		return database.reference().child('players/$userId/chat_team_histories/$roomId');
	}

	DatabaseReference getOnlineStatus(String playerId){
		return database.reference().child('onlinestat/players/online/$playerId');
	}

	DatabaseReference getIdleStatus(String playerId){
		return database.reference().child('onlinestat/players/idle/$playerId');
	}

	DatabaseReference getCounterChatPersonal(String playerId, String roomId){
		return database.reference().child('players/$playerId/chat_histories/$roomId/unread_message');
	}

	DatabaseReference getCounterChatTeam(String playerId, String teamId){
		return database.reference().child('players/$playerId/chat_histories/$teamId/unread_message');
	}

	DatabaseReference getStoragePersonalDetail(String playerId, String roomId){
		return database.reference().child('chat/storage/$playerId/personal/$roomId');
	}

	DatabaseReference getStorageTeamDetail(String playerId, String teamId){
		return database.reference().child('chat/storage/$playerId/team/$teamId');
	}

	DatabaseReference getUpcomingMatch(String player_id){
		var res = 'upcomingmatchs/$player_id';
		return database.reference().child(res);
	}

	void removeUpcomingMatch(String player_id, String tournamentId, String matchId){
		var res = 'upcomingmatchs/$player_id/$tournamentId-$matchId';

		database.reference().child(res).set(null);
	}

	void dispose() {
	}
}
