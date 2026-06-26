import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/inputs/cr_search_field.dart';
import '../../../widgets/movies/cr_category_chip.dart';
import '../../../widgets/settings/cr_faq_item.dart';
import '../../../widgets/common/cr_section_header.dart';

class Faq {
  final String category;
  final String q;
  final String a;
  const Faq({required this.category, required this.q, required this.a});
}

const _allFaqs = [
  Faq(category: "Primeros pasos", q: "¿Cómo funciona CineResumen?", a: "CineResumen te muestra resúmenes cortos de películas..."),
  Faq(category: "Primeros pasos", q: "¿Puedo usar la app sin conexión?", a: "Sí. Tus favoritos se guardan localmente..."),
  Faq(category: "Películas", q: "¿Cómo agrego una película a favoritos?", a: "Toca el ícono de corazón en la tarjeta..."),
  Faq(category: "Películas", q: "¿Cada cuánto se actualiza el catálogo?", a: "Agregamos nuevas películas todos los viernes..."),
  Faq(category: "Cuenta", q: "¿Cómo cambio mi correo electrónico?", a: "Ve a Ajustes → Cuenta → Correo electrónico..."),
  Faq(category: "Cuenta", q: "¿Cómo elimino mi cuenta?", a: "Escríbenos desde Ajustes → Soporte..."),
  Faq(category: "Seguridad", q: "¿Es seguro el inicio biométrico?", a: "Sí. La huella se guarda cifrada en el enclave..."),
  Faq(category: "Seguridad", q: "Olvidé mi contraseña", a: "En la pantalla de inicio toca '¿Olvidaste tu contraseña?'..."),
];

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  int? _expandedFaqIndex;

  List<Faq> get _filteredFaqs {
    return _allFaqs.where((faq) {
      final matchesSearch = faq.q.toLowerCase().contains(_searchQuery.toLowerCase()) || faq.a.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || faq.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> _launchSupportEmail() async {
    final uri = Uri.parse('mailto:soporte@cineresumen.app');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filteredFaqs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Centro de ayuda', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CrSearchField(
            placeholder: '¿En qué podemos ayudarte?',
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 24),
          const CrSectionHeader(title: 'CATEGORÍAS'),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3,
            children: [
              _buildCatChip(Icons.menu_book, 'Primeros pasos', AppColors.primary),
              _buildCatChip(Icons.movie, 'Películas', AppColors.accent),
              _buildCatChip(Icons.credit_card, 'Cuenta', AppColors.success),
              _buildCatChip(Icons.security, 'Seguridad', AppColors.warning),
            ],
          ),
          const SizedBox(height: 32),
          const CrSectionHeader(title: 'PREGUNTAS FRECUENTES'),
          const SizedBox(height: 16),
          if (faqs.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Text('Sin resultados · Prueba con otra palabra o contacta a soporte abajo.',
                  textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14)),
            )
          else
            Container(
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: faqs.length,
                separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 1, thickness: 1),
                itemBuilder: (context, index) {
                  return CrFaqItem(
                    question: faqs[index].q,
                    answer: faqs[index].a,
                    isExpanded: _expandedFaqIndex == index,
                    onTap: () => setState(() => _expandedFaqIndex = _expandedFaqIndex == index ? null : index),
                  );
                },
              ),
            ),
          const SizedBox(height: 32),
          const CrSectionHeader(title: '¿AÚN NECESITAS AYUDA?'),
          const SizedBox(height: 16),
          _buildHelpCard(Icons.message, AppColors.accent, 'Enviar comentarios', 'Respondemos en menos de 24 h', () => Navigator.pushNamed(context, '/feedback')),
          const SizedBox(height: 8),
          _buildHelpCard(Icons.mail, AppColors.primary, 'soporte@cineresumen.app', 'Toca para enviar un correo', _launchSupportEmail),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCatChip(IconData icon, String label, Color color) {
    return CrCategoryChip(
      icon: icon,
      label: label,
      color: color,
      isSelected: _selectedCategory == label,
      onTap: () => setState(() => _selectedCategory = _selectedCategory == label ? null : label),
    );
  }

  Widget _buildHelpCard(IconData icon, Color color, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10), 
              decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(8)), 
              child: Icon(icon, color: color)
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}