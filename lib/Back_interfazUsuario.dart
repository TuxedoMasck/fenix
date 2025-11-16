
import 'package:flutter/material.dart';
// Importante: Si en el futuro usas paquetes para seleccionar imágenes (como image_picker),
// deberás importarlos aquí.
// import 'dart:io'; // Para manejar archivos de imagen

class PerfilUsuarioLogic extends ChangeNotifier {
  // --- Estado ---

  // Controlador para el campo de texto del nombre
  late TextEditingController nameController;

  // Variable para almacenar la imagen de perfil (actualmente es un placeholder)
  // File? profileImage;

  // --- Inicialización ---

  PerfilUsuarioLogic() {
    // Inicializamos el controlador con un nombre de usuario de ejemplo.
    // En una aplicación real, aquí cargarías el nombre del usuario actual.
    nameController = TextEditingController(text: "Ricardo");
  }

  // --- Métodos (Lógica de Negocio) ---

  /// Simula la selección de una nueva foto de perfil.
  Future<void> seleccionarNuevaFoto(BuildContext context) async {
    // Aquí iría la lógica para usar un paquete como image_picker y obtener una imagen
    // de la galería o la cámara.

    // Por ahora, solo mostramos un mensaje.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función para seleccionar foto no implementada.')),
    );

    // Cuando tengas la imagen, harías algo como:
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   profileImage = File(pickedFile.path);
    //   notifyListeners(); // Notifica a la UI que la imagen cambió
    // }
  }

  /// Guarda los cambios realizados en el perfil.
  void guardarCambios(BuildContext context) {
    final nuevoNombre = nameController.text;

    // Aquí iría la lógica para enviar el `nuevoNombre` y la `profileImage`
    // a tu servidor o base de datos.

    // Mostramos una confirmación al usuario.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cambios guardados para: $nuevoNombre')),
    );

    // Ocultamos el teclado para una mejor experiencia de usuario.
    FocusScope.of(context).unfocus();
  }

  // Es importante limpiar los controladores cuando el widget se destruye
  // para liberar recursos.
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
