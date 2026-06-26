import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  int _rating = 0;
  bool _attachDevice = true;
  bool _isLoading = false;
  bool _isSuccess = false;

  late AnimationController _springController;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedType == null || !_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
    _springController.animateWith(SpringSimulation(SpringDescription(mass: 1, stiffness: 200, damping: 14), 0, 1, 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: _isSuccess ? const SizedBox.shrink() : IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: _isSuccess
            ? const SizedBox.shrink()
            : Row(
                children: [
                  const Icon(Icons.message, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text('Enviar comentarios', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
      ),
      body: _isSuccess ? _buildSuccessView() : _buildFormView(),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Cuéntanos cómo podemos mejorar CineResumen. Cada mensaje lo revisa una persona del equipo.',
              style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14, height: 1.4)),
          const SizedBox(height: 24),
          Text('¿De qué se trata?', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          CrRadioCard(title: 'Reportar un error', description: 'Algo no funciona como debería', icon: Icons.bug_report, color: AppColors.error, isSelected: _selectedType == 'bug', onTap: () => setState(() => _selectedType = 'bug')),
          const SizedBox(height: 8),
          CrRadioCard(title: 'Sugerencia', description: 'Tengo una idea para mejorar la app', icon: Icons.lightbulb, color: AppColors.warning, isSelected: _selectedType == 'idea', onTap: () => setState(() => _selectedType = 'idea')),
          const SizedBox(height: 8),
          CrRadioCard(title: 'Me encanta', description: 'Quiero contarles algo positivo', icon: Icons.favorite, color: AppColors.accent, isSelected: _selectedType == 'love', onTap: () => setState(() => _selectedType = 'love')),
          const SizedBox(height: 8),
          CrRadioCard(title: 'Otro problema', description: 'Cuenta, pago, contenido, etc.', icon: Icons.warning_amber, color: AppColors.primary, isSelected: _selectedType == 'issue', onTap: () => setState(() => _selectedType = 'issue')),
          const SizedBox(height: 32),
          Text('¿Cómo calificarías tu experiencia? (opcional)', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final isSelected = index < _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = _rating == index + 1 ? 0 : index + 1),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: isSelected ? 1.1 : 1.0),
                  duration: const Duration(milliseconds: 150),
                  builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                  child: Icon(Icons.star, size: 40, color: isSelected ? AppColors.warning : AppColors.border),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          
          Text('Asunto *', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            style: GoogleFonts.inter(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Breve resumen de tu comentario',
              hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            ),
            validator: (v) => v == null || v.length < 4 ? 'Mínimo 4 caracteres' : null,
          ),
          const SizedBox(height: 16),
          
          Text('Mensaje *', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            style: GoogleFonts.inter(color: AppColors.textPrimary),
            maxLines: 5,
            maxLength: 500,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Escribe aquí tu mensaje...',
              hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            ),
            validator: (v) => v == null || v.length < 10 ? 'Mínimo 10 caracteres' : null,
          ),
          const SizedBox(height: 16),
          
          InkWell(
            onTap: () => setState(() => _attachDevice = !_attachDevice),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: _attachDevice ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(6), border: Border.all(color: _attachDevice ? AppColors.primary : AppColors.textSecondary)),
                  child: _attachDevice ? const Icon(Icons.check, size: 14, color: AppColors.textPrimary) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adjuntar información del dispositivo', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                      Text('Modelo, versión y registros recientes (nos ayuda a depurar)', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          CrButton.primary(
            label: 'Enviar comentarios',
            isLoading: _isLoading,
            onPressed: _selectedType != null ? _submit : null,
          ),
          const SizedBox(height: 24),
          Center(child: Text('Respondemos a ana.lopez@ejemplo.com', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12))),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _springController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _springController.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: AppColors.success.withAlpha(30), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('¡Mensaje enviado!', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Text('Gracias por tomarte el tiempo. Nuestro equipo revisa cada mensaje y te responderá a tu correo en menos de 24 horas.',
                textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
            const SizedBox(height: 40),
            CrButton.primary(label: 'Volver a ajustes', onPressed: () => Navigator.pop(context)),
            const SizedBox(height: 16),
            CrButton.secondary(
                label: 'Enviar otro',
                onPressed: () {
                  setState(() {
                    _isSuccess = false;
                    _selectedType = null;
                    _rating = 0;
                    _formKey.currentState?.reset();
                  });
                }),
          ],
        ),
      ),
    );
  }
}