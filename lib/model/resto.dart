
import 'dart:convert';

class Resto {
    List<ListResto> listResto;

    Resto({
        this.listResto,
    });

    factory Resto.fromJson(Map<String, dynamic> json) => new Resto(
        listResto: new List<ListResto>.from(json["list_resto"].map((x) => ListResto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "list_resto": new List<dynamic>.from(listResto.map((x) => x.toJson())),
    };
}

class ListResto {
    String restoName;
    String restoMenu;
    String restoPhone;
    String restoDesc;
    String restoImgUrl;

    ListResto({
        this.restoName,
        this.restoMenu,
        this.restoPhone,
        this.restoDesc,
        this.restoImgUrl,
    });

    factory ListResto.fromJson(Map<String, dynamic> json) => new ListResto(
        restoName: json["resto_name"],
        restoMenu: json["resto_menu"],
        restoPhone: json["resto_phone"],
        restoDesc: json["resto_desc"],
        restoImgUrl: json["resto_img_url"],
    );

    Map<String, dynamic> toJson() => {
        "resto_name": restoName,
        "resto_menu": restoMenu,
        "resto_phone": restoPhone,
        "resto_desc": restoDesc,
        "resto_img_url": restoImgUrl,
    };
}
