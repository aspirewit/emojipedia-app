import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'emoji.dart';

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
  final emojiList = [
    Emoji(
      character: '😀',
      name: 'Grinning Face',
      description: 'A yellow face with simple, open eyes and a broad, open smile, showing upper teeth and tongue on some platforms. Often conveys general pleasure and good cheer or humor.',
    ),
    Emoji(
      character: '🙈',
      name: 'See-No-Evil Monkey',
      description: 'The see no evil monkey, called Mizaru (Japanese for “see not”), one of the Three Wise Monkeys. Depicted as the brown 🐵 Monkey Face with tan or pinkish hands covering its eyes.',
    ),
    Emoji(
      character: '🍇',
      name: 'Grapes',
      description: 'A grape bunch, as cut from the vine and used to make wine. Depicted as red (purple-colored) grapes.',
    ),
  ];

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
      onChanged: (String value) {},
      decoration: InputDecoration.collapsed(
        hintText: "Search emoji",
      ),
    );
  }
}
