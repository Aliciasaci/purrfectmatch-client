import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purrfectmatch/models/association.dart';
import 'package:purrfectmatch/models/user.dart';
import 'package:purrfectmatch/services/api_service.dart';
import 'package:purrfectmatch/blocs/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'edit_association_screen.dart';

class AssociationDetailScreen extends StatefulWidget {
  final Association association;

  const AssociationDetailScreen({super.key, required this.association});

  @override
  State<AssociationDetailScreen> createState() => _AssociationDetailScreenState();
}

class _AssociationDetailScreenState extends State<AssociationDetailScreen> with RouteAware {
  late ApiService _apiService;
  User? _owner;
  User? currentUser;
  List<User> _validMembers = [];
  bool _isLoading = true;
  late Association _association;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _association = widget.association;
    _loadCurrentUser().then((_) {
      _fetchDetails();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to RouteObserver
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      RouteObserver<PageRoute>().subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    // Unsubscribe from RouteObserver
    RouteObserver<PageRoute>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when this route is popped back to
    _fetchDetails();
  }

  Future<void> _loadCurrentUser() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      setState(() {
        currentUser = authState.user;
      });
    }
  }

  Future<void> _fetchDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final owner = await _apiService.fetchUserByID(_association.OwnerID);
      List<User> validMembers = [];
      for (String memberId in _association.Members ?? []) {
        if (memberId.isNotEmpty) {
          User member = await _apiService.fetchUserByID(memberId);
          if (member.email.isNotEmpty) {
            validMembers.add(member);
          }
        }
      }
      setState(() {
        _owner = owner;
        _validMembers = validMembers;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToLoadDetails)),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildOwnerInfo() {
    return _owner != null
        ? Container(
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: Colors.orange),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_owner!.name} (${AppLocalizations.of(context)!.owner})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_owner!.email),
            ],
          ),
        ],
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildMembersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ..._validMembers.map((member) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(member.email),
                      Text(member.addressRue),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _association.Verified == true ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _association.Verified == true ? 'Vérifié' : 'Non Vérifié',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange[100]!, Colors.orange[200]!],
              ),
            ),
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top - kToolbarHeight / 2,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text(AppLocalizations.of(context)!.associationDetailsTitle),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _association.Name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildVerificationBadge(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.owner,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            _buildOwnerInfo(),
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.associationMembers,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            _buildMembersList(),
                            if (currentUser?.id == _association.OwnerID)
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditAssociationScreen(
                                              association: _association),
                                        ),
                                      );
                                      if (result == true) {
                                        // Fetch updated details
                                        final updatedAssociation = await _apiService.fetchAssociationByID(_association.ID.toString());
                                        setState(() {
                                          _association = updatedAssociation;
                                        });
                                        _fetchDetails();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[100],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.modifyAssociation,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}
