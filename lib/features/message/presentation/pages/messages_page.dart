import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../message_provider.dart';
import '../widgets/message_bubble.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _txtCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // پس از اولین فریم، پیام‌ها را بگیر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageProvider>().readMessages().then((_) => _scrollToBottom());
    });
  }

  @override
  void dispose() {
    _txtCtrl.dispose();
    _focusNode.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.animateTo(
      _scrollCtrl.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _onRefresh() async {
    await context.read<MessageProvider>().readMessages();
    _scrollToBottom();
  }

  Future<void> _send() async {
    final text = _txtCtrl.text.trim();
    if (text.isEmpty) return;

    final ok = await context.read<MessageProvider>().sendMessage(text);
    if (ok) {
      _txtCtrl.clear();
      _focusNode.requestFocus();
      // کمی تاخیر تا لیست رندر شود
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ارسال پیام ناموفق بود')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MessageProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('پیام‌ها', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (p.isLoading)
              const LinearProgressIndicator(minHeight: 2),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemCount: p.items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == p.items.length) {
                      return const SizedBox(height: 80); // فاصله‌ی پایین برای ورودی
                    }
                    final msg = p.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: MessageBubble(msg: msg),
                    );
                  },
                ),
              ),
            ),

            // خط نازک جداکننده
            Container(height: 1, color: theme.dividerColor),

            // نوار ارسال
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    // دکمه ارسال
                    SizedBox(
                      width: 56,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: p.isSending ? null : _send,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.zero,
                        ),
                        child: p.isSending
                            ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // فیلد متن
                    Expanded(
                      child: TextField(
                        controller: _txtCtrl,
                        focusNode: _focusNode,
                        textDirection: TextDirection.rtl,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'پیام خود را بنویسید...',
                          hintTextDirection: TextDirection.rtl,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.colorScheme.outline),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
