import 'dart:io';
import 'package:fenix/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilUsuarioLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  String? _avatarUrl;
  String? _userName;
  bool _isLoading = true;

  String? get avatarUrl => _avatarUrl;
  String? get userName => _userName;
  bool get isLoading => _isLoading;

  PerfilUsuarioLogic() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();
    final user = _supabase.auth.currentUser;
    if (user != null) {
      _avatarUrl = user.userMetadata?['avatar_url'];
      _userName = user.userMetadata?['full_name'] ?? 'Sin Nombre';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> seleccionarYSubirFoto(BuildContext context) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (imageFile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final file = File(imageFile.path);
      final userId = _supabase.auth.currentUser!.id;
      final filePath = '$userId/profile.png';

      await _supabase.storage.from('profile-pictures').uploadBinary(
            filePath,
            file.readAsBytesSync(),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final baseUrl = _supabase.storage.from('profile-pictures').getPublicUrl(filePath);
      final uniqueUrl = '$baseUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      await _supabase.auth.updateUser(
        UserAttributes(data: {'avatar_url': uniqueUrl}),
      );
      
      _avatarUrl = uniqueUrl;
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil actualizada.')),
        );
      }

    } catch (e) {
        if(context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al subir la imagen: ${e.toString()}'), backgroundColor: Colors.red),
            );
        }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _supabase.auth.signOut();
    if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
        );
    }
  }
}
