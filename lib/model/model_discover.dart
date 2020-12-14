// To parse this JSON data, do
//
//     final feedsModel = feedsModelFromJson(jsonString);
// To parse this JSON data, do
//
//     final feedsModel = feedsModelFromJson(jsonString);

import 'dart:convert';

// DiscoverModel discoverModelFromJson(String str) => DiscoverModel.fromJson(json.decode(str));

// String discoverModelToJson(DiscoverModel data) => json.encode(data.toJson());

class DiscoverModel {
    String status;
    List<Result> result;

    DiscoverModel({
        this.status,
        this.result,
    });

    factory DiscoverModel.fromJson(Map<String, dynamic> json) => new DiscoverModel(
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
    var images;
    var videos;
    

    Result({
        this.postId,
        this.content,
        this.images,
        this.videos,
    });

    factory Result.fromJson(Map<String, dynamic> json) => new Result(
        postId: json["post_id"],
        content: json["content"],
        images: json["images"],
        videos: json["videos"]
    );

    Map<String, dynamic> toJson() => {
        "post_id": postId,
        "content": content,
        "images": images,
        "videos": videos,
        
    };
}


