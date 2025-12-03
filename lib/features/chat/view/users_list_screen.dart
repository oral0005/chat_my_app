import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/firestore_service.dart';
import '../bloc/chat_bloc.dart';
import 'chat_room_screen.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        RepositoryProvider.of<FirestoreService>(context),
      )..add(LoadUsers()),
      child: Scaffold(
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading || state is ChatInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UsersLoaded) {
              if (state.users.isEmpty) {
                return const Center(
                  child: Text('Других пользователей не найдено.'),
                );
              }
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<ChatBloc>(context),
                            child: ChatRoomScreen(receiver: user),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
            if (state is ChatError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Что-то пошло не так'));
          },
        ),
      ),
    );
  }
}
