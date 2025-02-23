import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:luping/models/pronunciation_assessment_result.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecordingState { idle, recording, stopped }

class PronunciationAssessmentService {
  static final logger = Logger();

  static final PronunciationAssessmentService _instance =
      PronunciationAssessmentService._internal();
  factory PronunciationAssessmentService() => _instance;
  PronunciationAssessmentService._internal();

  final _assessmentResultSubject =
      BehaviorSubject<PronunciationAssessmentResult?>();
  Stream<PronunciationAssessmentResult?> get assessmentResultStream =>
      _assessmentResultSubject.stream;

  PronunciationAssessmentResult? get currentAssessmentResult =>
      _assessmentResultSubject.value;

  final _recordingStateSubject =
      BehaviorSubject<RecordingState>.seeded(RecordingState.idle); // State
  Stream<RecordingState> get recordingStateStream =>
      _recordingStateSubject.stream;

  FlutterSoundRecorder? _audioRecorder;
  String? _filePath;

  Future<void> _initRecorder() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
    _audioRecorder!.setSubscriptionDuration(
        const Duration(milliseconds: 100)); // Update state periodically
  }

  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    if (_audioRecorder == null) {
      await _initRecorder();
    }

    // Clean up any existing temp files
    await _cleanupTempFile();

    // Get app documents directory
    final directory = await getApplicationDocumentsDirectory();
    final tempAudioDir = Directory('${directory.path}/temp-audio');

    // Ensure the directory exists
    if (!(await tempAudioDir.exists())) {
      await tempAudioDir.create(recursive: true);
    }

    _filePath = '${tempAudioDir.path}/recording.wav';

    await _audioRecorder!.startRecorder(
      toFile: _filePath,
      codec: Codec.pcm16WAV,
      sampleRate: 16000,
      numChannels: 1,
    );

    _recordingStateSubject
        .add(RecordingState.recording); // Update recording state
  }

  Future<void> stopRecording() async {
    await _audioRecorder?.stopRecorder();
    logger.d('Recording stopped, audio file: $_filePath');
    _recordingStateSubject
        .add(RecordingState.stopped); // Update recording state
  }

  Future<void> _cleanupTempFile() async {
    if (_filePath != null) {
      try {
        final file = File(_filePath!);
        if (await file.exists()) {
          await file.delete();
          logger.d('Temporary audio file cleaned up: $_filePath');
        }
      } catch (e) {
        logger.e('Error cleaning up temporary audio file: $e');
      } finally {
        _filePath = null;
      }
    }
  }

  Future<PronunciationAssessmentResult?> fetchAssessment(
      {required String text}) async {
    if (_filePath == null) {
      logger.e("No recording to assess.");
      return null;
    }

    final serverBaseUrl = dotenv.env['SERVER_BASE_URL'] ?? '';
    final url = Uri.parse("$serverBaseUrl/pronunciation-assessment");

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['text'] = text;
      request.files.add(await http.MultipartFile.fromPath('audio', _filePath!));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Clean up the temp file after sending the request
      await _cleanupTempFile();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final assessmentResult =
            PronunciationAssessmentResult.fromJson(jsonResponse);
        _assessmentResultSubject.add(assessmentResult);
        return assessmentResult;
      } else {
        logger.e(
            "Error: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}");
        _assessmentResultSubject.addError(
            "Error: ${response.statusCode}"); // Add error to the stream
        return null;
      }
    } catch (e) {
      // Ensure cleanup happens even if request fails
      await _cleanupTempFile();
      logger.e("Error sending request: $e");
      _assessmentResultSubject
          .addError(e.toString()); // Add error to the stream
      return null;
    }
  }

  void dispose() {
    _audioRecorder?.closeRecorder();
    _audioRecorder = null;
    _assessmentResultSubject.close();
    _recordingStateSubject.close(); // Close the recording state stream
    _filePath = null;
  }

  Future<void> cleanup() async {
    if (_recordingStateSubject.value == RecordingState.recording) {
      await stopRecording();
    }
    dispose();
  }

  void resetAssessment() {
    _assessmentResultSubject.add(null); // Đặt kết quả về null để reset UI
  }
}
