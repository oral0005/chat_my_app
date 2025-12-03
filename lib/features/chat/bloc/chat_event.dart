part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String receiverId;
  final String message;

  const SendMessage({required this.receiverId, required this.message});

  @override
  List<Object> get props => [receiverId, message];
}
