import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart'; // Asegúrate de importar tus widgets

class ChangeNameDialog extends StatefulWidget {
  const ChangeNameDialog({super.key});

  @override
  State<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  final nombresCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  bool isLoading = false;

  // Estados de validación
  bool _isTypingNombres = false, _nombresNoNumbers = true, _nombresTitleCase = false;
  bool _isTypingApellidos = false, _apellidosNoNumbers = true, _apellidosTitleCase = false;

  @override
  void initState() {
    super.initState();
    nombresCtrl.addListener(_validateNombres);
    apellidosCtrl.addListener(_validateApellidos);
  }

  @override
  void dispose() {
    nombresCtrl.dispose();
    apellidosCtrl.dispose();
    super.dispose();
  }

  bool _isStrictlyFormatted(String text) {
    if (text.trim().isEmpty) return false;
    for (String word in text.trim().split(RegExp(r'\s+'))) {
      if (word.isNotEmpty) {
        if (word != word[0].toUpperCase() + word.substring(1).toLowerCase()) return false;
      }
    }
    return true;
  }

  void _validateNombres() => setState(() {
    _isTypingNombres = nombresCtrl.text.isNotEmpty;
    _nombresNoNumbers = !RegExp(r'[0-9]').hasMatch(nombresCtrl.text);
    _nombresTitleCase = _isStrictlyFormatted(nombresCtrl.text);
  });

  void _validateApellidos() => setState(() {
    _isTypingApellidos = apellidosCtrl.text.isNotEmpty;
    _apellidosNoNumbers = !RegExp(r'[0-9]').hasMatch(apellidosCtrl.text);
    _apellidosTitleCase = _isStrictlyFormatted(apellidosCtrl.text);
  });

Future<void> _submit() async {
    final nombres = nombresCtrl.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final apellidos = apellidosCtrl.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    if (!_nombresNoNumbers || !_nombresTitleCase || !_apellidosNoNumbers || !_apellidosTitleCase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifica los requisitos del nombre y apellido'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await ProfileService.changeNameAndSurname(
        userId: SessionManager.userId!,
        nombres: nombres,
        apellidos: apellidos,
      );
      
      
      SessionManager.userName = "$nombres $apellidos";

      if (mounted) {
        Navigator.pop(context, true); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final bool showNombresValidation = _isTypingNombres && !(_nombresNoNumbers && _nombresTitleCase);
    final bool showApellidosValidation = _isTypingApellidos && !(_apellidosNoNumbers && _apellidosTitleCase);

    return AlertDialog(
      backgroundColor: AppColors.secondary900,
      title: const Text('Actualizar Perfil', style: TextStyle(color: AppColors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombresCtrl,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: 'Nombres',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            if (showNombresValidation) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ValidationCardWidget(
                  title: "Requisitos del nombre:",
                  requirements: {"No debe contener números": _nombresNoNumbers, "Primera letra mayúscula": _nombresTitleCase},
                ),
              ),
            const SizedBox(height: 12),
            
            TextField(
              controller: apellidosCtrl,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            if (showApellidosValidation) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ValidationCardWidget(
                  title: "Requisitos de los apellidos:",
                  requirements: {"No debe contener números": _apellidosNoNumbers, "Primera letra mayúscula": _apellidosTitleCase},
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500),
          onPressed: isLoading ? null : _submit,
          child: isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Text('Guardar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}