import 'dart:convert';
// Community communityFromJson(String str) => Community.fromJson(json.decode(str));

// String communityToJson(Community data) => json.encode(data.toJson());
class Community {
    int status;
    String message;
    Result result;
    Result myCommunity;
    Result listCommunity;
    

    Community({
        this.status,
        this.message,
        this.result,
        this.myCommunity,
        this.listCommunity,
    });

    factory Community.fromJson(Map<String, dynamic> json) => new Community(
        status: json["status"],
        message: json["message"],
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
    };
}

class Result {
    List<int> myCommunity;
    List<ListCommunity> listCommunity;

    Result({
        this.myCommunity,
        this.listCommunity,
    });
    
    // factory Result.fromJson(Map<String,dynamic> json) => new Result(
    //   listCommunity: new List<ListCommunity>.from(json['ListCommunity'].map((x)
    //   => ListCommunity.fromJson(x)).toList() ?? ''
    //   )
    // );
    factory Result.fromJson(Map<String, dynamic> json) => 
    new Result(
        myCommunity: new List<int>.from(json["myCommunity"].map((x) => x)),
        listCommunity: new List<ListCommunity>.from(json["listCommunity"].map((x) => ListCommunity.fromJson(x))).toList() ?? '',
    );

    Map<String, dynamic> toJson() => {
        "myCommunity": new List<dynamic>.from(myCommunity.map((x) => x)),
        "listCommunity": new List<dynamic>.from(listCommunity.map((x) => x.toJson())),
    };
}


class ListCommunity {
    int id;
    String name;
    String avatarUrl;
    int totalMembers;
    int status;

    ListCommunity({
        this.id,
        this.name,
        this.avatarUrl,
        this.totalMembers,
        this.status
    });

    factory ListCommunity.fromJson(Map<String, dynamic> json) => new ListCommunity(
        id: json["id"],
        name: json["name"],
        avatarUrl: json["avatar_url"] ?? 'https://yamisok.com/assets/images/static/logo-yamisok.png',
        status : json["status"],
        totalMembers: json["total_members"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar_url": avatarUrl,
        "total_members": totalMembers,
    };
}
 
// class Community {

//   String name;
//   String nativeName;
//   String flag;
//   String capital;

//   Community({this.name, this.flag, this.capital,this.nativeName});

//   factory Community.fromJson(Map<String, dynamic> json) {
//     return new Community(
//       name: json['name'] as String,
//       nativeName: json['nativeName'] as String,
//       flag: json['flag'] as String,
//       capital: json['capital'] as String,
//     );
//   }
// }
