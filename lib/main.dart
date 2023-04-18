import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_bloc_observer.dart';
import 'bloc/auth/auth_bloc/auth_bloc.dart';
import 'bloc/auth/auth_cubit/auth_cubit.dart';
import 'bloc/auth/auth_screens/login_screen.dart';
import 'bloc/auth/auth_screens/resgister_screen.dart';
import 'bloc/chat/chat_cubit/chat_cubit.dart';
import 'bloc/chat/chat_screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = CustomBlocObserver();
  runApp(const ScholarChat());
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          ChatScreen.id: (context) => ChatScreen()
        },
        initialRoute: LoginScreen.id,
      ),
    );
  }
}
