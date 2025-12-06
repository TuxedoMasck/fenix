import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationRequest {
  final String fullName;
  final String institutionalEmail;
  final String uamId;
  final String department;
  final PlatformFile pdfFile;

  RegistrationRequest({
    required this.fullName,
    required this.institutionalEmail,
    required this.uamId,
    required this.department,
    required this.pdfFile,
  });
}

class RegistroLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  PlatformFile? _pickedPdf;

  bool get isLoading => _isLoading;
  PlatformFile? get pickedPdf => _pickedPdf;

  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Importante: Le decimos que cargue los bytes en memoria
    );

    if (result != null) {
      _pickedPdf = result.files.first;
      notifyListeners();
    }
  }

  Future<String> sendRequest(RegistrationRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      //
      final pdfBytes = request.pdfFile.bytes!;
      final pdfPath = 'credentials/${request.institutionalEmail}/${request.pdfFile.name}';
      
      await _supabase.storage.from('registration-pdfs').uploadBinary(
        pdfPath,
        pdfBytes,
        fileOptions: const FileOptions(upsert: true),
      );

      final pdfUrl = _supabase.storage.from('registration-pdfs').getPublicUrl(pdfPath);

      final response = await _supabase.functions.invoke('send-registration-request', 
        body: {
          'fullName': request.fullName,
          'institutionalEmail': request.institutionalEmail,
          'uamId': request.uamId,
          'department': request.department,
          'pdfUrl': pdfUrl,
        },
      );

      if (response.status != 200) {
        throw 'Error al contactar al servidor. Por favor, inténtalo más tarde.';
      }

      _pickedPdf = null; 
      return 'Solicitud enviada con éxito. Recibirás una confirmación por correo cuando tu cuenta sea aprobada.';

    } catch (e) {
      return 'Ocurrió un error inesperado: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static String? validateUamEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo no puede estar vacío.';
    }
    // solo terminaciones escolares
    final validEnds = ['@cua.uam.mx', '@alumnos.cua.uam.mx', '@correo.cua.uam.mx'];
    if (!validEnds.any((end) => value.endsWith(end))) {
      return 'Debe ser un correo @cua.uam.mx, @alumnos.cua.uam.mx y @correo.cua.uam.mx';
    }
    return null; // Devuelve null si la validación es exitosa
  }
}
