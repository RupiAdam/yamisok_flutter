class Sample {
  final String title;
  final String thumbnailUrl;
  Sample._({this.title, this.thumbnailUrl});

  factory Sample.fromJson(Map<String, dynamic> json) {
    return new Sample._(
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}


// class Sample {
//   String name;
//   int age;
//   Sample({this.name, this.age});
//   @override
//   String toString() {
//     return 'Sample{name: $name, age: $age}';
//   }
//   factory Sample.fromJson(Map<String, dynamic> json) {
//     return Sample(
//       name: json["name"],
//       age: json["age"]
//     );
//   }
// }

// class Post {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;
 
//   Post({this.userId, this.id, this.title, this.body});
 
//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       userId: json['userId'] as int,
//       id: json['id'] as int,
//       title: json['title'] as String,
//       body: json['body'] as String,
//     );
//   }
// }