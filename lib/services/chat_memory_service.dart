import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chat_message.dart';

class ChatMemoryService {
  static final ChatMemoryService _instance = ChatMemoryService._internal();
  factory ChatMemoryService() => _instance;
  ChatMemoryService._internal();

  Database? _db;

  Future<void> init() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_memory.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chat_memory (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            content TEXT NOT NULL,
            context TEXT,
            timestamp INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> saveMessage(String userId, String content, List<String> context) async {
    await _db?.insert('chat_memory', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'content': content,
      'context': json.encode(context),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getMessageHistory(String userId, {int limit = 50}) async {
    final messages = await _db?.query(
      'chat_memory',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return messages ?? [];
  }

  Future<void> clearHistory(String userId) async {
    await _db?.delete(
      'chat_memory',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}