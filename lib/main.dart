import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

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
  final emojiList = ['😁', '😪', '😰', '😯', '🌞', '😘', '😜', '🙂', '😚', '😀'];

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar.builder(
      itemCount: emojiList.length,
      itemBuilder: (BuildContext context, int index) {
        final emoji = emojiList[index];
        return ListTile(
          leading: Text(emoji),
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: emoji));
            final snackBar = SnackBar(content: Text('Copied successfully: ${emoji}'));
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
