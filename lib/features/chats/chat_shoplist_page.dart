import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onbook_app/features/chats/chat_screen.dart';
import 'package:onbook_app/general/providers/message_provider.dart';

class ChatShopListScreen extends StatefulWidget {
  const ChatShopListScreen({super.key});

  @override
  State<ChatShopListScreen> createState() => _ChatShopListScreenState();
}

class _ChatShopListScreenState extends State<ChatShopListScreen> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<Map<String, dynamic>>> _shopsFuture;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadShops() {
    final messageProvider = Provider.of<MessageProvider>(
      context,
      listen: false,
    );
    _shopsFuture = messageProvider.fetchShopsList();
  }

  Future<void> _refresh() async {
    _loadShops();
    setState(() {}); // Trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Shop to Chat")),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search shop',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _shopsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 300),
                        Center(child: Text("No shops available")),
                      ],
                    );
                  }

                  // 🔍 Apply filtering
                  final query = _searchQuery.toLowerCase();
                  final filteredShops = snapshot.data!.where((shop) {
                    final name = (shop['shopName'] ?? '').toLowerCase();
                    final city = (shop['city'] ?? '').toLowerCase();
                    return name.contains(query) || city.contains(query);
                  }).toList();

                  if (filteredShops.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 300),
                        Center(
                          child: Text(
                            'No shops found for "$_searchQuery"',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = filteredShops[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.store, color: Colors.blue),
                        ),
                        title: Text(
                          shop['shopName'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(shop['city'] ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                shopId: shop['shopId'],
                                shopName: shop['shopName'],
                                shopCity: shop['city'],
                                shopEmail: shop['email'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}