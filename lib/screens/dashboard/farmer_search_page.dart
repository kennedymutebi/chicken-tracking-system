import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/models/farmer.dart';
import 'farmer_profile_page.dart';
import 'package:poultry_farming_app/screens/dashboard/chart_screen.dart';

class FarmerSearchPage extends StatefulWidget {
  const FarmerSearchPage({Key? key}) : super(key: key);

  @override
  _FarmerSearchPageState createState() => _FarmerSearchPageState();
}

class _FarmerSearchPageState extends State<FarmerSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Farmer> allFarmers = [];
  List<Farmer> filteredFarmers = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _selectedLocation = 'All';

  final List<String> categories = [
    'All',
    'Poultry',
    'Crops',
    'Livestock',
    'Dairy',
    'Fish Farming',
    'Fruits & Vegetables',
    'Seeds & Seedlings',
    'Farm Equipment',
    'Organic Products',
  ];

  final List<String> locations = [
    'All',
    'Kampala',
    'Entebbe',
    'Jinja',
    'Mbale',
    'Mbarara',
    'Gulu',
    'Lira',
    'Fort Portal',
    'Kabale',
    'Soroti',
  ];

  @override
  void initState() {
    super.initState();
    _loadFarmers();
    _searchController.addListener(_filterFarmers);
  }

  Future<void> _loadFarmers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmersJson = prefs.getString('registered_farmers');

      if (farmersJson != null) {
        final List<dynamic> farmersList = json.decode(farmersJson);
        allFarmers = farmersList.map((farmer) => Farmer.fromJson(farmer)).toList();
      } else {
        allFarmers = _createSampleFarmers();
        await _saveFarmers();
      }
    } catch (e) {
      print('Error loading farmers: $e');
      allFarmers = _createSampleFarmers();
    }
    setState(() {
      filteredFarmers = allFarmers;
      _isLoading = false;
    });
  }

  List<Farmer> _createSampleFarmers() {
    return [
      Farmer(
        id: '1',
        name: 'John Ssebunya',
        phoneNumber: '+256700123456',
        location: 'Kampala',
        category: 'Poultry',
        description: 'Specializing in broiler chickens and layer hens.',
        products: ['Broiler Chicks', 'Layer Hens', 'Fresh Eggs'],
        avatar: 'assets/images/farmer1.jpg',
        isOnline: true,
        rating: 4.8,
        joinedDate: DateTime.now().subtract(Duration(days: 120)),
      ),
      Farmer(
        id: '2',
        name: 'Mary Nakato',
        phoneNumber: '+256701234567',
        location: 'Mukono',
        category: 'Poultry',
        description: 'Fresh organic kienyeji eggs from free-range hens.',
        products: ['Kienyeji Eggs', 'Free-Range Hens'],
        avatar: 'assets/images/farmer2.jpg',
        isOnline: false,
        rating: 4.9,
        joinedDate: DateTime.now().subtract(Duration(days: 89)),
      ),
      Farmer(
        id: '3',
        name: 'Paul Mukasa',
        phoneNumber: '+256702345678',
        location: 'Entebbe',
        category: 'Poultry',
        description: 'High egg production layer chicks.',
        products: ['Layer Chicks', 'Poultry Feed'],
        avatar: 'assets/images/farmer3.jpg',
        isOnline: true,
        rating: 4.6,
        joinedDate: DateTime.now().subtract(Duration(days: 200)),
      ),
      Farmer(
        id: '4',
        name: 'Grace Namusoke',
        phoneNumber: '+256703456789',
        location: 'Wakiso',
        category: 'Poultry',
        description: 'Point of lay hens ready to start laying.',
        products: ['Mature Hens', 'Layer Feed'],
        avatar: 'assets/images/farmer4.jpg',
        isOnline: true,
        rating: 4.7,
        joinedDate: DateTime.now().subtract(Duration(days: 156)),
      ),
      Farmer(
        id: '5',
        name: 'Samuel Walusimbi',
        phoneNumber: '+256704567890',
        location: 'Jinja',
        category: 'Poultry',
        description: 'Fresh duck eggs, larger and richer.',
        products: ['Duck Eggs', 'Ducklings'],
        avatar: 'assets/images/farmer5.jpg',
        isOnline: false,
        rating: 4.5,
        joinedDate: DateTime.now().subtract(Duration(days: 67)),
      ),
      Farmer(
        id: '6',
        name: 'Rebecca Namugga',
        phoneNumber: '+256705678901',
        location: 'Masaka',
        category: 'Poultry',
        description: 'Healthy young turkey poults.',
        products: ['Turkey Poults', 'Turkey Feed'],
        avatar: 'assets/images/farmer6.jpg',
        isOnline: true,
        rating: 4.9,
        joinedDate: DateTime.now().subtract(Duration(days: 34)),
      ),
    ];
  }

  Future<void> _saveFarmers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmersJson = json.encode(allFarmers.map((farmer) => farmer.toJson()).toList());
      await prefs.setString('registered_farmers', farmersJson);
    } catch (e) {
      print('Error saving farmers: $e');
    }
  }

  void _filterFarmers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredFarmers = allFarmers.where((farmer) {
        bool matchesSearch = farmer.name.toLowerCase().contains(query) ||
            farmer.location.toLowerCase().contains(query) ||
            farmer.category.toLowerCase().contains(query) ||
            farmer.description.toLowerCase().contains(query) ||
            farmer.products.any((product) => product.toLowerCase().contains(query));
        bool matchesCategory = _selectedCategory == 'All' || farmer.category == _selectedCategory;
        bool matchesLocation = _selectedLocation == 'All' || farmer.location == _selectedLocation;
        return matchesSearch && matchesCategory && matchesLocation;
      }).toList();
    });
  }

  void _startChat(Farmer farmer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          contactName: farmer.name,
          contactAvatar: farmer.avatar,
          isOnline: farmer.isOnline,
          initialMessage: "Hi ${farmer.name}! I'm interested in your ${farmer.category.toLowerCase()} products.",
          productContext: {
            'productTitle': farmer.category,
            'productPrice': 'Inquire for details',
          },
        ),
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
        title: Text('Find Farmers'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search farmers, products, locations...',
                      prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _filterFarmers();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickFilter('All Categories', _selectedCategory == 'All'),
                      _buildQuickFilter('Poultry', _selectedCategory == 'Poultry'),
                      _buildQuickFilter('Crops', _selectedCategory == 'Crops'),
                      _buildQuickFilter('Livestock', _selectedCategory == 'Livestock'),
                      _buildQuickFilter('Dairy', _selectedCategory == 'Dairy'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredFarmers.length} farmers found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                TextButton.icon(
                  onPressed: _showSortOptions,
                  icon: Icon(Icons.sort, size: 18),
                  label: Text('Sort'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                    ),
                  )
                : filteredFarmers.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredFarmers.length,
                        itemBuilder: (context, index) {
                          return _buildFarmerCard(filteredFarmers[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilter(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green[700],
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? (label == 'All Categories' ? 'All' : label) : 'All';
          });
          _filterFarmers();
        },
        selectedColor: Colors.green[600],
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildFarmerCard(Farmer farmer) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green[100],
                      child: farmer.avatar.isEmpty
                          ? Text(
                              farmer.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                farmer.avatar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
                                    farmer.name[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    if (farmer.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green[400],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              farmer.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              farmer.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            farmer.location,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            farmer.rating.toString(),
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        farmer.isOnline ? 'Online now' : 'Last seen recently',
                        style: TextStyle(
                          color: farmer.isOnline ? Colors.green[600] : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              farmer.description,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: farmer.products.take(3).map((product) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                );
              }).toList(),
            ),
            if (farmer.products.length > 3)
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  '+${farmer.products.length - 3} more products',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewProfile(farmer),
                    icon: Icon(Icons.person, size: 18),
                    label: Text('View Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green[700],
                      side: BorderSide(color: Colors.green[300]!),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startChat(farmer),
                    icon: Icon(Icons.chat, size: 18),
                    label: Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No farmers found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedCategory = 'All';
                _selectedLocation = 'All';
                filteredFarmers = allFarmers;
              });
            },
            child: Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Farmers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: categories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : 'All';
                    });
                  },
                  selectedColor: Colors.green[100],
                  checkmarkColor: Colors.green[700],
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: locations.map((location) {
                return FilterChip(
                  label: Text(location),
                  selected: _selectedLocation == location,
                  onSelected: (selected) {
                    setState(() {
                      _selectedLocation = selected ? location : 'All';
                    });
                  },
                  selectedColor: Colors.green[100],
                  checkmarkColor: Colors.green[700],
                );
              }).toList(),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _selectedLocation = 'All';
                      });
                      Navigator.pop(context);
                      _filterFarmers();
                    },
                    child: Text('Clear All'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _filterFarmers();
                    },
                    child: Text('Apply Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Highest Rating'),
              onTap: () {
                Navigator.pop(context);
                _sortFarmers('rating');
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Recently Joined'),
              onTap: () {
                Navigator.pop(context);
                _sortFarmers('recent');
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Location (A-Z)'),
              onTap: () {
                Navigator.pop(context);
                _sortFarmers('location');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Name (A-Z)'),
              onTap: () {
                Navigator.pop(context);
                _sortFarmers('name');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sortFarmers(String sortBy) {
    setState(() {
      switch (sortBy) {
        case 'rating':
          filteredFarmers.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'recent':
          filteredFarmers.sort((a, b) => b.joinedDate.compareTo(a.joinedDate));
          break;
        case 'location':
          filteredFarmers.sort((a, b) => a.location.compareTo(b.location));
          break;
        case 'name':
          filteredFarmers.sort((a, b) => a.name.compareTo(b.name));
          break;
      }
    });
  }

  void _viewProfile(Farmer farmer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FarmerProfilePage(farmer: farmer),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}