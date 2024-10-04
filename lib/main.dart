import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'auth_service.dart';
import 'login_register_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService(baseUrl: 'localhost:3000');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: LoginRegisterScreen(
        authService: authService,
        onAuthenticated: (userId, streamToken) async {
          final client = StreamChatClient(
            's7yt6hcn3q85',
            logLevel: Level.INFO,
          );

          await client.connectUser(
            User(id: userId),
            streamToken,
          );

          runApp(
            MaterialApp(
              theme: ThemeData(primarySwatch: Colors.green),
              debugShowCheckedModeBanner: false,
              builder: (context, child) => StreamChat(
                client: client,
                child: child,
              ),
              home: const ChannelListPage(),
            ),
          );
        },
      ),
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

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => LoginRegisterScreen(authService: AuthService(baseUrl: 'http://localhost:3000'),
              onAuthenticated: (userId, streamToken) async {
            final client = StreamChatClient(
              's7yt6hcn3q85',
              logLevel: Level.INFO,
            );

            await client.connectUser(
              User(id: userId),
              streamToken,
            );
            runApp(
              MaterialApp(
                theme: ThemeData(primarySwatch: Colors.green),
                debugShowCheckedModeBanner: false,
                builder: (context, child) => StreamChat(
                  client: client,
                  child: child,
                ),
                home: const ChannelListPage(),
              ),
            );
          }))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
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