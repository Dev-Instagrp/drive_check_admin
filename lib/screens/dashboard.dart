import 'package:drive_check_admin/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const String routeName = '/dashboardId';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final int _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  DocumentSnapshot? _firstDocument;
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalDocuments = 0;
  int _totalPages = 0;
  List<DocumentSnapshot> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchTotalDocuments();
  }

  Future<void> _fetchTotalDocuments() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _totalDocuments = snapshot.docs.length;
      _totalPages = (_totalDocuments / _pageSize).ceil();
      _isLoading = false;
    });

    _fetchUsers();
  }

  Future<void> _fetchUsers({bool isNextPage = true}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('users')
        .orderBy(FieldPath.documentId)
        .limit(_pageSize);

    if (isNextPage) {
      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }
    } else {
      if (_firstDocument != null) {
        query = query.endBeforeDocument(_firstDocument!);
      }
    }

    final snapshot = await query.get();
    setState(() {
      _users = snapshot.docs;
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      _firstDocument = snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
      _isLoading = false;
    });
  }

  void _goToPage(int page) {
    if (page > _currentPage) {
      _fetchUsers(isNextPage: true);
    } else if (page < _currentPage) {
      _fetchUsers(isNextPage: false);
    }
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      final userData = user.data() as Map<String, dynamic>;
                      final userName = userData['Employee Name'];
                      final userEmail = userData['Email'];
                      final userPhone = userData['Phone Number'];
                      final userProfile = userData['Profile Picture'];
                      return UserCard(profileUrl: userProfile, name: userName, email: userEmail, phoneNumber: userPhone, onTap: (){});
                    },
                  ),
          ),
          if (_totalPages > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) {
                final page = index + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () => _goToPage(page),
                    child: Text('$page'),
                  ),
                );
              }),
            ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
