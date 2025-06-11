import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/models/chart_message.dart';
import '/models/farmer.dart';
import 'farmer_profile_page.dart';

class ChatPage extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final bool isOnline;
  final String? initialMessage;
  final Map<String, dynamic>? productContext;

  const ChatPage({
    Key? key,
    required this.contactName,
    this.contactAvatar = '',
    this.isOnline = true,
    this.initialMessage,
    this.productContext,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  bool _isLoading = true;
  List<Farmer> allFarmers = [];

  @override
  void initState() {
    super.initState();
    _loadFarmers();
    _loadMessages();
    if (widget.initialMessage != null) {
      _messageController.text = widget.initialMessage!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _loadFarmers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmersJson = prefs.getString('registered_farmers');
      if (farmersJson != null) {
        final List<dynamic> farmersList = json.decode(farmersJson);
        setState(() {
          allFarmers = farmersList.map((farmer) => Farmer.fromJson(farmer)).toList();
        });
      }
    } catch (e) {
      print('Error loading farmers: $e');
    }
  }

  String get _conversationKey => 'chat_${widget.contactName.toLowerCase().replaceAll(' ', '_')}';

  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString(_conversationKey);
      if (messagesJson != null) {
        final List<dynamic> messagesList = json.decode(messagesJson);
        setState(() {
          messages = messagesList.map((msg) => ChatMessage.fromJson(msg)).toList();
          _isLoading = false;
        });
      } else {
        _loadDefaultMessages();
      }
    } catch (e) {
      print('Error loading messages: $e');
      _loadDefaultMessages();
    }
    if (widget.productContext != null && messages.isEmpty) {
      _addProductContextMessage();
    }
  }

  void _loadDefaultMessages() {
    setState(() {
      messages = [
        ChatMessage(
          text: "Hi! Are the broiler chicks still available?",
          isMe: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          messageType: MessageType.text,
        ),
        ChatMessage(
          text: "Yes, they are! I have 50 healthy broiler chicks ready for sale.",
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
          messageType: MessageType.text,
        ),
        ChatMessage(
          text: "What's the price per chick?",
          isMe: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          messageType: MessageType.text,
        ),
        ChatMessage(
          text: "UGX 2,500 per chick. They're 3 weeks old and vaccinated.",
          isMe: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          messageType: MessageType.text,
        ),
        ChatMessage(
          text: "That sounds good. Can I see some photos?",
          isMe: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          messageType: MessageType.text,
        ),
      ];
      _isLoading = false;
    });
    _saveMessages();
  }

  void _addProductContextMessage() {
    final contextMessage = ChatMessage(
      text: "Hi! I'm interested in your ${widget.productContext!['productTitle']} (${widget.productContext!['productPrice']}). Is it still available?",
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      messageType: MessageType.text,
    );
    setState(() {
      messages.add(contextMessage);
    });
    _saveMessages();
  }

  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = json.encode(messages.map((msg) => msg.toJson()).toList());
      await prefs.setString(_conversationKey, messagesJson);
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  Future<void> _clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_conversationKey);
      setState(() {
        messages.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat history cleared')),
      );
    } catch (e) {
      print('Error clearing chat history: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      text: _messageController.text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
      messageType: MessageType.text,
    );

    setState(() {
      messages.add(newMessage);
    });

    _messageController.clear();
    _saveMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    _simulateResponse();
  }

  void _simulateResponse() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responseMessage = ChatMessage(
          text: "Thank you for your message! I'll get back to you soon.",
          isMe: false,
          timestamp: DateTime.now(),
          messageType: MessageType.text,
        );
        setState(() {
          messages.add(responseMessage);
        });
        _saveMessages();
        _scrollToBottom();
      }
    });
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(Icons.camera_alt, 'Camera', () {
                  Navigator.pop(context);
                  _addImageMessage('Camera photo');
                }),
                _buildImageOption(Icons.photo_library, 'Gallery', () {
                  Navigator.pop(context);
                  _addImageMessage('Gallery photo');
                }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: Colors.green[700]),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  void _addImageMessage(String imageSource) {
    final imageMessage = ChatMessage(
      text: imageSource,
      isMe: true,
      timestamp: DateTime.now(),
      messageType: MessageType.image,
    );
    setState(() {
      messages.add(imageMessage);
    });
    _saveMessages();
    _scrollToBottom();
  }

  void _makeCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${widget.contactName}'),
        content: Text('Do you want to call ${widget.contactName} now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${widget.contactName}...')),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.green[100],
              child: widget.contactAvatar.isEmpty
                  ? Text(
                      widget.contactName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        widget.contactAvatar,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Text(
                          widget.contactName[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.isOnline ? 'Online' : 'Last seen recently',
                    style: TextStyle(fontSize: 12, color: Colors.green[100]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: _makeCall,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(messages[index]);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green[700]),
                    onPressed: _showImagePicker,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green[100],
              child: Text(
                widget.contactName[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.green[700] : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.messageType == MessageType.image)
                    Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isMe
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Text(
                'Y',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.green[700]),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                // Find the farmer by name
                final farmer = allFarmers.firstWhere(
                  (farmer) => farmer.name == widget.contactName,
                  orElse: () => Farmer(
                    id: 'unknown_${widget.contactName}', // Provide a unique ID
                    name: widget.contactName,
                    phoneNumber: '+256000000000', // Placeholder
                    location: 'Unknown', // Placeholder
                    category: 'Poultry', // Placeholder
                    description: 'No description available', // Placeholder
                    products: [], // Placeholder
                    avatar: widget.contactAvatar,
                    isOnline: widget.isOnline,
                    rating: 0.0, // Placeholder
                    joinedDate: DateTime.now(), // Placeholder
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmerProfilePage(farmer: farmer),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Clear Chat History'),
              onTap: () {
                Navigator.pop(context);
                _clearChatHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.orange),
              title: const Text('Report User'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${widget.contactName}?'),
        content: const Text('You won\'t receive messages from this user anymore.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.contactName} has been blocked')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Block', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}