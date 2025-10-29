class ChatMessage {
  final String id;
  final String text;
  final bool isMe;       // بر اساس sender
  final String date;     // مثل "98/5/18" یا "04/8/6"
  final String time;     // از "hour"
  final bool isPdf;      // از "pdf" = "1"
  final String sender;   // "1" = شرکت (incoming), "2" = کاربر (me)
  final bool seen;       // نرمال‌شده از 0/1/true/false/ "0"/"1"
  final int timestamp;   // از فیلد کلیدی "3" (epoch seconds)
  final String? pdfUrl;  // اگر pdf == 1، آدرس داخل text می‌آید

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.date,
    required this.time,
    required this.isPdf,
    required this.sender,
    required this.seen,
    required this.timestamp,
    this.pdfUrl,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j, {int index = 0}) {
    String s(dynamic v) => (v ?? '').toString().trim();

    bool toBoolLike(dynamic v) {
      if (v is bool) return v;
      final sv = s(v);
      if (sv.isEmpty) return false;
      return sv == '1' || sv.toLowerCase() == 'true';
    }

    // نکته: در دیتای legacy، "3" = epoch seconds
    final rawTs = s(j['3']);
    final ts = int.tryParse(rawTs) ?? 0;

    final senderRaw = s(j['sender']);   // "1" یا "2"
    final isMe = senderRaw != '1';      // 1=شرکت → me=false

    final seen = toBoolLike(j['seen']);
    final pdf = s(j['pdf']) == '1';

    final id = s(j['id_message']).isNotEmpty ? s(j['id_message']) : 'm_$index';
    final text = s(j['text']);

    // اگر pdf==1 و text خالی نبود، همون text لینک PDF است
    final String? pdfUrl = pdf && text.isNotEmpty ? text : null;

    return ChatMessage(
      id: id,
      text: text,
      isMe: isMe,
      date: s(j['date']),
      time: s(j['hour']),
      isPdf: pdf,
      sender: senderRaw,
      seen: seen,
      timestamp: ts,
      pdfUrl: pdfUrl,
    );
  }
}
