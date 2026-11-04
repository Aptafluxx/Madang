import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      table.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        letterSpacing: 0.048,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      table.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        letterSpacing: 0.032,
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
