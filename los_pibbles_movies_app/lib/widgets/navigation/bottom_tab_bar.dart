import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// 🌟 Ajusta esta ruta a tu provider real si es necesario
import 'package:los_pibbles_movies_app/presentation/providers/favorites_provider.dart';

class BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / 4; // 4 Pestañas
    const indicatorWidth = 32.0;
    
    // 🌟 Calcula exactamente dónde debe quedar centrado el pill animado
    final indicatorLeft = (tabWidth * currentIndex) + ((tabWidth - indicatorWidth) / 2);

    return Container(
      // Altura base 64px + el área segura (el notch del iPhone abajo)
      height: 64 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0E17), // Surface
        border: Border(
          top: BorderSide(color: Color(0xFF374151), width: 1), // Borde sutil superior
        ),
      ),
      child: Stack(
        children: [
          // 1. INDICADOR ANIMADO (PILL)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            top: 0,
            left: indicatorLeft,
            child: Container(
              width: indicatorWidth,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF675CFF), // Primary Violeta
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          
          // 2. ICONOS DE LAS PESTAÑAS
          Row(
            children: [
              _TabItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Inicio',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _TabItem(
                icon: Icons.search_rounded,
                label: 'Buscar',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _TabItem(
                icon: Icons.favorite_border_rounded,
                activeIcon: Icons.favorite_rounded,
                label: 'Favoritos',
                isActive: currentIndex == 2,
                showBadge: true, // 🌟 Activa el badge del Provider
                onTap: () => onTap(2),
              ),
              _TabItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings_rounded,
                label: 'Perfil',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// WIDGET INTERNO: Cada Ítem de la pestaña con animación
// -----------------------------------------------------
class _TabItem extends StatefulWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive;
  final bool showBadge;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isActive,
    this.showBadge = false,
    required this.onTap,
  });

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive ? const Color(0xFF675CFF) : const Color(0xFF9CA3AF);
    final currentIcon = widget.isActive ? (widget.activeIcon ?? widget.icon) : widget.icon;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Animación de escala (bounce) al mantener presionado
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    currentIcon,
                    size: 24, 
                    color: color,
                  ),
                  
                  // BADGE DE FAVORITOS
                  if (widget.showBadge)
                    Consumer<FavoritesProvider>(
                      builder: (context, provider, child) {
                        final count = provider.favoriteMovieIds.length;
                        if (count == 0) return const SizedBox.shrink(); // Oculta si es 0
                        
                        return Positioned(
                          top: -4,
                          right: -8,
                          child: Container(
                            // 🌟 CORRECCIÓN AQUÍ: usamos constraints en lugar de minWidth directo
                            constraints: const BoxConstraints(minWidth: 16),
                            height: 16,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5C8A), // Accent Rosa
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              count > 99 ? '99+' : count.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF1A1B2E), // OnPrimary
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}