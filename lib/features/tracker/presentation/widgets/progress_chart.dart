import 'package:flutter/material.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progression',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _buildBar(context, 'S1', 0.4)),
                const SizedBox(width: 8),
                Expanded(child: _buildBar(context, 'S2', 0.6)),
                const SizedBox(width: 8),
                Expanded(child: _buildBar(context, 'S3', 0.75)),
                const SizedBox(width: 8),
                Expanded(child: _buildBar(context, 'S4', 0.85)),
                const SizedBox(width: 8),
                Expanded(child: _buildBar(context, 'S5', 0.95)),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildBar(
                    context,
                    'S6',
                    0.5,
                    isCurrent: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
    BuildContext context,
    String label,
    double value, {
    bool isCurrent = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isCurrent
                          ? AppColors.primaryGradient
                          : AppColors.successGradient,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
