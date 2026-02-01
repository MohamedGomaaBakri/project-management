import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/notification_provider.dart';
import 'notification_attachment_bottom_sheet.dart';

class NotificationAttachmentsButton extends StatelessWidget {
  final int projectId;
  final int partId;
  final int flowId;
  final int procId;
  final int noteSer;

  const NotificationAttachmentsButton({
    super.key,
    required this.projectId,
    required this.partId,
    required this.flowId,
    required this.procId,
    required this.noteSer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () async {
          // Fetch attachments first
          final provider = Provider.of<NotificationProvider>(
            context,
            listen: false,
          );

          await provider.getNotificationAttachments(
            projectId: projectId,
            partId: partId,
            flowId: flowId,
            procId: procId,
            noteSer: noteSer,
          );

          // Show attachment bottom sheet
          if (context.mounted) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: NotificationAttachmentBottomSheet(
                  attachmentData: provider.notificationAttachmentModel,
                  isArabic: isArabic,
                  projectId: projectId,
                  partId: partId,
                  flowId: flowId,
                  procId: procId,
                  noteSer: noteSer,
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.attach_file, size: 24),
        label: Text(
          l10n.attachmentsButton,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
