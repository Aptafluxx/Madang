import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/shimmer_box.dart';
import 'package:madang/features/table/data/models/table_model.dart';

class TableCard extends StatelessWidget {
  const TableCard({super.key, required this.table, required this.onTap});

  final TableModel table;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 371 / 240,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: table.imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 800,
                placeholder: (_, _) => const ShimmerBox(),
                errorWidget: (_, _, _) => Container(
                  color: const Color(0xFFEFEFEF),
                  child: const Icon(
                    Icons.restaurant,
                    color: Color(0xFFB3B3B3),
                    size: 48,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.accent, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        table.rating.toString(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x66000000)],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          table.title,
                          style: AppTextStyles.title1.copyWith(
                            height: 1.2,
                            letterSpacing: 0.048,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          table.description,
                          style: AppTextStyles.subtitle2.copyWith(
                            height: 1.3,
                            letterSpacing: 0.032,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 25,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Center(
                        child: Text(
                          table.priceText,
                          style: AppTextStyles.subtitle2.copyWith(
                            color: AppColors.primary,
                            fontWeight: .w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
