import 'dart:convert';





class Tesprofile {
    int status;
    String message;
    Result result;
    Result achievements;
    Result listMission;

    Tesprofile({
        this.status,
        this.message,
        this.result,
        this.achievements,
        this.listMission,
    });

    factory Tesprofile.fromJson(Map<String, dynamic> json) => new Tesprofile(
        status: json["status"],
        message: json["message"],
        result: Result.fromJson(json["result"]),
//        achievements: Result.fromJson(json["achievements"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
//        "raffle": raffle.toJson(),
    };
}

class Result {
    Detail detail;
//    Raffle raffle;
//    Achievement achievements;
    List<Achievement> achievements;
    List<ListMission> listMission;

    Result({
        this.detail,
        this.achievements,
        this.listMission,
    });

    factory Result.fromJson(Map<String, dynamic> json) => new Result(
        detail: Detail.fromJson(json["detail"]),
//        achievements: new Achievement.fromJson(json['achievements']),
//        List<Image> achievements: list.map((i) => Image.fromJson(i)).toList(),
        achievements: new List<Achievement>.from(json["achievements"].map((x) => Achievement.fromJson(x))).toList() ?? '',
        listMission: new List<ListMission>.from(json["listMission"].map((x) => ListMission.fromJson(x))).toList() ?? '',
    
    );


    Map<String, dynamic> toJson() => {
        "detail": detail.toJson(),
        "achievements": new List<dynamic>.from(achievements.map((x) => x.toJson())),
        "listMission": new List<dynamic>.from(listMission.map((x) => x.toJson())),
//        "achievements": achievements.toJson(),
    };
}

class Achievement {
    int playerId;
    int id;
    String title;
    String description;
    String avatarUrl;
    int type;
    String tier;
    String cookiesRewards;
    String expRewards;
    // BannedUntil createdAt;
    // BannedUntil updatedAt;

    Achievement({
        this.playerId,
        this.id,
        this.title,
        this.description,
        this.avatarUrl,
        this.type,
        this.tier,
        this.cookiesRewards,
        this.expRewards,
        // this.createdAt,
        // this.updatedAt,
    });

    factory Achievement.fromJson(Map<String, dynamic> json) {
        return Achievement(
            playerId: json["player_id"],
            id: json["id"],
            title: json["title"],
            description: json["description"],
            avatarUrl: json["avatar_url"],
            type: json["type"],
            tier: json["tier"],
            cookiesRewards: json["cookies_rewards"],
            expRewards: json["exp_rewards"],
        );
    }

//    factory Achievement.fromJson(Map<String, dynamic> json) => new Achievement(
//        playerId: json["player_id"],
//        id: json["id"],
//        title: json["title"],
//        description: json["description"],
//        avatarUrl: json["avatar_url"],
//        type: json["type"],
//        tier: json["tier"],
//        cookiesRewards: json["cookies_rewards"],
//        expRewards: json["exp_rewards"],
//        // createdAt: BannedUntil.fromJson(json["created_at"]),
//        // updatedAt: BannedUntil.fromJson(json["updated_at"]),
//    );

    Map<String, dynamic> toJson() => {
        "player_id": playerId,
        "id": id,
        "title": title,
        "description": description,
        "avatar_url": avatarUrl,
        "type": type,
        "tier": tier,
        "cookies_rewards": cookiesRewards,
        "exp_rewards": expRewards,
        // "created_at": createdAt.toJson(),
        // "updated_at": updatedAt.toJson(),
    };
}


class ListMission {
    String id;
    String title;
    int mission_event_id;
    int season_id;
    int exp;
    int cookies;
    String status;

    ListMission({
        this.id,
        this.title,
        this.mission_event_id,
        this.season_id,
        this.exp,
        this.cookies,
        this.status,
        // this.createdAt,
        // this.updatedAt,
    });

    factory ListMission.fromJson(Map<String, dynamic> json) => new ListMission(
        id: json["id"],
        title: json["title"],
        mission_event_id: json["mission_event_id"],
        season_id: json["season_id"],
        exp: json["exp"],
        cookies: json["cookies"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "mission_event_id": mission_event_id,
        "season_id": season_id,
        "exp": exp,
        "cookies": cookies,
        "status": status,
       
    };
}

class BannedUntil {
    BannedUntil();

