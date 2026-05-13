import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton audio service with separate music and sound-effects volumes.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _musicPlayer;
  AudioPlayer? _soundPlayer;

  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _musicVolume = 0.5;
  double _soundVolume = 0.5;
  bool _initialized = false;

  bool _userInteracted = false;
  bool _pendingMusicStart = false;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  double get musicVolume => _musicVolume;
  double get soundVolume => _soundVolume;

  // kept for backward-compat with any code that reads .volume
  double get volume => _musicVolume;

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _soundEnabled   = prefs.getBool('sound_enabled')   ?? true;
      _musicEnabled   = prefs.getBool('music_enabled')   ?? true;
      _musicVolume    = prefs.getDouble('music_volume')  ?? 0.5;
      _soundVolume    = prefs.getDouble('sound_volume')  ?? 0.5;

      _musicPlayer = AudioPlayer();
      _soundPlayer = AudioPlayer();

      await _musicPlayer!.setVolume(_musicVolume);
      await _soundPlayer!.setVolume(_soundVolume);

      _initialized = true;
      debugPrint('AudioService initialized');
    } catch (e) {
      debugPrint('AudioService init error: $e');
    }
  }

  // ── Web autoplay gate ─────────────────────────────────────────────────────

  Future<void> onUserInteraction() async {
    if (_userInteracted) return;
    _userInteracted = true;
    if (_pendingMusicStart) {
      _pendingMusicStart = false;
      await playBackgroundMusic();
    }
  }

  // ── Background music ──────────────────────────────────────────────────────

  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled || _musicPlayer == null) return;
    if (kIsWeb && !_userInteracted) {
      _pendingMusicStart = true;
      return;
    }
    try {
      await _musicPlayer!.setVolume(_musicVolume);
      await _musicPlayer!.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer!.play(AssetSource('audio/background_music.mp3'));
    } catch (e) {
      debugPrint('AudioService: background music failed – $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    _pendingMusicStart = false;
    try { await _musicPlayer?.stop(); } catch (_) {}
  }

  Future<void> pauseBackgroundMusic() async {
    try { await _musicPlayer?.pause(); } catch (_) {}
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_musicEnabled) return;
    try {
      await _musicPlayer?.resume();
    } catch (_) {
      await playBackgroundMusic();
    }
  }

  // ── Sound effects ─────────────────────────────────────────────────────────

  Future<void> _playSound(String fileName) async {
    if (!_soundEnabled || _soundPlayer == null) return;
    try {
      await _soundPlayer!.stop();
      await _soundPlayer!.setVolume(_soundVolume);
      await _soundPlayer!.play(AssetSource('audio/$fileName'));
    } catch (e) {
      debugPrint('AudioService: $fileName failed – $e');
    }
  }

  Future<void> playCorrectSound()     async => _playSound('correct.mp3');
  Future<void> playWrongSound()       async => _playSound('wrong.mp3');
  Future<void> playClickSound()       async => _playSound('click.mp3');
  Future<void> playCelebrationSound() async => _playSound('celebration.mp3');

  // ── Settings ──────────────────────────────────────────────────────────────

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _saveBool('sound_enabled', enabled);
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    await _saveBool('music_enabled', enabled);
    if (!enabled) {
      await stopBackgroundMusic();
    } else {
      await playBackgroundMusic();
    }
  }

  Future<void> setMusicVolume(double vol) async {
    _musicVolume = vol;
    await _musicPlayer?.setVolume(vol);
    await _saveDouble('music_volume', vol);
  }

  Future<void> setSoundVolume(double vol) async {
    _soundVolume = vol;
    await _soundPlayer?.setVolume(vol);
    await _saveDouble('sound_volume', vol);
  }

  // Legacy single-volume setter — sets both
  Future<void> setVolume(double vol) async {
    await setMusicVolume(vol);
    await setSoundVolume(vol);
  }

  Future<void> resetSettings() async {
    _soundEnabled = true;
    _musicEnabled = true;
    _musicVolume  = 0.5;
    _soundVolume  = 0.5;
    await _musicPlayer?.setVolume(0.5);
    await _soundPlayer?.setVolume(0.5);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_enabled', true);
      await prefs.setBool('music_enabled', true);
      await prefs.setDouble('music_volume', 0.5);
      await prefs.setDouble('sound_volume', 0.5);
    } catch (e) {
      debugPrint('AudioService: resetSettings error – $e');
    }
  }

  Future<void> _saveBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (_) {}
  }

  Future<void> _saveDouble(String key, double value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, value);
    } catch (_) {}
  }

  void dispose() {
    _musicPlayer?.dispose();
    _soundPlayer?.dispose();
    _musicPlayer = null;
    _soundPlayer = null;
    _initialized = false;
  }
}
