// AI-ASSISTED: หน้า Add Song - ฟอร์มเพิ่มเพลงใหม่
import 'package:flutter/material.dart';
import '../modal/song.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // AI-ASSISTED: Validation สำหรับ duration format MM:SS
  String? _validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter duration';
    }
    final regex = RegExp(r'^\d{2}:\d{2}$');
    if (!regex.hasMatch(value)) {
      return 'Format must be MM:SS (e.g., 03:45)';
    }
    final parts = value.split(':');
    final minutes = int.tryParse(parts[0]);
    final seconds = int.tryParse(parts[1]);
    if (minutes == null || seconds == null || seconds >= 60) {
      return 'Invalid time format';
    }
    if (minutes == 0 && seconds == 0) {
      return 'Duration must be greater than 0';
    }
    return null;
  }

  void _saveSong() {
    if (_formKey.currentState!.validate()) {
      final newSong = Song(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        artist: _artistController.text,
        duration: _durationController.text,
        imageUrl:
            'https://picsum.photos/200/200?random=${DateTime.now().millisecondsSinceEpoch}',
      );
      Navigator.pop(context, newSong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B33FF), Color(0xFF6B1FE0)],
            stops: [0.0, 0.15],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AI-ASSISTED: Custom AppBar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Add New Song',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(30),
                      children: [
                        const SizedBox(height: 10),
                        // Music Icon
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B33FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.music_note_rounded,
                              size: 60,
                              color: Color(0xFF8B33FF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // AI-ASSISTED: Form Field 1 - ชื่อเพลง
                        const Text(
                          'ชื่อเพลง',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Enter song title',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter song title';
                            }
                            if (value.length < 2) {
                              return 'Title must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // AI-ASSISTED: Form Field 2 - ชื่อศิลปิน
                        const Text(
                          'ชื่อศิลปิน',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _artistController,
                          decoration: InputDecoration(
                            hintText: 'Enter artist name',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter artist name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // AI-ASSISTED: Form Field 3 - ระยะเวลา
                        const Text(
                          'ระยะเวลา (MM:SS)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _durationController,
                          decoration: InputDecoration(
                            hintText: '03:45',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          validator: _validateDuration,
                        ),
                        const SizedBox(height: 40),
                        // AI-ASSISTED: Save Button with Animation
                        AnimatedSaveButton(onPressed: _saveSong),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AI-ASSISTED: Animated Save Button Component
class AnimatedSaveButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedSaveButton({super.key, required this.onPressed});

  @override
  State<AnimatedSaveButton> createState() => _AnimatedSaveButtonState();
}

class _AnimatedSaveButtonState extends State<AnimatedSaveButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B33FF),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Save Song',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
