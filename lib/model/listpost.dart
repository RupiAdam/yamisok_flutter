import 'package:flutter/material.dart';
import 'package:yamisok/model/Sample.dart';
 
class ListViewPosts extends StatelessWidget {
  final List<Sample> posts;
 
  ListViewPosts({Key key, this.posts}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${posts[position].title}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${posts[position].title}',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 35.0,
                        child: Text(
                          'User ${posts[position].title}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () => _onTapItem(context, posts[position]),
                ),
              ],
            );
          }),
    );
  }
 
  void _onTapItem(BuildContext context, Sample post) {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text(post.title.toString() + ' - ' + post.title)));
  }
}