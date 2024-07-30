import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatListScreen(),
    );
  }
}

class ChatListScreen extends StatelessWidget {
  final List<User> users = [
    User(name: 'Alice', profileImageUrl: 'https://via.placeholder.com/150'),
    User(name: 'Bob', profileImageUrl: 'https://via.placeholder.com/150'),
    User(name: 'Charlie', profileImageUrl: 'https://via.placeholder.com/150'),
    User(name: 'David', profileImageUrl: 'https://via.placeholder.com/150'),
    User(name: 'Eve', profileImageUrl: 'https://via.placeholder.com/150'),
    User(name: 'Frank', profileImageUrl: 'https://via.placeholder.com/150'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle sign out action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ); // This closes the app for simplicity
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings action
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                // Handle profile action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout action
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          User user = users[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(user: user),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user.profileImageUrl),
                  ),
                  SizedBox(width: 16),
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [
    Message(sender: 'Alice', text: 'Hi Bob!'),
    Message(sender: 'Bob', text: 'Hey Alice! How are you?'),
  ];

  TextEditingController messageController = TextEditingController();

  void _sendMessage(String messageText) {
    setState(() {
      messages.add(Message(sender: widget.user.name, text: messageText));
    });
    messageController.clear();
  }

  void _editMessage(int index, String newText) {
    setState(() {
      messages[index].text = newText;
    });
  }

  void _deleteMessage(int index) {
    setState(() {
      messages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.profileImageUrl),
            ),
            SizedBox(width: 8),
            Text(widget.user.name),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle sign out action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Message message = messages[index];
                bool isMe = message.sender == widget.user.name;
                return ChatBubble(
                  message: message.text,
                  isSender: isMe,
                  onEdit: () {
                    _editMessage(index, "Edited message");
                  },
                  onDelete: () {
                    _deleteMessage(index);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        _sendMessage(text);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      _sendMessage(messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ChatBubble({required this.isSender, required this.message, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Edit or Delete Message'),
            actions: <Widget>[
              TextButton(
                child: Text('Edit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onEdit();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSender ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class Message {
  String sender;
  String text;

  Message({required this.sender, required this.text});
}

class User {
  final String name;
  final String profileImageUrl;

  User({required this.name, required this.profileImageUrl});
}
