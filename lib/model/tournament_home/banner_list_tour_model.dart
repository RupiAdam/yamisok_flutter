import 'banner_list_tour_list_data.dart';

class Banner_list_tour {
  int status;
  String message;
  listData_Banner result; 

  Banner_list_tour({
      this.status,
      this.message,
      this.result
  });
  

  factory Banner_list_tour.fromJson(Map<String, dynamic> json) => new Banner_list_tour(
      status: json["status"],
      message: json["messages"],
      result: listData_Banner.fromJson(json["result"]) ?? ''
  );

  Map<String, dynamic> toJson() => {
      "status": status,
      "message": message,
      "result": result.toJson(),
  };
}











