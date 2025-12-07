import 'package:flutter/material.dart';
import 'package:prime_work/core/theme/app_colors.dart';

class ClientCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String status;
  final Color statusColor;
  final String lastContact;
  final String? nextAction;
  final String? lastOrder;
  final String? totalOrders;
  final bool hasNotification;

  const ClientCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    required this.statusColor,
    required this.lastContact,
    this.nextAction,
    this.lastOrder,
    this.totalOrders,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasNotification
              ? AppColors.warning.withOpacity(0.3)
              : AppColors.border,
          width: hasNotification ? 2 : 1,
        ),
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
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor,
                      statusColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name & Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasNotification)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'call',
                    child: Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Appeler'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'message',
                    child: Row(
                      children: [
                        Icon(Icons.message_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Envoyer un message'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'email',
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Envoyer un email'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                        SizedBox(width: 12),
                        Text('Supprimer', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // Contact Info
          _buildInfoRow(Icons.phone_outlined, phone),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.email_outlined, email),

          if (nextAction != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.notifications_outlined,
              nextAction!,
              color: AppColors.warning,
            ),
          ],

          if (lastOrder != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.shopping_bag_outlined, lastOrder!),
          ],

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    lastContact,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                ],
              ),
              if (totalOrders != null)
                Text(
                  'Total: $totalOrders',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color ?? AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
