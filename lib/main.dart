import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = StreamChatClient(
    's7yt6hcn3q85',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(id: 'bloodor'),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYmxvb2RvciJ9.FizDla_lgVAJ_iBvywogTIJmiPbiTltOfTw_iQFHltI',
  );

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {

    final themeData = ThemeData(primarySwatch: Colors.green);
    final defaultTheme = StreamChatThemeData.fromTheme(themeData);
    final colorTheme = defaultTheme.colorTheme;
    final customTheme = defaultTheme.merge(StreamChatThemeData(
      channelPreviewTheme: StreamChannelPreviewThemeData(
        avatarTheme: StreamAvatarThemeData(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      otherMessageTheme: StreamMessageThemeData(
        messageBackgroundColor: colorTheme.textHighEmphasis,
        messageTextStyle: TextStyle(
          color: colorTheme.barsBg,
        ),
        avatarTheme: StreamAvatarThemeData(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ));

    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => StreamChat(
        streamChatThemeData: customTheme,
        client: client,
        child: child,
      ),
      home: const ChannelListPage(),
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.or([
      Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
      Filter.equal('type', 'messaging'),
    ]),
    channelStateSort: const [SortOption('last_message_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}