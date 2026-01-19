// AI-ASSISTED: หน้า Library - แสดงรายการเพลงทั้งหมด
import 'package:flutter/material.dart';
import '../modal/song.dart';

class LibraryPage extends StatelessWidget {
  final List<Song> songs;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Function(String) onSearchChanged;
  final Function(String) onDelete;
  final Function(String) onToggleFavorite;

  const LibraryPage({
    super.key,
    required this.songs,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onSearchChanged,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8B33FF), Color(0xFF6B1FE0)],
          stops: [0.0, 0.3],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // AI-ASSISTED: Custom AppBar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FREEHAND',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Official Music Library',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: onToggleTheme,
                  ),
                ],
              ),
            ),
            // AI-ASSISTED: Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search songs or artists...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // AI-ASSISTED: Song List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: songs.isEmpty
                    ? const Center(child: Text('No songs found'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 20, bottom: 80),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          // AI-ASSISTED: Dismissible สองทาง - ซ้าย=ลบ, ขวา=โปรด
                          return Dismissible(
                            key: ValueKey(song.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 30),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.green,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 30),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // ปัดขวา - ลบ
                                return await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Song'),
                                    content: Text(
                                      'Delete "${song.title}" from library?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                // ปัดซ้าย - เพิ่มในรายการโปรด
                                onToggleFavorite(song.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      song.isFavorite
                                          ? 'Added to playlist'
                                          : 'Removed from playlist',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: const Color(0xFF8B33FF),
                                  ),
                                );
                                return false;
                              }
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                onDelete(song.id);
                              }
                            },
                            child: SongCard(song: song),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// AI-ASSISTED: Song Card Component
class SongCard extends StatefulWidget {
  final Song song;

  const SongCard({super.key, required this.song});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            // Album Art
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                color: const Color(0xFF8B33FF),
                child: widget.song.imageUrl.startsWith('http')
                    ? Image.network(
                        widget.song.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 30,
                          );
                        },
                      )
                    : const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
            ),
            const SizedBox(width: 15),
            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.song.artist,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Duration
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              child: Text(
                widget.song.duration,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
