import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants.dart';
import '../../../models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection("kMessagesCollections");
  List<Message> messagesList = [];

  void sendMessage({required String message, required String email}) {
    try {
      messages.add(
        {kMessage: message, kCreatedAt: DateTime.now(), id: email},
      );
    } catch (e) {
      print("e :- $e");
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}
