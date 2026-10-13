import 'package:flutter/material.dart';

void main() {
  runApp(const BlockGalaxyApp());
}

class BlockGalaxyApp extends StatelessWidget {
  const BlockGalaxyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLOCK GALAXY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int bestScore = 0;

  // Warna balok
  final List<Color?> board = List<Color?>.filled(64, null);

  final List<Color> blockColors = [
    const Color(0xFF35D6FF),
    const Color(0xFFB56CFF),
    const Color(0xFFFFC857),
    const Color(0xFFFF6482),
  ];

  // Bentuk balok dalam grid 3x3.
  // Angka 1 menandakan bagian balok.
  final List<List<List<int>>> blockShapes = [
    [
      [1, 1],
      [1, 1],
    ],
    [
      [1, 0, 0],
      [1, 1, 1],
    ],
    [
      [1, 1, 1],
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF080D28), Color(0xFF171044), Color(0xFF090B20)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              buildHeader(),
              buildScorePanel(),
              const SizedBox(height: 16),
              buildGameBoard(),
              const SizedBox(height: 16),
              buildBlockSelection(),
              const Spacer(),
              buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER GAME
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF25265B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF6E7BFF), width: 1.5),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: Color(0xFF62E5FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BLOCK GALAXY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'PUZZLE THE UNIVERSE',
                  style: TextStyle(
                    color: Color(0xFF929DD9),
                    fontSize: 9,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF20234F),
                  title: const Text(
                    'Pengaturan',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Pengaturan game akan dikembangkan '
                    'pada versi berikutnya.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.settings_rounded,
              color: Colors.white70,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  // PANEL SKOR
  Widget buildScorePanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: buildScoreCard(
              'SCORE',
              score.toString(),
              const Color(0xFF43D9FF),
              Icons.bolt_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: buildScoreCard(
              'BEST SCORE',
              bestScore.toString(),
              const Color(0xFFFFCB69),
              Icons.emoji_events_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScoreCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF20234A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF929DD9),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PAPAN PUZZLE 8 X 8
  Widget buildGameBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFF10152F),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF525CB7), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF625BFF).withValues(alpha: 0.15),
                blurRadius: 22,
                spreadRadius: 2,
              ),
            ],
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 64,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: board[index] ?? const Color(0xFF252A50),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // PILIHAN BALOK
  Widget buildBlockSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF171B3D),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF343B78)),
        ),
        child: Column(
          children: [
            const Text(
              'PILIH BALOK',
              style: TextStyle(
                color: Color(0xFFA9B3EE),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                blockShapes.length,
                (index) =>
                    buildBlockPreview(blockShapes[index], blockColors[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBlockPreview(List<List<int>> shape, Color color) {
    return SizedBox(
      width: 76,
      height: 76,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: shape.map((row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: row.map((cell) {
                return Container(
                  width: 19,
                  height: 19,
                  margin: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    color: cell == 1 ? color : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: cell == 1
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.25),
                              blurRadius: 5,
                            ),
                          ]
                        : null,
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  // TOMBOL BAGIAN BAWAH
  Widget buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  score = 0;
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('RESTART'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF9CA8FF),
                side: const BorderSide(color: Color(0xFF525CB7)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mekanik permainan akan segera hadir!'),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('PLAY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7868FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
