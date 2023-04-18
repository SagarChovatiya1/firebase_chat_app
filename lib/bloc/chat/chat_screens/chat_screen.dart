import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants.dart';
import '../../../models/message.dart';
import '../../../widgets/chat_buble.dart';
import '../chat_cubit/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  static const String id = 'ChatPage';

  final _controller = ScrollController();
  TextEditingController controller = TextEditingController();

  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments.toString();
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                kLogo,
                height: 40,
              ),
              const SizedBox(width: 5),
              const Text('chat',style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontFamily: 'pacifico',
              ),),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
                List<Message> messagesList =
                    BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFriend(message: messagesList[index]);
                    });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                onSubmitted: (data) {
                  BlocProvider.of<ChatCubit>(context)
                      .sendMessage(message: data, email: email);
                  controller.clear();
                  _controller.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                decoration: InputDecoration(
                  hintText: 'Send Message',
                  suffixIcon: const Icon(
                    Icons.send,
                    color: kPrimaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
