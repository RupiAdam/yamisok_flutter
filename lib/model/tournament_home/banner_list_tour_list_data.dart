import 'banner_result.dart';

class listData_Banner {
  static var empty = listData_Banner(new List());

  final List<Banner_result> listBanner;   //Model banner_result.dart = banner_result

  listData_Banner(this.listBanner);       //constructor
  // factory listData_Banner.fromJosn(Map<String, dynamic> json) => new listData_Banner(
  //   listBanner : new List<banner_result>.from(json['result'].map((x) => banner_result.fromJson(x)).toList()
  //   ) ?? ''
  // );

  // listData_Banner.fromJson(Map<String, dynamic> json, this.listBanner) 
  //  => new listData_Banner(
  //   listBanner = new List<banner_result>.from(json['listBanner']
  //   .map((x) => banner_result.fromJson(x)))
  //   .toList() ?? ''
  // );

  listData_Banner.fromJson(Map<String, dynamic> json)
      : listBanner = (json['Banner'] as List)
            .map((i) => new Banner_result.fromJson(i))
            .toList() ?? '';

  // factory Result.fromJson(Map<String, dynamic> json) => new Result(
            // listCommunity: new List<ListCommunity>.from(json["listCommunity"]
            // .map((x) => ListCommunity.fromJson(x)))
            // .toList() ?? '',
  //   );


  // Map<String, dynamic> toJson() => {'result': listBanner};
  Map<String, dynamic> toJson() => {
        "listBanner": new List<dynamic>.from(listBanner.map((x) => x.toJson())),
    };

  @override
  String toString() => "$listBanner";
}
