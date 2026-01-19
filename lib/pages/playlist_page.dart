// AI-ASSISTED: หน้า Playlist - แสดงเพลงที่ชอบและสามารถจัดลำดับได้
import 'package:flutter/material.dart';
import '../modal/song.dart';

class PlaylistPage extends StatefulWidget {
  final List<Song> songs;
  final Function(int, int) onReorder;
  final Function(String) onDelete;

  const PlaylistPage({
    super.key,
    required this.songs,
    required this.onReorder,
    required this.onDelete,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late List<Song> _songs;

  @override
  void initState() {
    super.initState();
    _songs = List.from(widget.songs);
  }

  @override
  void didUpdateWidget(PlaylistPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _songs = List.from(widget.songs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8B33FF), Color(0xFF6B1FE0)],
          stops: [0.0, 0.2],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // AI-ASSISTED: AppBar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'My Playlist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
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
                child: _songs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.playlist_remove,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No songs in playlist',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Swipe left on songs to add favorites',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    // AI-ASSISTED: ReorderableListView สำหรับจัดลำดับเพลง
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        itemCount: _songs.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final item = _songs.removeAt(oldIndex);
                            _songs.insert(newIndex, item);
                          });
                          widget.onReorder(oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final song = _songs[index];
                          // AI-ASSISTED: Dismissible ใน ReorderableListView
                          return Dismissible(
                            key: ValueKey(song.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 30),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Remove from Playlist'),
                                  content: Text(
                                    'Remove "${song.title}" from your favorites?',
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
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              setState(() {
                                _songs.removeAt(index);
                              });
                              widget.onDelete(song.id);
                            },
                            child: PlaylistSongCard(song: song, index: index),
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

// AI-ASSISTED: Playlist Song Card with drag handle
class PlaylistSongCard extends StatefulWidget {
  final Song song;
  final int index;

  const PlaylistSongCard({super.key, required this.song, required this.index});

  @override
  State<PlaylistSongCard> createState() => _PlaylistSongCardState();
}

class _PlaylistSongCardState extends State<PlaylistSongCard> {
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
