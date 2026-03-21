import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';

/// Sala de oração com player de áudio (URLs de demonstração — substitua por CDN própria).
class PrayerRoomScreen extends StatefulWidget {
  const PrayerRoomScreen({super.key});

  @override
  State<PrayerRoomScreen> createState() => _PrayerRoomScreenState();
}

class _PrayerRoomScreenState extends State<PrayerRoomScreen> {
  static final _tracks = <({String title, String artist, String url})>[
    (
      title: 'Atmosfera de Adoração',
      artist: 'Devotion Sounds',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    (
      title: 'Ambiente Celestial',
      artist: 'Refúgio Musical',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    (
      title: 'Som da Chuva',
      artist: 'Atmos Worship',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    ),
    (
      title: 'Piano Devocional',
      artist: 'Calm Spirit Studio',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
  ];

  late final AudioPlayer _player;
  var _idx = 0;
  var _playing = false;
  var _loading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      setState(() => _playing = s == PlayerState.playing);
    });
    _player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _playing = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadAndPlay(int index) async {
    setState(() {
      _idx = index;
      _loading = true;
    });
    try {
      await _player.stop();
      await _player.play(UrlSource(_tracks[index].url));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _togglePlay() async {
    if (_playing) {
      await _player.pause();
    } else {
      if (_position == Duration.zero && _duration == Duration.zero) {
        await _loadAndPlay(_idx);
      } else {
        await _player.resume();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = _tracks[_idx];
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary,
                    scheme.primary.withValues(alpha: 0.88),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            AppLucideUi.bookOpen,
                            color: scheme.onPrimary.withValues(alpha: 0.95),
                            size: 28,
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Text(
                              'Sala de Oração',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: scheme.onPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 16, top: 8),
                        child: Text(
                          'Prepare o ambiente ao seu redor e inicie sua adoração',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: scheme.onPrimary.withValues(alpha: 0.85),
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _tracks.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final sel = i == _idx;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _loadAndPlay(i),
                                borderRadius: BorderRadius.circular(14),
                                child: Ink(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? Colors.white.withValues(alpha: 0.18)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: sel ? 0.35 : 0.1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        sel && _playing
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_fill_rounded,
                                        color: scheme.onPrimary.withValues(alpha: 0.95),
                                        size: 40,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _tracks[i].title,
                                              style: TextStyle(
                                                color: scheme.onPrimary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              _tracks[i].artist,
                                              style: TextStyle(
                                                color: scheme.onPrimary.withValues(alpha: 0.75),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              width: double.infinity,
              color: scheme.surface,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.artist,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.primary.withValues(alpha: 0.65),
                        ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Slider(
                    value: _duration.inMilliseconds > 0
                        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
                        : 0.0,
                    onChanged: (v) async {
                      final ms = (v * _duration.inMilliseconds).round();
                      await _player.seek(Duration(milliseconds: ms));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        iconSize: 56,
                        onPressed: _loading ? null : _togglePlay,
                        icon: _loading
                            ? const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 36,
                              ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'Áudio de demonstração (SoundHelix). Substitua as URLs por faixas licenciadas.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
