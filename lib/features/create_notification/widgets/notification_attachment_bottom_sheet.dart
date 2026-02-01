import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/attachment_model.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../l10n/app_localizations.dart';
import 'add_notification_attachment_bottom_sheet.dart';

class NotificationAttachmentBottomSheet extends StatefulWidget {
  final AttatchmentModel? attachmentData;
  final bool isArabic;
  final int projectId;
  final int partId;
  final int flowId;
  final int procId;
  final int noteSer;

  const NotificationAttachmentBottomSheet({
    super.key,
    required this.attachmentData,
    required this.isArabic,
    required this.projectId,
    required this.partId,
    required this.flowId,
    required this.procId,
    required this.noteSer,
  });

  @override
  State<NotificationAttachmentBottomSheet> createState() =>
      _NotificationAttachmentBottomSheetState();
}

class _NotificationAttachmentBottomSheetState
    extends State<NotificationAttachmentBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshAttachments() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.getNotificationAttachments(
      projectId: widget.projectId,
      partId: widget.partId,
      flowId: widget.flowId,
      procId: widget.procId,
      noteSer: widget.noteSer,
    );
  }

  void _showAddAttachmentSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddNotificationAttachmentBottomSheet(
          isArabic: widget.isArabic,
          projectId: widget.projectId,
          partId: widget.partId,
          flowId: widget.flowId,
          procId: widget.procId,
          noteSer: widget.noteSer,
          attachmentData: widget.attachmentData,
        ),
      ),
    );

    // If attachment was added successfully, refresh the list
    if (result == true) {
      await _refreshAttachments();
      if (mounted) setState(() {});
    }
  }

  String _getFileExtension(String? docPath) {
    if (docPath == null || docPath.isEmpty) return '';
    final parts = docPath.split('.');
    if (parts.length > 1) {
      return parts.last.toLowerCase();
    }
    return '';
  }

  bool _isImageFile(String extension) {
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  bool _isPdfFile(String extension) {
    return extension == 'pdf';
  }

  bool _isExcelFile(String extension) {
    return ['xls', 'xlsx', 'xlsm'].contains(extension);
  }

  IconData _getFileIcon(String extension) {
    if (_isImageFile(extension)) return Icons.image;
    if (_isPdfFile(extension)) return Icons.picture_as_pdf;
    if (_isExcelFile(extension)) return Icons.table_chart;
    return Icons.insert_drive_file;
  }

  Color _getFileTypeColor(String extension) {
    if (_isImageFile(extension))
      return const Color(0xFFEC4899); // Pink for images
    if (_isPdfFile(extension)) return const Color(0xFFEF4444); // Red for PDF
    if (_isExcelFile(extension))
      return const Color(0xFF10B981); // Green for Excel
    return const Color(0xFF4F46E5); // Indigo for others
  }

  void _showFullscreenFile(Items item) {
    if (item.photo64 == null || item.photo64!.isEmpty) return;

    final extension = _getFileExtension(item.docPath);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              item.fileDesc ?? 'Attachment',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Center(
            child: _isImageFile(extension)
                ? InteractiveViewer(
                    child: Image.memory(
                      base64Decode(item.photo64!),
                      fit: BoxFit.contain,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getFileIcon(extension),
                        size: 100,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.isArabic
                            ? 'معاينة ${extension.toUpperCase()} غير متاحة'
                            : '${extension.toUpperCase()} preview not available',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.isArabic
                            ? 'استخدم زر التحميل لفتح الملف'
                            : 'Use download button to open file',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        // Use provider data if available, otherwise fallback to widget data
        final items =
            provider.notificationAttachmentModel?.items ??
            widget.attachmentData?.items ??
            [];

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with sparkle effect
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                              Color(0xFFEC4899),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.attach_file_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                l10n.attachmentDetails,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Flexible(
                        child: items.isEmpty
                            ? _buildEmptyState(l10n)
                            : _buildAttachmentsList(items),
                      ),
                    ],
                  ),

                  // Floating Action Button with pulse animation
                  Positioned(
                    bottom: 24,
                    right: widget.isArabic ? null : 24,
                    left: widget.isArabic ? 24 : null,
                    child: _buildFAB(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[100]!, Colors.pink[100]!],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_rounded,
                size: 64,
                color: Colors.purple[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noAttachmentData,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.isArabic
                  ? 'اضغط على زر ✨ لإضافة مرفق جديد'
                  : 'Tap the ✨ button to add a new attachment',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsList(List<Items> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _buildAttachmentCard(items[index], index),
        );
      },
    );
  }

  Widget _buildAttachmentCard(Items item, int index) {
    final extension = _getFileExtension(item.docPath);
    final fileColor = _getFileTypeColor(extension);

    // Find the enclosure link
    final enclosureLink = item.links?.firstWhere(
      (link) => link.rel == 'enclosure',
      orElse: () => Links(),
    );

    final hasDownloadLink =
        enclosureLink?.href != null && enclosureLink!.href!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: fileColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: fileColor, width: 5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and serial number
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            fileColor.withOpacity(0.2),
                            fileColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getFileIcon(extension),
                        color: fileColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isArabic ? 'مرفق رقم' : 'Attachment',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${item.docSerial ?? '-'}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // File type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: fileColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: fileColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        extension.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: fileColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Animated Divider
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        fileColor.withOpacity(0.1),
                        fileColor.withOpacity(0.4),
                        fileColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 16),

                // File Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description_rounded,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isArabic ? 'الوصف' : 'Description',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.fileDesc ?? '-',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // File Preview Section
                if (item.photo64 != null && item.photo64!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showFullscreenFile(item),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[100],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildFilePreview(item),
                      ),
                    ),
                  ),
                ],

                // Download Button
                if (hasDownloadLink) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _downloadAttachment(enclosureLink.href!),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [fileColor, fileColor.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: fileColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.isArabic ? 'تحميل المرفق' : 'Download',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(Items item) {
    final extension = _getFileExtension(item.docPath);

    if (_isImageFile(extension)) {
      try {
        final imageBytes = base64Decode(item.photo64!);
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(imageBytes, fit: BoxFit.cover),
            // Overlay with tap hint
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.fullscreen_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isArabic
                          ? 'اضغط للعرض بملء الشاشة'
                          : 'Tap to view fullscreen',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      } catch (e) {
        return _buildFileIconPreview(extension);
      }
    } else {
      return _buildFileIconPreview(extension);
    }
  }

  Widget _buildFileIconPreview(String extension) {
    final fileColor = _getFileTypeColor(extension);
    return Container(
      color: fileColor.withOpacity(0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getFileIcon(extension), size: 80, color: fileColor),
          const SizedBox(height: 16),
          Text(
            extension.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: fileColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isArabic ? 'اضغط للعرض' : 'Tap to view',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _showAddAttachmentSheet,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF059669)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                widget.isArabic ? 'إضافة مرفق ✨' : 'Add Attachment ✨',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadAttachment(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic
                  ? 'فشل فتح الرابط: $e'
                  : 'Failed to open link: $e',
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }
}
