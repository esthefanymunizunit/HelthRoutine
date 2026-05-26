import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class TemplateCard extends StatelessWidget {
  final String title;
  final String desc;
  final Color color;
  final Color titleColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  const TemplateCard({
    super.key,
    required this.title,
    required this.desc,
    required this.color,
    required this.titleColor,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = constraints.maxHeight;
          const double cutoutRadius = 24.0;
          const double buttonRadius = 16.0;
          final double cutoutCenterY = (cardHeight / 2) + 10;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: CardCutoutClipper(
                  cutoutCenterY: cutoutCenterY,
                  cutoutRadius: cutoutRadius,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: color,
                  padding: const EdgeInsets.only(
                    left: 14,
                    top: 14,
                    bottom: 12,
                    right: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          desc,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -buttonRadius,
                top: cutoutCenterY - buttonRadius,
                child: Container(
                  width: buttonRadius * 2,
                  height: buttonRadius * 2,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_outward,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// A classe do clipper fica escondida aqui, pois só esse card precisa dela!
class CardCutoutClipper extends CustomClipper<Path> {
  final double cutoutCenterY;
  final double cutoutRadius;

  CardCutoutClipper({required this.cutoutCenterY, required this.cutoutRadius});

  @override
  Path getClip(Size size) {
    Path path = Path();
    const double radius = 24.0;

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    path.lineTo(size.width, cutoutCenterY - cutoutRadius);

    path.arcToPoint(
      Offset(size.width, cutoutCenterY + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CardCutoutClipper oldClipper) =>
      oldClipper.cutoutCenterY != cutoutCenterY ||
      oldClipper.cutoutRadius != cutoutRadius;
}