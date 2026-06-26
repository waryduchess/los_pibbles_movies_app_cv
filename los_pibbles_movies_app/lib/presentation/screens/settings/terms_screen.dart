import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _isTermsTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Text('Legal', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton(true, 'Términos', Icons.description)),
                  Expanded(child: _buildTabButton(false, 'Privacidad', Icons.security)),
                ],
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(animation),
                  child: child,
                ),
              ),
              child: _isTermsTab ? _buildTermsContent(key: const ValueKey('terms')) : _buildPrivacyContent(key: const ValueKey('privacy')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(bool isTerms, String title, IconData icon) {
    final isActive = _isTermsTab == isTerms;
    return GestureDetector(
      onTap: () => setState(() => _isTermsTab = isTerms),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: isActive ? AppColors.primary.withOpacity(0.20) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isActive ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.inter(color: isActive ? AppColors.primary : AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String title, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.accent.withOpacity(0.10), AppColors.surface]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor)),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Última actualización: 1 de junio de 2026 · Versión 2.4', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RESUMEN EN 1 MINUTO', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          Text(text, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border, width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(body, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14, height: 20 / 14)),
        ],
      ),
    );
  }

  Widget _buildFooterContent() {
    return Column(
      children: [
        const SizedBox(height: 24),
        CrButton.secondary(
          label: 'Descargar PDF',
          icon: Icons.download,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Descarga simulada — en producción descargaría el PDF.')));
          },
        ),
        const SizedBox(height: 32),
        Text('© 2026 CineResumen · Hecho con cariño en México', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTermsContent({Key? key}) {
    return ListView(
      key: key,
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard('Términos de uso', Icons.description, AppColors.accent),
        const SizedBox(height: 16),
        _buildSummaryCard("Usa CineResumen para uso personal. No copies ni revendas el contenido. Si rompes las reglas, podemos suspender tu cuenta. El servicio se ofrece sin garantías y se rige por leyes mexicanas."),
        const SizedBox(height: 24),
        _buildSection('Aceptación de los términos', 'Al acceder o usar la aplicación CineResumen, aceptas estar sujeto a estos términos. Si no estás de acuerdo con alguna parte, no podrás acceder al servicio.'),
        _buildSection('Uso permitido', 'La aplicación está destinada únicamente para uso personal y no comercial. Se prohíbe la extracción automatizada de datos, reventa de cuentas o distribución de nuestros resúmenes sin autorización.'),
        _buildSection('Cuentas y seguridad', 'Eres responsable de salvaguardar la contraseña o los accesos biométricos que utilizas para acceder a la aplicación. Notifícanos inmediatamente sobre cualquier brecha de seguridad.'),
        _buildSection('Contenido de terceros', 'Nuestra aplicación puede contener enlaces a sitios web o servicios de terceros (como bases de datos de películas) que no son propiedad ni están controlados por CineResumen.'),
        _buildSection('Suspensión de cuentas', 'Podemos cancelar o suspender el acceso a nuestro servicio inmediatamente, sin previo aviso o responsabilidad, por cualquier motivo, incluido el incumplimiento de los Términos.'),
        _buildSection('Limitación de responsabilidad', 'CineResumen y sus proveedores no serán responsables de ningún daño indirecto, incidental o consecuente resultante del uso o la incapacidad de usar el servicio.'),
        _buildSection('Ley aplicable', 'Estos términos se regirán e interpretarán de acuerdo con las leyes de México, sin tener en cuenta sus disposiciones sobre conflictos de leyes.'),
        _buildFooterContent(),
      ],
    );
  }

  Widget _buildPrivacyContent({Key? key}) {
    return ListView(
      key: key,
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard('Política de privacidad', Icons.security, AppColors.primary),
        const SizedBox(height: 16),
        _buildSummaryCard("Solo guardamos lo necesario para que la app funcione: correo, contraseña cifrada, favoritos y reseñas. Nunca vendemos tus datos. Puedes borrar todo desde Ajustes en cualquier momento."),
        const SizedBox(height: 24),
        _buildSection('Qué datos recopilamos', 'Recopilamos la dirección de correo electrónico que proporcionas al registrarte, así como datos de uso anónimos. Las contraseñas y datos biométricos se almacenan cifrados.'),
        _buildSection('Cómo los usamos', 'Usamos tu información exclusivamente para proveer y mantener nuestro servicio, notificarte sobre cambios en la app y proporcionar soporte al cliente.'),
        _buildSection('Almacenamiento', 'Tus datos están protegidos en servidores seguros. Retenemos tu información solo durante el tiempo necesario para los fines establecidos en esta política.'),
        _buildSection('Tus derechos', 'Tienes derecho a acceder, actualizar o eliminar la información que tenemos sobre ti. Puedes realizar la eliminación completa de tu cuenta desde el menú de Ajustes.'),
        _buildSection('Cookies y analítica', 'Utilizamos tecnologías de seguimiento locales mínimas para mejorar la experiencia de navegación en la app. No compartimos identificadores con anunciantes de terceros.'),
        _buildSection('Contacto', 'Si tienes preguntas sobre esta Política de Privacidad, puedes contactarnos a través del Centro de Ayuda o escribiendo directamente a privacidad@cineresumen.app.'),
        _buildFooterContent(),
      ],
    );
  }
}