import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  /// Mengirim pesan pengguna dan simulasi balasan dari admin
  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'message': message, 'isSeller': false});
    });
    _messageController.clear();

    // Balasan otomatis dari admin
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _messages.add({
        'message':
            'Terima kasih telah menghubungi kami 😊\nJika ingin chat langsung via WhatsApp, silakan klik link berikut:\nhttps://wa.me/6281367226302',
        'isSeller': true,
      });
    });
  }

  /// Meluncurkan WhatsApp menggunakan URL
  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/6281367226302");

    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Tidak berhasil membuka WhatsApp.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka WhatsApp: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(
        showBackArrow: true,
        title: Text(
          'Chat With Seller',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Column(
        children: [
          // Daftar pesan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSeller = message['isSeller'];
                final msgText = message['message'] as String;

                return Align(
                  alignment:
                      isSeller ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSeller
                          ? Theme.of(context).colorScheme.surfaceVariant
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msgText,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        if (msgText.contains('https://wa.me/'))
                          TextButton.icon(
                            onPressed: _openWhatsApp,
                            icon: const Icon(Icons.open_in_new, size: 18),
                            label: const Text('Chat via WhatsApp'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                              padding: const EdgeInsets.only(top: 6),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Input dan tombol kirim
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan Anda...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: _sendMessage,
                  tooltip: 'Kirim',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
