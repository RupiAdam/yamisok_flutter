// To parse this JSON data, do
//
//     final feedsModel = feedsModelFromJson(jsonString);
// To parse this JSON data, do
//
//     final feedsModel = feedsModelFromJson(jsonString);

import 'dart:convert';

// FeedsModel feedsModelFromJson(String str) => FeedsModel.fromJson(json.decode(str));

// String feedsModelToJson(FeedsModel data) => json.encode(data.toJson());

class FeedsModel {
    String status;
    List<Result> result;

    FeedsModel({
        this.status,
        this.result,
    });

    factory FeedsModel.fromJson(Map<String, dynamic> json) => new FeedsModel(
        status: json["status"],
        result: new List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": new List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    int postId;
    String content;
    DateTime createdAt;
    int likeTotal;
    int playerId;
    String username;
    String name;
    String avatarUrl;
    String avatarUrlSm;
    int communityTotalMembers;
    bool isPostPlayer;

    Result({
        this.postId,
        this.content,
        this.createdAt,
        this.likeTotal,
        this.playerId,
        this.username,
        this.name,
        this.avatarUrl,
        this.avatarUrlSm,
        this.communityTotalMembers,
        this.isPostPlayer,
    });

    factory Result.fromJson(Map<String, dynamic> json) => new Result(
        postId: json["post_id"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        likeTotal: json["like_total"],
        playerId: json["player_id"],
        username: json["username"],
        name: json["name"],
        avatarUrl: json["avatar_url"],
        avatarUrlSm: json["avatar_url_sm"],
        communityTotalMembers: json["community_total_members"],
        isPostPlayer: json["is_post_player"],
    );

    Map<String, dynamic> toJson() => {
        "post_id": postId,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "like_total": likeTotal,
        "player_id": playerId,
        "username": username,
        "name": name,
        "avatar_url": avatarUrl,
        "avatar_url_sm": avatarUrlSm,
        "community_total_members": communityTotalMembers,
        "is_post_player": isPostPlayer,
    };
}



//VERSI FULL
// import 'dart:convert';

// FeedsModel feedsModelFromJson(String str) => FeedsModel.fromJson(json.decode(str));

// String feedsModelToJson(FeedsModel data) => json.encode(data.toJson());

// class FeedsModel {
//     String status;
//     List<Result> result;

//     FeedsModel({
//         this.status,
//         this.result,
//     });

//     factory FeedsModel.fromJson(Map<String, dynamic> json) => new FeedsModel(
//         status: json["status"],
//         result: new List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "result": new List<dynamic>.from(result.map((x) => x.toJson())),
//     };
// }

// class Result {
//     int postId;
//     CommunityUrl sharedPostId;
//     String content;
//     DateTime createdAt;
//     CommunityUrl postImages;
//     CommunityUrl postVideos;
//     int likeTotal;
//     int playerId;
//     String username;
//     String name;
//     String avatarUrl;
//     String avatarUrlSm;
//     CommunityUrl communityUrl;
//     int communityTotalMembers;
//     bool isPostPlayer;
//     CommunityUrl parentPostId;
//     CommunityUrl parentPostContent;
//     CommunityUrl parentPostCreatedAt;
//     CommunityUrl parentPostImages;
//     CommunityUrl parentPostVideos;
//     CommunityUrl parentPostLikeTotal;
//     CommunityUrl parentPlayerId;
//     CommunityUrl parentPlayerUsername;
//     CommunityUrl parentPlayerName;
//     CommunityUrl parentPlayerAvatarUrl;
//     CommunityUrl parentPlayerAvatarUrlSm;
//     CommunityUrl parentCommunityUrl;
//     int parentCommunityTotalMembers;
//     bool isParentPostPlayer;
//     List<Liker> likers;
//     int commentTotal;
//     var comments;

//     Result({
//         this.postId,
//         this.sharedPostId,
//         this.content,
//         this.createdAt,
//         this.postImages,
//         this.postVideos,
//         this.likeTotal,
//         this.playerId,
//         this.username,
//         this.name,
//         this.avatarUrl,
//         this.avatarUrlSm,
//         this.communityUrl,
//         this.communityTotalMembers,
//         this.isPostPlayer,
//         this.parentPostId,
//         this.parentPostContent,
//         this.parentPostCreatedAt,
//         this.parentPostImages,
//         this.parentPostVideos,
//         this.parentPostLikeTotal,
//         this.parentPlayerId,
//         this.parentPlayerUsername,
//         this.parentPlayerName,
//         this.parentPlayerAvatarUrl,
//         this.parentPlayerAvatarUrlSm,
//         this.parentCommunityUrl,
//         this.parentCommunityTotalMembers,
//         this.isParentPostPlayer,
//         this.likers,
//         this.commentTotal,
//         this.comments,
//     });

//     factory Result.fromJson(Map<String, dynamic> json) => new Result(
//         postId: json["post_id"],
//         sharedPostId: CommunityUrl.fromJson(json["shared_post_id"]),
//         content: json["content"],
//         createdAt: DateTime.parse(json["created_at"]),
//         postImages: CommunityUrl.fromJson(json["post_images"]),
//         postVideos: CommunityUrl.fromJson(json["post_videos"]),
//         likeTotal: json["like_total"],
//         playerId: json["player_id"],
//         username: json["username"],
//         name: json["name"],
//         avatarUrl: json["avatar_url"],
//         avatarUrlSm: json["avatar_url_sm"],
//         communityUrl: CommunityUrl.fromJson(json["community_url"]),
//         communityTotalMembers: json["community_total_members"],
//         isPostPlayer: json["is_post_player"],
//         parentPostId: CommunityUrl.fromJson(json["parent_post_id"]),
//         parentPostContent: CommunityUrl.fromJson(json["parent_post_content"]),
//         parentPostCreatedAt: CommunityUrl.fromJson(json["parent_post_created_at"]),
//         parentPostImages: CommunityUrl.fromJson(json["parent_post_images"]),
//         parentPostVideos: CommunityUrl.fromJson(json["parent_post_videos"]),
//         parentPostLikeTotal: CommunityUrl.fromJson(json["parent_post_like_total"]),
//         parentPlayerId: CommunityUrl.fromJson(json["parent_player_id"]),
//         parentPlayerUsername: CommunityUrl.fromJson(json["parent_player_username"]),
//         parentPlayerName: CommunityUrl.fromJson(json["parent_player_name"]),
//         parentPlayerAvatarUrl: CommunityUrl.fromJson(json["parent_player_avatar_url"]),
//         parentPlayerAvatarUrlSm: CommunityUrl.fromJson(json["parent_player_avatar_url_sm"]),
//         parentCommunityUrl: CommunityUrl.fromJson(json["parent_community_url"]),
//         parentCommunityTotalMembers: json["parent_community_total_members"],
//         isParentPostPlayer: json["is_parent_post_player"],
//         likers: new List<Liker>.from(json["likers"].map((x) => Liker.fromJson(x))),
//         commentTotal: json["comment_total"],
//         comments: json["comments"],
//     );

//     Map<String, dynamic> toJson() => {
//         "post_id": postId,
//         "shared_post_id": sharedPostId.toJson(),
//         "content": content,
//         "created_at": createdAt.toIso8601String(),
//         "post_images": postImages.toJson(),
//         "post_videos": postVideos.toJson(),
//         "like_total": likeTotal,
//         "player_id": playerId,
//         "username": username,
//         "name": name,
//         "avatar_url": avatarUrl,
//         "avatar_url_sm": avatarUrlSm,
//         "community_url": communityUrl.toJson(),
//         "community_total_members": communityTotalMembers,
//         "is_post_player": isPostPlayer,
//         "parent_post_id": parentPostId.toJson(),
//         "parent_post_content": parentPostContent.toJson(),
//         "parent_post_created_at": parentPostCreatedAt.toJson(),
//         "parent_post_images": parentPostImages.toJson(),
//         "parent_post_videos": parentPostVideos.toJson(),
//         "parent_post_like_total": parentPostLikeTotal.toJson(),
//         "parent_player_id": parentPlayerId.toJson(),
//         "parent_player_username": parentPlayerUsername.toJson(),
//         "parent_player_name": parentPlayerName.toJson(),
//         "parent_player_avatar_url": parentPlayerAvatarUrl.toJson(),
//         "parent_player_avatar_url_sm": parentPlayerAvatarUrlSm.toJson(),
//         "parent_community_url": parentCommunityUrl.toJson(),
//         "parent_community_total_members": parentCommunityTotalMembers,
//         "is_parent_post_player": isParentPostPlayer,
//         "likers": new List<dynamic>.from(likers.map((x) => x.toJson())),
//         "comment_total": commentTotal,
//         "comments": comments,
//     };
// }

// class CommunityUrl {
//     CommunityUrl();

//     factory CommunityUrl.fromJson(Map<String, dynamic> json) => new CommunityUrl(
//     );

//     Map<String, dynamic> toJson() => {
//     };
// }

// class Liker {
//     int postId;
//     int playerId;
//     String username;
//     String name;
//     String avatarUrl;
//     String avatarUrlSm;

//     Liker({
//         this.postId,
//         this.playerId,
//         this.username,
//         this.name,
//         this.avatarUrl,
//         this.avatarUrlSm,
//     });

//     factory Liker.fromJson(Map<String, dynamic> json) => new Liker(
//         postId: json["post_id"],
//         playerId: json["player_id"],
//         username: json["username"],
//         name: json["name"],
//         avatarUrl: json["avatar_url"],
//         avatarUrlSm: json["avatar_url_sm"],
//     );

//     Map<String, dynamic> toJson() => {
//         "post_id": postId,
//         "player_id": playerId,
//         "username": username,
//         "name": name,
//         "avatar_url": avatarUrl,
//         "avatar_url_sm": avatarUrlSm,
//     };
// }
