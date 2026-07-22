import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class ChangeNameScreen extends StatefulWidget {
  static const name = 'change-name--screen';

  const ChangeNameScreen({super.key});

  @override
  State<ChangeNameScreen> createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends State<ChangeNameScreen> {
  final TextEditingController _nombresCtrl = TextEditingController();
  final TextEditingController _apellidosCtrl = TextEditingController();
  bool _isLoading = false;

  bool _isTypingNombres = false,
      _nombresNoNumbers = true,
      _nombresTitleCase = false;
  bool _isTypingApellidos = false,
      _apellidosNoNumbers = true,
      _apellidosTitleCase = false;

  @override
  void initState() {
    super.initState();
    _nombresCtrl.addListener(_validateNombres);
    _apellidosCtrl.addListener(_validateApellidos);
  }

  @override
  void dispose() {
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    super.dispose();
  }

  bool _isStrictlyFormatted(String text) {
    if (text.trim().isEmpty) return false;
    for (String word in text.trim().split(RegExp(r'\s+'))) {
      if (word.isNotEmpty) {
        if (word != word[0].toUpperCase() + word.substring(1).toLowerCase())
          return false;
      }
    }
    return true;
  }

  void _validateNombres() => setState(() {
    _isTypingNombres = _nombresCtrl.text.isNotEmpty;
    _nombresNoNumbers = !RegExp(r'[0-9]').hasMatch(_nombresCtrl.text);
    _nombresTitleCase = _isStrictlyFormatted(_nombresCtrl.text);
  });

  void _validateApellidos() => setState(() {
    _isTypingApellidos = _apellidosCtrl.text.isNotEmpty;
    _apellidosNoNumbers = !RegExp(r'[0-9]').hasMatch(_apellidosCtrl.text);
    _apellidosTitleCase = _isStrictlyFormatted(_apellidosCtrl.text);
  });

  Future<void> _submit() async {
    final nombres = _nombresCtrl.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final apellidos = _apellidosCtrl.text.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    if (!_nombresNoNumbers ||
        !_nombresTitleCase ||
        !_apellidosNoNumbers ||
        !_apellidosTitleCase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifica los requisitos del nombre y apellido'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ProfileService.changeNameAndSurname(
        userId: SessionManager.userId!,
        nombres: nombres,
        apellidos: apellidos,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showNombresValidation =
        _isTypingNombres && !(_nombresNoNumbers && _nombresTitleCase);
    final bool showApellidosValidation =
        _isTypingApellidos && !(_apellidosNoNumbers && _apellidosTitleCase);

    return Scaffold(
      backgroundColor: AppColors.secondary900,
      appBar: AppBar(
        backgroundColor: AppColors.secondary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
        ),
        title: const AppH2(
          text: 'Actualizar Perfil',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const GradientBackgroundWidget(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      InputWidget(
                        label: 'Nombre(s) *',
                        hintText: 'Ej: Juan Manuel Diego',
                        controller: _nombresCtrl,
                      ),
                      if (showNombresValidation)
                        ValidationCardWidget(
                          title: "Requisitos del nombre:",
                          requirements: {
                            "No debe contener números": _nombresNoNumbers,
                            "Primera letra mayúscula": _nombresTitleCase,
                          },
                        ),
                      const SizedBox(height: 16),
                      InputWidget(
                        label: 'Apellido(s) *',
                        hintText: 'Ej: Rivas Pavon',
                        controller: _apellidosCtrl,
                      ),
                      if (showApellidosValidation)
                        ValidationCardWidget(
                          title: "Requisitos de los apellidos:",
                          requirements: {
                            "No debe contener números": _apellidosNoNumbers,
                            "Primera letra mayúscula": _apellidosTitleCase,
                          },
                        ),
                      const SizedBox(height: 32),
                      ButtonWidget(
                        text: _isLoading ? 'Cargando...' : 'Guardar',
                        type: ButtonType.primary,
                        onPressed: _isLoading ? () {} : _submit,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
