import 'dart:io';
import 'package:fenix/Back_login.dart';
import 'package:fenix/Interfaz_InfPersonal.dart';
import 'package:fenix/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilUsuarioLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  final _authService = AuthService();

  String? _avatarUrl;
  String? _username;
  bool _isLoading = true;

  String? get avatarUrl => _avatarUrl;
  String? get username => _username;
  bool get isLoading => _isLoading;

  PerfilUsuarioLogic() {
    loadUserData();
  }

  // Ahora es público para poder ser llamado para refrescar los datos.
  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    final user = _supabase.auth.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _avatarUrl = user.userMetadata?['avatar_url'];
      final data = await _supabase.from('Perfiles').select('username').eq('id', user.id).single();
      _username = data['username'] ?? 'Sin nombre de usuario';

    } catch (e) {
      debugPrint("Error cargando datos del perfil: $e");
      _username = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> navigateToInfPersonal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InterfazInfPersonal()),
    );
    // Refresca los datos al volver de la pantalla de edición.
    await loadUserData();
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
    await _authService.logout(); 
    if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
        );
    }
  }
}
