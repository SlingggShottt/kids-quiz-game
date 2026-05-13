import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioService _audio = AudioService();

  late bool   _soundEnabled;
  late bool   _musicEnabled;
  late double _musicVolume;
  late double _soundVolume;

  static const _green  = Color(0xFF38EF7D);
  static const _red    = Color(0xFFFF6B6B);

  @override
  void initState() {
    super.initState();
    _soundEnabled = _audio.soundEnabled;
    _musicEnabled = _audio.musicEnabled;
    _musicVolume  = _audio.musicVolume;
    _soundVolume  = _audio.soundVolume;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF11998E), _green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildCard()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _audio.playClickSound();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            ),
          ),
          const Expanded(
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  // ── White card ────────────────────────────────────────────────────────────

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // Scrollable so nothing clips on very small screens
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sound effects toggle ──────────────────────────────────
              _buildToggleRow(
                icon: Icons.volume_up,
                title: 'Sound Effects',
                value: _soundEnabled,
                onChanged: (v) async {
                  setState(() => _soundEnabled = v);
                  await _audio.setSoundEnabled(v);
                  if (v) _audio.playClickSound();
                },
              ),

              // ── Sound effects volume slider ───────────────────────────
              AnimatedCrossFade(
                firstChild: _buildVolumeSlider(
                  icon: Icons.volume_up_outlined,
                  label: 'SFX Volume',
                  value: _soundVolume,
                  onChanged: (v) async {
                    setState(() => _soundVolume = v);
                    await _audio.setSoundVolume(v);
                  },
                ),
                secondChild: const SizedBox.shrink(),
                crossFadeState: _soundEnabled
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 250),
              ),

              const Divider(height: 28),

              // ── Background music toggle ───────────────────────────────
              _buildToggleRow(
                icon: Icons.music_note,
                title: 'Background Music',
                value: _musicEnabled,
                onChanged: (v) async {
                  setState(() => _musicEnabled = v);
                  await _audio.setMusicEnabled(v);
                },
              ),

              // ── Music volume slider ───────────────────────────────────
              AnimatedCrossFade(
                firstChild: _buildVolumeSlider(
                  icon: Icons.music_note_outlined,
                  label: 'Music Volume',
                  value: _musicVolume,
                  onChanged: (v) async {
                    setState(() => _musicVolume = v);
                    await _audio.setMusicVolume(v);
                  },
                ),
                secondChild: const SizedBox.shrink(),
                crossFadeState: _musicEnabled
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 250),
              ),

              const SizedBox(height: 12),
              const Divider(height: 12),
              const SizedBox(height: 12),

              // ── Reset button ──────────────────────────────────────────
              _buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Toggle row ────────────────────────────────────────────────────────────

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _green, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Switch(
          value: value,
          activeColor: _green,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ── Volume slider ─────────────────────────────────────────────────────────

  Widget _buildVolumeSlider({
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          // Left icon (quiet)
          const Icon(Icons.volume_mute, color: Colors.grey, size: 18),
          // Slider fills remaining space
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _green,
                inactiveTrackColor: _green.withOpacity(0.2),
                thumbColor: _green,
                overlayColor: _green.withOpacity(0.15),
                trackHeight: 4,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10),
              ),
              child: Slider(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
          // Right icon (loud)
          Icon(icon, color: _green, size: 18),
          const SizedBox(width: 8),
          // Percentage label
          SizedBox(
            width: 36,
            child: Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ── Reset button ──────────────────────────────────────────────────────────

  Widget _buildResetButton() {
    return GestureDetector(
      onTap: () async {
        _audio.playClickSound();
        await _audio.resetSettings();
        setState(() {
          _soundEnabled = true;
          _musicEnabled = true;
          _musicVolume  = 0.5;
          _soundVolume  = 0.5;
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Settings reset to default!'),
              backgroundColor: _green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _red.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, color: Colors.white, size: 22),
            SizedBox(width: 10),
            Text(
              'Reset All Settings',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
