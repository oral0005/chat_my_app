import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/firestore_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirestoreService _firestoreService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ChatBloc(this._firestoreService) : super(ChatInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SendMessage>(_onSendMessage);
  }

  void _onLoadUsers(LoadUsers event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final usersStream = _firestoreService.getUsers();
      await emit.forEach(usersStream, onData: (List<UserModel> users) {
        // Фильтруем список, чтобы не показывать текущего пользователя
        final otherUsers = users.where((user) => user.uid != _firebaseAuth.currentUser?.uid).toList();
        return UsersLoaded(otherUsers);
      });
    } catch (e) {
      emit(ChatError('Не удалось загрузить пользователей: ${e.toString()}'));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestoreService.sendMessage(
        senderId: currentUser.uid,
        receiverId: event.receiverId,
        message: event.message,
      );
    } catch (e) {
      // Можно обработать ошибку отправки, например, показав snackbar
      print('Ошибка отправки сообщения: ${e.toString()}');
    }
  }
}
