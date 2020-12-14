import 'package:flutter/material.dart';
import 'package:yamisok/page/utilities/color.dart';

class ChatBubble extends StatelessWidget {
	ChatBubble({this.message, this.time, this.delivered, this.isMe});

	final String message, time;
	final delivered, isMe;


	// 464a4d
	@override
	Widget build(BuildContext context) {
		final bg = !isMe ?  badgeBackgroundColor : Color(0xFF464a4d);
		final align = !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
		final icon = delivered ? Icons.done_all : Icons.done;
		final radius = !isMe ?
		BorderRadius.only(
			topRight: Radius.circular(5.0),
			bottomLeft: Radius.circular(10.0),
			bottomRight: Radius.circular(5.0),
		):
		BorderRadius.only(
			topLeft: Radius.circular(5.0),
			bottomLeft: Radius.circular(5.0),
			bottomRight: Radius.circular(10.0),
		);
		final margin = !isMe ?
		EdgeInsets.only(
			left: 16, right: 50, bottom: 6, top: 10
		) :
		EdgeInsets.only(
			right: 16, left: 50, bottom: 6, top: 10
		);


		return Column(
			crossAxisAlignment: align,
			children: <Widget>[
				Container(
					margin: margin,
					padding: const EdgeInsets.all(8.0),
					decoration: BoxDecoration(
						boxShadow: [
							BoxShadow(
									blurRadius: .5,
									spreadRadius: 1.0,
									color: Colors.black.withOpacity(.12)
							)
						],
						color: bg,
						borderRadius: radius,
					),
					child: Stack(
						children: <Widget>[
							Padding(
								padding: EdgeInsets.only(right: 48.0),
								child: Text(
									message,
									style: TextStyle(
											color: Colors.white,
											fontSize: 16,
											fontFamily: 'Proxima'
									),
								),
							),
							Positioned(
								bottom: 0.0,
								right: 0.0,
								child: Row(
									children: <Widget>[
										Text(time,
												style: TextStyle(
													color: textGrey,
													fontSize: 10.0,
												)),
										SizedBox(width: 3.0),
//										Icon(
//											icon,
//											size: 12.0,
//											color: accent,
//										)
									],
								),
							)
						],
					),
				)
			],
		);
	}
}