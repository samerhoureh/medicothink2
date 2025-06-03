import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../models/chat_message.dart';
import '../../services/notification_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final Record _audioRecorder = Record();
  final ImagePicker _imagePicker = ImagePicker();
  
  List<ChatMessage> _messages = [];
  bool _isRecording = false;
  String? _currentRecordingPath;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _audioRecorder.hasPermission();
    // Add other permission requests as needed
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _currentRecordingPath = '${directory.path}/audio_message_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(path: _currentRecordingPath);
        setState(() => _isRecording = true);
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      
      if (path != null) {
        // Here you would typically upload the file and get a URL
        _addMessage(
          ChatMessage(
            id: DateTime.now().toString(),
            content: 'Voice Message',
            isMe: true,
            type: MessageType.voice,
            timestamp: DateTime.now(),
            mediaUrl: path,
          ),
        );
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Here you would typically upload the file and get a URL
        _addMessage(
          ChatMessage(
            id: DateTime.now().toString(),
            content: 'Image Message',
            isMe: true,
            type: MessageType.image,
            timestamp: DateTime.now(),
            mediaUrl: image.path,
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _showReminderDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime reminderDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Show dialog for reminder details
        _showReminderDetailsDialog(reminderDateTime);
      }
    }
  }

  void _showReminderDetailsDialog(DateTime dateTime) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final reminder = ReminderData(
                title: titleController.text,
                description: descriptionController.text,
                dateTime: dateTime,
              );
              
              NotificationService.instance.scheduleReminder(reminder);
              
              _addMessage(
                ChatMessage(
                  id: DateTime.now().toString(),
                  content: 'Reminder: ${reminder.title}',
                  isMe: true,
                  type: MessageType.reminder,
                  timestamp: DateTime.now(),
                  reminder: reminder,
                ),
              );
              
              Navigator.pop(context);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showReminderDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _MessageBubble(message: msg);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.mic),
            onPressed: _isRecording ? _stopRecording : _startRecording,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: _textCtrl,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;

    _addMessage(
      ChatMessage(
        id: DateTime.now().toString(),
        content: text,
        isMe: true,
        type: MessageType.text,
        timestamp: DateTime.now(),
      ),
    );
    _textCtrl.clear();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isMe ? kTeal : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildMessageContent(),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.voice:
        return _buildVoiceMessage();
      case MessageType.image:
        return _buildImageMessage();
      case MessageType.reminder:
        return _buildReminderMessage();
      default:
        return Text(
          message.content,
          style: TextStyle(
            color: message.isMe ? Colors.white : Colors.black87,
          ),
        );
    }
  }

  Widget _buildVoiceMessage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            // Implement audio playback
          },
        ),
        const SizedBox(width: 8),
        const Text('Voice Message'),
      ],
    );
  }

  Widget _buildImageMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.mediaUrl != null)
          Image.file(
            File(message.mediaUrl!),
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

  Widget _buildReminderMessage() {
    final reminder = message.reminder;
    if (reminder == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reminder.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(reminder.description),
        Text(
          'Scheduled for: ${reminder.dateTime.toString()}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}