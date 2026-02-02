import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/models/attachment_model.dart';

class AddNotificationAttachmentBottomSheet extends StatefulWidget {
  final bool isArabic;
  final int projectId;
  final int partId;
  final int flowId;
  final int procId;
  final int noteSer;
  final AttatchmentModel? attachmentData;

  const AddNotificationAttachmentBottomSheet({
    super.key,
    required this.isArabic,
    required this.projectId,
    required this.partId,
    required this.flowId,
    required this.procId,
    required this.noteSer,
    required this.attachmentData,
  });

  @override
  State<AddNotificationAttachmentBottomSheet> createState() =>
      _AddNotificationAttachmentBottomSheetState();
}

class _AddNotificationAttachmentBottomSheetState
    extends State<AddNotificationAttachmentBottomSheet>
    with SingleTickerProviderStateMixin {
  File? _selectedFile;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _fileDescController = TextEditingController();
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
    _fileDescController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedImage = null; // Clear image if file is selected
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic
                  ? 'فشل اختيار الملف: $e'
                  : 'Failed to pick file: $e',
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _selectedFile = null; // Clear file if image is selected
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic
                  ? 'فشل اختيار الصورة: $e'
                  : 'Failed to pick image: $e',
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.selectFileSource,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSourceOption(
              icon: Icons.camera_alt_rounded,
              label: l10n.camera,
              color: const Color(0xFF8B5CF6),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
            _buildSourceOption(
              icon: Icons.photo_library_rounded,
              label: l10n.gallery,
              color: const Color(0xFFEC4899),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _viewFile() async {
    if (_selectedFile != null) {
      try {
        await OpenFile.open(_selectedFile!.path);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isArabic
                    ? 'فشل فتح الملف: $e'
                    : 'Failed to open file: $e',
              ),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.fixed,
            ),
          );
        }
      }
    } else {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectFileFirst),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with sparkle gradient
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF10B981),
                      Color(0xFF059669),
                      Color(0xFF047857),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
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
                        Icons.add_circle_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.isArabic
                            ? 'إضافة مرفق جديد ✨'
                            : 'Add New Attachment ✨',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preview Section
                      if (_selectedImage != null) ...[
                        Text(
                          l10n.selectedImage,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (_selectedFile != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366F1).withOpacity(0.1),
                                Colors.white,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6366F1),
                                      Color(0xFF8B5CF6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.insert_drive_file_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.selectedFile,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedFile!.path.split('/').last,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // File Description Input
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _fileDescController,
                          decoration: InputDecoration(
                            labelText: l10n.fileDescription,
                            hintText: widget.isArabic
                                ? 'أدخل وصف المرفق...'
                                : 'Enter file description...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF10B981),
                                width: 2,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.description_outlined,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          maxLines: 3,
                          textDirection: widget.isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.upload_file_rounded,
                              label: l10n.uploadFile,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                              onPressed: _pickFile,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.image_rounded,
                              label: l10n.uploadImage,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                              ),
                              onPressed: _showImageSourceDialog,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.visibility_rounded,
                              label: l10n.viewFile,
                              gradient: LinearGradient(
                                colors: _selectedFile == null
                                    ? [Colors.grey[400]!, Colors.grey[500]!]
                                    : [
                                        const Color(0xFF059669),
                                        const Color(0xFF047857),
                                      ],
                              ),
                              onPressed: _viewFile,
                              isDisabled: _selectedFile == null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.save_rounded,
                              label: l10n.save,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              ),
                              onPressed: _handleSave,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    // Validate that a file or image is selected
    if (_selectedFile == null && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isArabic
                ? 'يرجى اختيار ملف أو صورة أولاً'
                : 'Please select a file or image first',
          ),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.fixed,
        ),
      );
      return;
    }

    // Validate file description
    if (_fileDescController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isArabic
                ? 'يرجى إدخال وصف المرفق'
                : 'Please enter file description',
          ),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.fixed,
        ),
      );
      return;
    }

    // Get next DocSerial from API
    final provider = Provider.of<NotificationProvider>(context, listen: false);

    int nextDocSerial = 1;
    try {
      final maxSerial = await provider.getMaxNotificationDocSerial();
      nextDocSerial = maxSerial + 1;
    } catch (e) {
      // If API fails, fallback to local calculation
      if (widget.attachmentData?.items != null &&
          widget.attachmentData!.items!.isNotEmpty) {
        int maxSerial = 0;
        for (var item in widget.attachmentData!.items!) {
          if (item.docSerial != null && item.docSerial! > maxSerial) {
            maxSerial = item.docSerial!;
          }
        }
        nextDocSerial = maxSerial + 1;
      }
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF10B981)),
              const SizedBox(height: 16),
              Text(
                widget.isArabic
                    ? 'جاري رفع المرفق... ✨'
                    : 'Uploading attachment... ✨',
                style: TextStyle(color: Colors.grey[800], fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Get the file to upload
      final File fileToUpload = _selectedImage ?? _selectedFile!;

      // Convert file to base64
      final bytes = await fileToUpload.readAsBytes();
      final base64String = base64Encode(bytes);

      // Extract just the filename from the full path
      final fileName = fileToUpload.path.split('/').last.split('\\').last;

      // Upload using provider
      await provider.uploadNotificationAttachment(
        projectId: widget.projectId,
        partId: widget.partId,
        flowId: widget.flowId,
        procId: widget.procId,
        noteSer: widget.noteSer,
        docSerial: nextDocSerial,
        docPath: fileName,
        fileDesc: _fileDescController.text.trim(),
        fileContent: base64String,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  widget.isArabic
                      ? 'تم رفع المرفق بنجاح! 🎉'
                      : 'Attachment uploaded successfully! 🎉',
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }

      // Close add attachment bottom sheet
      if (mounted)
        Navigator.of(context).pop(true); // Return true to indicate success
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Extract error message
      String errorMessage = e.toString();
      if (errorMessage.contains('Body:')) {
        final bodyIndex = errorMessage.indexOf('Body:');
        errorMessage = errorMessage.substring(bodyIndex + 6).trim();
      } else if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '').trim();
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic ? 'خطأ: $errorMessage' : 'Error: $errorMessage',
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onPressed,
    bool isDisabled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
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
}
