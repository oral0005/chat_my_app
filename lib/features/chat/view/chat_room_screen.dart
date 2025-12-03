import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/firestore_service.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatRoomScreen extends StatefulWidget {
  final UserModel receiver;

  const ChatRoomScreen({super.key, required this.receiver});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(
        receiverId: widget.receiver.uid,
        message: _messageController.text.trim(),
      ));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          MessageInput(
            controller: _messageController,
            onSendPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: context
          .read<FirestoreService>()
          .getMessages(_auth.currentUser!.uid, widget.receiver.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка загрузки сообщений'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final doc = messages[index];
            final data = doc.data() as Map<String, dynamic>;
            final isCurrentUser = data['senderId'] == _auth.currentUser!.uid;

            return MessageBubble(
              message: data['message'],
              isCurrentUser: isCurrentUser,
            );
          },
        );
      },
    );
  }
}
