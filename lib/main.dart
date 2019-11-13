import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'emoji.dart';
import 'repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emojipedia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String keyword = '';
  List<Emoji> emojiList = [];

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar.builder(
      itemCount: emojiList.length,
      itemBuilder: (BuildContext context, int index) {
        final emoji = emojiList[index];
        final character = emoji.character;

        return ListTile(
          leading: Text(
            character,
            style: TextStyle(fontSize: 32),
          ),
          title: Text(emoji.name),
          subtitle: Text(
            emoji.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: character));
            final snackBar = SnackBar(content: Text('Copied successfully: ${character}'));
            Scaffold.of(context).showSnackBar(snackBar);
          },
        );
      },
      trailing: IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          if (keyword.length < 2) {
            return;
          }

          final newEmojiList = await findAllEmojis(keyword);
          setState(() {
            emojiList = newEmojiList;
          });
        },
      ),
      onChanged: (String value) {
        keyword = value;
      },
      decoration: InputDecoration.collapsed(
        hintText: "Search emoji",
      ),
    );
  }
}
