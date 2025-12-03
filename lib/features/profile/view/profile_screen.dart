import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/firestore_service.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    if (user == null) {
      return const Center(child: Text('Пользователь не найден.'));
    }

    return FutureBuilder<UserModel?>(
      future: FirestoreService().getUserData(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Не удалось загрузить данные профиля.'));
        }

        final userModel = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfoTile(
                label: 'Имя:',
                value: userModel.name,
              ),
              const SizedBox(height: 24),
              ProfileInfoTile(
                label: 'Email:',
                value: userModel.email,
              ),
              const Spacer(),
              const LogoutButton(),
            ],
          ),
        );
      },
    );
  }
}