    factory BannedUntil.fromJson(Map<String, dynamic> json) => new BannedUntil(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Detail {
    int id;
    String email;
    String username;
    String password;
    int status;
    String rememberToken;
    String name;
    String avatarUrl;
    DateTime registrationDate;
    DateTime lastLogin;
    int coin;
    int country;
    String shortBio;
    // BannedUntil platform;
    // BannedUntil game;
    int flags;
    int level;
    int exp;
    int totalExp;
    int nextLevelExp;
    String avatarUrlSm;
    String coverUrl;
    String coverUrlSm;
    // BannedUntil verificationCode;
    int verified;
    int verifiedPlayer;
    int isSubscribe;
    // BannedUntil isSubscriptionNotified;
    // BannedUntil subscribeExpiryDate;
    int playerStr;
    String lastIpAddress;
    int cookies;
    // BannedUntil bannedUntil;
    int followers;
    int followings;
    int hiddenEmail;
    int hiddenDateOfBirth;
    int hiddenPhone;
    int isWmCompleted;
    int isBetaTester;
    int isEventStatus;
    bool hasFollowed;
    bool isFollowed;

    Detail({
        this.id,
        this.email,
        this.username,
        this.password,
        this.status,
        this.rememberToken,
        this.name,
        this.avatarUrl,
        this.registrationDate,
        this.lastLogin,
        this.coin,
        this.country,
        this.shortBio,
        // this.platform,
        // this.game,
        this.flags,
        this.level,
        this.exp,
        this.totalExp,
        this.nextLevelExp,
        this.avatarUrlSm,
        this.coverUrl,
        this.coverUrlSm,
        // this.verificationCode,
        this.verified,
        this.verifiedPlayer,
        this.isSubscribe,
        // this.isSubscriptionNotified,
        // this.subscribeExpiryDate,
        this.playerStr,
        this.lastIpAddress,
        this.cookies,
        // this.bannedUntil,
        this.followers,
        this.followings,
        this.hiddenEmail,
        this.hiddenDateOfBirth,
        this.hiddenPhone,
        this.isWmCompleted,
        this.isBetaTester,
        this.isEventStatus,
        this.hasFollowed,
        this.isFollowed,
    });

    factory Detail.fromJson(Map<String, dynamic> json) => new Detail(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        status: json["status"],
        rememberToken: json["remember_token"],
        name: json["name"],
        avatarUrl: json["avatar_url"],
        registrationDate: DateTime.parse(json["registration_date"]),
        lastLogin: DateTime.parse(json["last_login"]),
        coin: json["coin"],
        country: json["country"],
        shortBio: json["short_bio"],
        // platform: BannedUntil.fromJson(json["platform"]),
        // game: BannedUntil.fromJson(json["game"]),
        flags: json["flags"],
        level: json["level"],
        exp: json["exp"],
        totalExp: json["total_exp"],
        nextLevelExp: json["next_level_exp"],
        avatarUrlSm: json["avatar_url_sm"],
        coverUrl: json["cover_url"],
        coverUrlSm: json["cover_url_sm"],
        // verificationCode: BannedUntil.fromJson(json["verification_code"]),
        verified: json["verified"],
        verifiedPlayer: json["verified_player"],
        isSubscribe: json["is_subscribe"],
        // isSubscriptionNotified: BannedUntil.fromJson(json["is_subscription_notified"]),
        // subscribeExpiryDate: BannedUntil.fromJson(json["subscribe_expiry_date"]),
        playerStr: json["player_str"],
        lastIpAddress: json["last_ip_address"],
        cookies: json["cookies"],
        // bannedUntil: BannedUntil.fromJson(json["banned_until"]),
        followers: json["followers"],
        followings: json["followings"],
        hiddenEmail: json["hidden_email"],
        hiddenDateOfBirth: json["hidden_date_of_birth"],
        hiddenPhone: json["hidden_phone"],
        isWmCompleted: json["is_wm_completed"],
        isBetaTester: json["is_beta_tester"],
        isEventStatus: json["is_event_status"],
        hasFollowed: json["hasFollowed"],
        isFollowed: json["isFollowed"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "status": status,
        "remember_token": rememberToken,
        "name": name,
        "avatar_url": avatarUrl,
        "registration_date": registrationDate.toIso8601String(),
        "last_login": lastLogin.toIso8601String(),
        "coin": coin,
        "country": country,
        "short_bio": shortBio,
        // "platform": platform.toJson(),
        // "game": game.toJson(),
        "flags": flags,
        "level": level,
        "exp": exp,
        "total_exp": totalExp,
        "next_level_exp": nextLevelExp,
        "avatar_url_sm": avatarUrlSm,
        "cover_url": coverUrl,
        "cover_url_sm": coverUrlSm,
        // "verification_code": verificationCode.toJson(),
        "verified": verified,
        "verified_player": verifiedPlayer,
        "is_subscribe": isSubscribe,
        // "is_subscription_notified": isSubscriptionNotified.toJson(),
        // "subscribe_expiry_date": subscribeExpiryDate.toJson(),
        "player_str": playerStr,
        "last_ip_address": lastIpAddress,
        "cookies": cookies,
        // "banned_until": bannedUntil.toJson(),
        "followers": followers,
        "followings": followings,
        "hidden_email": hiddenEmail,
        "hidden_date_of_birth": hiddenDateOfBirth,
        "hidden_phone": hiddenPhone,
        "is_wm_completed": isWmCompleted,
        "is_beta_tester": isBetaTester,
        "is_event_status": isEventStatus,
        "hasFollowed": hasFollowed,
        "isFollowed": isFollowed,
    };
}
