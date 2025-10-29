import 'package:flutter/cupertino.dart';
import '../../../shared/services/api/api_service.dart';
import '../data/models/message_model.dart';

class MessageProvider with ChangeNotifier {
  static const String _epRead = 'read_message';
  static const String _epSend = 'send_message_app';

  final List<ChatMessage> _items = [];
  bool _loading = false;
  bool _sending = false;
  String? _error;

  List<ChatMessage> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;
  bool get isSending => _sending;
  String? get error => _error;

  Future<void> readMessages() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.post(_epRead);
      _items.clear();

      if (res is List) {
        for (var i = 0; i < res.length; i++) {
          final row = Map<String, dynamic>.from(res[i] as Map);
          _items.add(ChatMessage.fromJson(row, index: i));
        }
      } else if (res is Map && res['data'] is List) {
        final list = List.from(res['data']);
        for (var i = 0; i < list.length; i++) {
          final row = Map<String, dynamic>.from(list[i] as Map);
          _items.add(ChatMessage.fromJson(row, index: i));
        }
      } else {
        _error = 'ساختار پاسخ سرور معتبر نیست';
      }
    } catch (e) {
      _error = 'خطا در دریافت پیام‌ها';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage(String text) async {
    final t = text.trim();
    if (_sending || t.isEmpty) return false;

    _sending = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.post(_epSend, data: {'text': t});

      if (res is List) {
        final base = _items.length;
        for (var i = 0; i < res.length; i++) {
          final row = Map<String, dynamic>.from(res[i] as Map);
          _items.add(ChatMessage.fromJson(row, index: base + i));
        }
        notifyListeners();
        return true;
      } else if (res is Map) {
        final status = (res['status']?.toString().toLowerCase() ?? '');
        if (status == 'ok' || status == 'success') {
          await readMessages();
          return true;
        }
        if (res['message'] is Map) {
          final row = Map<String, dynamic>.from(res['message'] as Map);
          _items.add(ChatMessage.fromJson(row, index: _items.length));
          notifyListeners();
          return true;
        }
        await readMessages();
        return true;
      }

      _error = 'پاسخ ارسال پیام نامعتبر بود';
      return false;
    } catch (e) {
      _error = 'خطا در ارسال پیام';
      return false;
    } finally {
      _sending = false;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _error = null;
    notifyListeners();
  }

  // ------------------- NEW: Unread counter -------------------

  /// تعداد پیام‌های خوانده‌نشدهٔ ورودی (incoming).
  /// [incomingSenderCode] کدِ فرستنده‌ی سمت سرور/ادمین است (در دیتای نمونه "1").
  int unreadCount({String incomingSenderCode = '1'}) {
    bool _isSeen(dynamic v) =>
        v == true || v == 1 || v == '1'; // هرچیزی غیر از این، خوانده‌نشده است
    bool _isIncoming(dynamic s) => s?.toString() == incomingSenderCode;

    int c = 0;
    if(items.isEmpty) {
      readMessages();
    }
    for (final m in _items) {
      final seen = _isSeen(m.seen);          // m.seen می‌تونه bool/int/String باشه
      final incoming = _isIncoming(m.sender);
      if (incoming && !seen) c++;
    }
    print(c);
    return c;
  }
}
