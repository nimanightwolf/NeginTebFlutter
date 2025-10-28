class ChatMessage {
  final String id;
  final String text;
  final bool isMe;       // بر اساس فیلد sender
  final String date;     // مثل "98/5/18"
  final String time;     // از "hour"
  final bool isPdf;      // از "pdf" = "1" یعنی پی‌دی‌اف

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.date,
    required this.time,
    required this.isPdf,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j, {int index = 0}) {
    String s(dynamic v) => (v ?? '').toString().trim();

    // نکته: طبق تجربه‌ی نسخه‌ی قدیمی، sender=="1" پیامِ «شرکت» است (سمت چپ) ⇒ isMe=false
    // و هر چیزی غیر از 1، پیام کاربر است ⇒ isMe=true.
    final sender = s(j['sender']);
    final bool me = sender != '1';

    return ChatMessage(
      id: s(j['id_message']).isNotEmpty ? s(j['id_message']) : 'm_$index',
      text: s(j['text']),
      isMe: me,
      date: s(j['date']),
      time: s(j['hour']),
      isPdf: s(j['pdf']) == '1',
    );
  }
}
