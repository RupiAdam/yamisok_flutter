class Banner_result {
  String id;
  String name;
  String game_cover_img;
  String game_avatar_url;

  Banner_result(
    this.id,
    this.name,
    this.game_cover_img,
    this.game_avatar_url
  );


  Banner_result.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        game_cover_img = json['game_cover_img']  ?? 'https://yamisok.com/assets/images/static/logo-yamisok.png',
        game_avatar_url = json['game_avatar_url']  ?? 'https://yamisok.com/assets/images/static/logo-yamisok.png';

  Map<String, dynamic> toJson() => {
    'id': id, 
    'name': name,
    'game_cover_img': game_cover_img,
    'game_avatar_url': game_avatar_url};
}
