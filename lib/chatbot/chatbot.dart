// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({Key? key}) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final _openAI = OpenAI.instance.build(
//     token: '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',
//     baseOption: HttpSetup(
//       receiveTimeout: const Duration(
//         seconds: 5,
//       ),
//     ),
//     enableLog: true,
//   );

//   final ChatUser _currentUser = ChatUser(id: '1', firstName: 'Umashankar', lastName: 'Mishra');
//   final ChatUser _gptChatUser = ChatUser(id: '2', firstName: 'Secure', lastName: 'India');

//   List<ChatMessage> _messages = <ChatMessage>[];
//   List<ChatUser> _typingUsers = <ChatUser>[];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(
//           0,
//           166,
//           126,
//           1,
//         ),
//         title: const Text(
//           'Secure India Bot',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: DashChat(
//         currentUser: _currentUser,
//         typingUsers: _typingUsers,
//         messageOptions: const MessageOptions(
//           currentUserContainerColor: Colors.black,
//           containerColor: Color.fromRGBO(
//             0,
//             166,
//             126,
//             1,
//           ),
//           textColor: Colors.white,
//         ),
//         onSend: getChatResponse,
//         messages: _messages,
//       ),
//     );
//   }

//   void getChatResponse(ChatMessage m) async {
//     setState(() {
//       _messages.insert(0, m);
//       _typingUsers.add(_gptChatUser);
//     });

//     List<Map<String, dynamic>> messagesHistory = _messages.reversed.map((m) {
//       if (m.user == _currentUser) {
//         return {
//           'role': Role.user.toString(), // Convert Role enum to string
//           'content': m.text
//         };
//       } else {
//         return {
//           'role': Role.assistant.toString(), // Convert Role enum to string
//           'content': m.text
//         };
//       }
//     }).toList();

//     final request = ChatCompleteText(
//       model: GptTurbo0301ChatModel(),
//       messages: messagesHistory,
//       maxToken: 200,
//     );

//     final response = await _openAI.onChatCompletion(request: request);

//     for (var element in response!.choices) {
//       if (element.message != null) {
//         setState(() {
//           _messages.insert(
//             0,
//             ChatMessage(
//               user: _gptChatUser,
//               createdAt: DateTime.now(),
//               text: element.message!.content,
//             ),
//           );
//         });
//       }
//     }

//     setState(() {
//       _typingUsers.remove(_gptChatUser);
//     });
//   }
// }
// import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(child: Text("hello"),),
//     );
//   }
// }

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
// import 'package:secureindia/counts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      ),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser =
  ChatUser(id: '1', firstName: 'Umashankar', lastName: 'Mishra');

  final ChatUser _gptChatUser =
  ChatUser(id: '2', firstName: 'Secure', lastName: 'India');

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(
          0,
          166,
          126,
          1,
        ),
        title: const Text(
          'Secure India Bot',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
          currentUser: _currentUser,
          typingUsers: _typingUsers,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.black,
            containerColor: Color.fromRGBO(
              0,
              166,
              126,
              1,
            ),
            textColor: Colors.white,
          ),
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });
    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: element.message!.content),
          );
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}