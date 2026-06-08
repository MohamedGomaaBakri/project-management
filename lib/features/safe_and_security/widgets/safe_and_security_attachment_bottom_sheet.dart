import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/attachment_model.dart';
import '../../../core/providers/safe_and_security_provider.dart';

class SafeAndSecurityAttachmentBottomSheet extends StatefulWidget {
  final AttatchmentModel? attachmentData;
  final bool isArabic;
  final String projectId;
  final String partId;
  final String safeId;

  const SafeAndSecurityAttachmentBottomSheet({
    super.key,
    required this.attachmentData,
    required this.isArabic,
    required this.projectId,
    required this.partId,
    required this.safeId,
  });

  @override
  State<SafeAndSecurityAttachmentBottomSheet> createState() =>
      _SafeAndSecurityAttachmentBottomSheetState();
}

class _SafeAndSecurityAttachmentBottomSheetState
    extends State<SafeAndSecurityAttachmentBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Add attachment state
  bool _showAddForm = false;
  File? _selectedFile;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _fileDescController = TextEditingController();

  static const Color _green1 = Color(0xFF16A34A);
  static const Color _green2 = Color(0xFF059669);
  static const Color _green3 = Color(0xFF34D399);

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

  Future<void> _refreshAttachments() async {
    final provider =
        Provider.of<SafeAndSecurityProvider>(context, listen: false);
    await provider.getSafeAndSecurityDetailsAttachment(
      projectId: widget.projectId,
      partId: widget.partId,
      safeId: widget.safeId,
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedImage = null;
        });
      }
    } catch (e) {
      _showError(widget.isArabic ? 'فشل اختيار الملف: $e' : 'Failed to pick file: $e');
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
          _selectedFile = null;
        });
      }
    } catch (e) {
      _showError(widget.isArabic ? 'فشل اختيار الصورة: $e' : 'Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.isArabic ? 'اختر المصدر' : 'Select Source',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSourceOption(
              icon: Icons.camera_alt,
              label: widget.isArabic ? 'الكاميرا' : 'Camera',
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
            _buildSourceOption(
              icon: Icons.photo_library,
              label: widget.isArabic ? 'المعرض' : 'Gallery',
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _green1.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _green1, size: 22),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAttachment() async {
    if (_selectedFile == null && _selectedImage == null) {
      _showWarning(
        widget.isArabic
            ? 'يرجى اختيار ملف أو صورة أولاً'
            : 'Please select a file or image first',
      );
      return;
    }
    if (_fileDescController.text.trim().isEmpty) {
      _showWarning(
        widget.isArabic ? 'يرجى إدخال وصف المرفق' : 'Please enter file description',
      );
      return;
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
              const CircularProgressIndicator(color: _green1),
              const SizedBox(height: 16),
              Text(
                widget.isArabic ? 'جاري رفع المرفق...' : 'Uploading attachment...',
                style: TextStyle(color: Colors.grey[800], fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final File fileToUpload = _selectedImage ?? _selectedFile!;
      final bytes = await fileToUpload.readAsBytes();
      final base64String = base64Encode(bytes);

      final provider =
          Provider.of<SafeAndSecurityProvider>(context, listen: false);
      await provider.uploadSafeAndSecurityAttachment(
        projectId: widget.projectId,
        partId: widget.partId,
        safeId: widget.safeId,
        fileDesc: _fileDescController.text.trim(),
        fileContent: base64String,
      );

      if (mounted) Navigator.of(context).pop(); // close loading

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic ? 'تم رفع المرفق بنجاح' : 'Attachment uploaded successfully',
            ),
            backgroundColor: _green1,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      await _refreshAttachments();
      if (mounted) {
        setState(() {
          _showAddForm = false;
          _selectedFile = null;
          _selectedImage = null;
          _fileDescController.clear();
        });
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      String errorMsg = e.toString();
      if (errorMsg.contains('Body:')) {
        errorMsg = errorMsg.substring(errorMsg.indexOf('Body:') + 6).trim();
      } else if (errorMsg.contains('Exception:')) {
        errorMsg = errorMsg.replaceAll('Exception:', '').trim();
      }
      _showError(
        widget.isArabic ? 'خطأ: $errorMsg' : 'Error: $errorMsg',
        duration: 5,
      );
    }
  }

  void _showError(String message, {int duration = 3}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
      ),
    );
  }

  void _showWarning(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- file helpers ---
  String _getFileExtension(String? docPath) {
    if (docPath == null || docPath.isEmpty) return '';
    final parts = docPath.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool _isImageFile(String ext) =>
      ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);

  bool _isPdfFile(String ext) => ext == 'pdf';

  bool _isExcelFile(String ext) =>
      ['xls', 'xlsx', 'xlsm'].contains(ext);

  IconData _getFileIcon(String ext) {
    if (_isImageFile(ext)) return Icons.image;
    if (_isPdfFile(ext)) return Icons.picture_as_pdf;
    if (_isExcelFile(ext)) return Icons.table_chart;
    return Icons.insert_drive_file;
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
                    ],
                  ),
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
      _showError(
        widget.isArabic ? 'فشل فتح الرابط: $e' : 'Failed to open link: $e',
      );
    }
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Color(0xFF16A34A),
      Color(0xFF059669),
      Color(0xFF0891B2),
      Color(0xFF7C3AED),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SafeAndSecurityProvider>(
      builder: (context, provider, child) {
        final items =
            provider.attachmentModel?.items ??
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
                      // Header
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [_green1, _green2, _green3],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.attach_file,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                widget.isArabic ? 'المرفقات' : 'Attachments',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Toggle add form
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _showAddForm = !_showAddForm),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _showAddForm ? Icons.close : Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close, color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      // Animated Add Form
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _showAddForm
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox.shrink(),
                        secondChild: _buildAddForm(),
                      ),

                      // Content
                      Flexible(
                        child: provider.isLoading
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(48),
                                  child: CircularProgressIndicator(
                                    color: _green1,
                                  ),
                                ),
                              )
                            : items.isEmpty
                            ? _buildEmptyState()
                            : _buildAttachmentsList(items),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddForm() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _green1.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File/Image preview
          if (_selectedImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImage!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (_selectedFile != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _green1.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file, color: _green1, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedFile!.path.split('/').last,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Description field
          TextField(
            controller: _fileDescController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: widget.isArabic ? 'وصف المرفق' : 'File Description',
              hintText: widget.isArabic
                  ? 'أدخل وصف المرفق...'
                  : 'Enter file description...',
              prefixIcon: const Icon(Icons.description_outlined, color: _green1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _green1, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Action buttons row
          Row(
            children: [
              Expanded(
                child: _buildFormButton(
                  icon: Icons.upload_file,
                  label: widget.isArabic ? 'ملف' : 'File',
                  color: const Color(0xFF4F46E5),
                  onPressed: _pickFile,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFormButton(
                  icon: Icons.image,
                  label: widget.isArabic ? 'صورة' : 'Image',
                  color: const Color(0xFF7C3AED),
                  onPressed: _showImageSourceDialog,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildFormButton(
                  icon: Icons.cloud_upload,
                  label: widget.isArabic ? 'رفع المرفق' : 'Upload',
                  color: _green1,
                  onPressed: _uploadAttachment,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFormButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _green1.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            Text(
              widget.isArabic ? 'لا توجد مرفقات' : 'No attachments',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isArabic
                  ? 'اضغط على + لإضافة مرفق جديد'
                  : 'Tap + to add a new attachment',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsList(List<Items> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildAttachmentCard(item, index);
      },
    );
  }

  Widget _buildAttachmentCard(Items item, int index) {
    final enclosureLink = item.links?.firstWhere(
      (link) => link.rel == 'enclosure',
      orElse: () => Links(),
    );
    final hasDownloadLink =
        enclosureLink?.href != null && enclosureLink!.href!.isNotEmpty;
    final extension = _getFileExtension(item.docPath);

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
            color: _getColorForIndex(index).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _getColorForIndex(index), width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getColorForIndex(index).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getFileIcon(extension),
                        color: _getColorForIndex(index),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isArabic ? 'مرفق رقم' : 'Attachment',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '#${item.docSerial ?? '-'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: _getColorForIndex(index).withOpacity(0.15)),
                const SizedBox(height: 8),

                // Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.description, size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.fileDesc ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                // Image preview
                if (item.photo64 != null && item.photo64!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => _showFullscreenFile(item),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: _buildFilePreview(item, extension),
                    ),
                  ),
                ],

                // Download button
                if (hasDownloadLink) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _downloadAttachment(enclosureLink.href!),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getColorForIndex(index),
                                _getColorForIndex(index).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.isArabic ? 'تحميل المرفق' : 'Download',
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

  Widget _buildFilePreview(Items item, String extension) {
    try {
      final imageBytes = base64Decode(item.photo64!);
      return Stack(
        children: [
          Image.memory(
            imageBytes,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFileIconPreview(extension),
          ),
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
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fullscreen, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    widget.isArabic
                        ? 'اضغط للعرض بملء الشاشة'
                        : 'Tap to view fullscreen',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } catch (_) {
      return _buildFileIconPreview(extension);
    }
  }

  Widget _buildFileIconPreview(String extension) {
    return Container(
      height: 120,
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getFileIcon(extension), size: 60, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            extension.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
