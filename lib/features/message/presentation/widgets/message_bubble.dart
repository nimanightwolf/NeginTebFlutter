import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  const MessageBubble({super.key, required this.msg});

  String? _extractUrl(String text) {
    final t = text.trim();
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    return null;
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMe = msg.isMe;
    final theme = Theme.of(context);

    final bubbleColor = isMe ? const Color(0xFF4CAF50) : const Color(0xFFE8F5E9);
    final textColor   = isMe ? Colors.white : Colors.black87;
    final metaColor   = textColor.withOpacity(isMe ? 0.9 : 0.7);

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMe ? 16 : 8),
      bottomRight: Radius.circular(isMe ? 8 : 16),
    );

    final meta = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(msg.date, style: theme.textTheme.bodySmall?.copyWith(color: metaColor)),
        const SizedBox(width: 6),
        Text(msg.time, style: theme.textTheme.bodySmall?.copyWith(color: metaColor)),
      ],
    );

    Widget content;
    if (msg.isPdf) {
      final link = _extractUrl(msg.text);
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              link != null ? 'باز کردن فایل PDF' : (msg.text.isEmpty ? 'فایل PDF' : msg.text),
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textDirection: TextDirection.rtl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );

      if (link != null) {
        content = InkWell(onTap: () => _openUrl(link), child: content);
      }
    } else {
      final link = _extractUrl(msg.text);
      final textWidget = Text(
        msg.text,
        style: theme.textTheme.titleMedium?.copyWith(color: textColor, height: 1.4),
        textDirection: TextDirection.rtl,
      );
      content = (link != null)
          ? InkWell(onTap: () => _openUrl(link), child: textWidget)
          : textWidget;
    }

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          content,
          const SizedBox(height: 8),
          meta,
        ],
      ),
    );

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe) ...[
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFF66BB6A),
            child: Icon(Icons.support_agent, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
        ],
        bubble,
        if (isMe) const SizedBox(width: 8),
      ],
    );
  }
}
