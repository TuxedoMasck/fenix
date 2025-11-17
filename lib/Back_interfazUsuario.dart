import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilUsuarioLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  late TextEditingController nameController;
  String? _avatarUrl;
  bool _isLoading = true;

  String? get avatarUrl => _avatarUrl;
  bool get isLoading => _isLoading;

  PerfilUsuarioLogic() {
    nameController = TextEditingController();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      nameController.text = user.userMetadata?['full_name'] ?? '';
      _avatarUrl = user.userMetadata?['avatar_url'];
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

    try {
      _isLoading = true;
      notifyListeners();

      final file = File(imageFile.path);
      final userId = _supabase.auth.currentUser!.id;
      final filePath = '$userId/profile.png';

      await _supabase.storage.from('profile-pictures').uploadBinary(
            filePath,
            file.readAsBytesSync(),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // --- ¡AQUÍ ESTÁ LA MAGIA! ---
      // 1. Obtenemos la URL base.
      final baseUrl = _supabase.storage.from('profile-pictures').getPublicUrl(filePath);

      // 2. Le añadimos un timestamp para hacerla única y evitar la caché.
      final uniqueUrl = '$baseUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      // 3. Guardamos la URL única en el perfil del usuario.
      await _supabase.auth.updateUser(
        UserAttributes(data: {'avatar_url': uniqueUrl, 'full_name': nameController.text}),
      );
      
      // 4. Actualizamos el estado local con la URL única.
      _avatarUrl = uniqueUrl;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil actualizada.')),
      );

    } on StorageException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen: ${e.message}'), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error inesperado: $e'), backgroundColor: Colors.red),
      );
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> guardarCambios(BuildContext context) async {
     try {
       await _supabase.auth.updateUser(
        UserAttributes(data: {'full_name': nameController.text}),
      );
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre actualizado.')),
      );
     } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el nombre: $e'), backgroundColor: Colors.red),
      );
     }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
