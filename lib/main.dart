// AI-ASSISTED: ไฟล์หลักของแอป FREEHAND Music Player
import 'package:flutter/material.dart';
import 'modal/song.dart';
import 'pages/onboarding_page.dart';
import 'pages/library_page.dart';
import 'pages/playlist_page.dart';
import 'pages/add_song_page.dart';

void main() {
  runApp(const MyMusicApp());
}

class MyMusicApp extends StatefulWidget {
  const MyMusicApp({super.key});

  @override
  State<MyMusicApp> createState() => _MyMusicAppState();
}

class _MyMusicAppState extends State<MyMusicApp> {
  bool isDarkMode = false;
  bool showOnboarding = true; // Show onboarding on first launch

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void completeOnboarding() {
    setState(() {
      showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FREEHAND Music',
      debugShowCheckedModeBanner: false,
      // AI-ASSISTED: Theme configuration
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF8B33FF),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF8B33FF),
          secondary: Color(0xFFB366FF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B33FF),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF8B33FF),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B33FF),
          secondary: Color(0xFFB366FF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B33FF),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: showOnboarding
          ? OnboardingPage(onComplete: completeOnboarding)
          : MainScreen(isDarkMode: isDarkMode, onToggleTheme: toggleTheme),
    );
  }
}

// AI-ASSISTED: Main Screen with Bottom Navigation
class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // AI-ASSISTED: ข้อมูลตัวอย่างเพลง
  List<Song> songs = [
    Song(
      id: '1',
      title: 'ใกลกว่าดาว',
      artist: 'FREEHAND',
      duration: '04:25',
      imageUrl: 'https://picsum.photos/200/200?random=1',
    ),
    Song(
      id: '2',
      title: 'เสียงของลม',
      artist: 'FREEHAND',
      duration: '03:58',
      imageUrl: 'https://picsum.photos/200/200?random=2',
    ),
    Song(
      id: '3',
      title: 'ชายไร้เสียง',
      artist: 'FREEHAND',
      duration: '04:45',
      imageUrl: 'https://picsum.photos/200/200?random=3',
    ),
    Song(
      id: '4',
      title: 'รสพวาน',
      artist: 'FREEHAND',
      duration: '03:32',
      imageUrl: 'https://picsum.photos/200/200?random=4',
    ),
    Song(
      id: '5',
      title: 'คุก',
      artist: 'FREEHAND',
      duration: '05:15',
      imageUrl: 'https://picsum.photos/200/200?random=5',
    ),
  ];

  String searchQuery = '';

  void addSong(Song song) {
    setState(() {
      songs.add(song);
    });
  }

  void deleteSong(String id) {
    setState(() {
      songs.removeWhere((song) => song.id == id);
    });
  }

  void toggleFavorite(String id) {
    setState(() {
      final song = songs.firstWhere((s) => s.id == id);
      song.isFavorite = !song.isFavorite;
    });
  }

  List<Song> get filteredSongs {
    if (searchQuery.isEmpty) {
      return songs;
    }
    return songs.where((song) {
      return song.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          song.artist.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  List<Song> get favoriteSongs {
    return songs.where((s) => s.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? LibraryPage(
              songs: filteredSongs,
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onDelete: deleteSong,
              onToggleFavorite: toggleFavorite,
            )
          : PlaylistPage(
              songs: favoriteSongs,
              onDelete: (id) {
                toggleFavorite(id);
                setState(() {});
              },
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final favSongs = favoriteSongs;
                  final item = favSongs.removeAt(oldIndex);
                  favSongs.insert(newIndex, item);
                });
              },
            ),
      // AI-ASSISTED: Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF8B33FF),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              activeIcon: Icon(Icons.library_music),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Playlist',
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? _AnimatedFAB(
              onPressed: () async {
                final newSong = await Navigator.push<Song>(
                  context,
                  MaterialPageRoute(builder: (context) => const AddSongPage()),
                );
                if (newSong != null) {
                  addSong(newSong);
                }
              },
            )
          : null,
    );
  }
}

// AI-ASSISTED: Animated FAB Component
class _AnimatedFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const _AnimatedFAB({required this.onPressed});

  @override
  State<_AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<_AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF8B33FF),
        onPressed: () {
          _controller.forward().then((_) => _controller.reverse());
          widget.onPressed();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
