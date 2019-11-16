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
  final emojiRepository = EmojiRepository();
  final controller = TextEditingController();
  final focus = FocusNode();

  bool clearingButtonVisible = false;
  List<Emoji> emojiList = [];

  void initState() {
    emojiRepository.open().then((_) {});

    controller.addListener(() {
      final text = controller.text.toLowerCase();
      setState(() {
        clearingButtonVisible = text.length > 0;
      });
    });

    super.initState();
  }

  void dispose() {
    controller.dispose();
    emojiRepository.close().then((_) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar.builder(
      title: TextFormField(
        controller: controller,
        focusNode: focus,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration.collapsed(
          hintText: 'Search emoji',
        ),
        autofocus: true,
        onFieldSubmitted: (value) async {
          final text = controller.text.toLowerCase();
          if (text.length < 2) {
            return;
          }

          final newEmojiList = await emojiRepository.findAllEmojis(text);
          setState(() {
            emojiList = newEmojiList;
          });
        },
      ),
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
            final snackBar = SnackBar(
              content: Text('Copied successfully: $character'),
              duration: Duration(seconds: 1),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
        );
      },
      trailing: clearingButtonVisible ? IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          controller.clear();
          FocusScope.of(context).requestFocus(focus);

          setState(() {
            emojiList = [];
          });
        },
      ) : null,
    );
  }
}
