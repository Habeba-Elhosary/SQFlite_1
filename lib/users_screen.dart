import 'dart:developer';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'model.dart';
import 'package:animation_search_bar/animation_search_bar.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();

  final searchController = TextEditingController();
  String input = "";
  int currentIndex = 0;
  List x= [];

  final database = DatabaseHelper.instance;
  bool isLoading = true;
  List<User> users = [];
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  void getUsers() async {
    users = await database.getAllUsers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 65),
          child: SafeArea(
              child: Container(
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(0, 5))
            ]),
            alignment: Alignment.center,
            child: Column(
              children: [
                AnimationSearchBar(
                    isBackButtonVisible: false,
                    backIconColor: Colors.black,
                    centerTitle: 'Users',
                    onChanged: (input) async {
                     x = await database.searchFromDatabase(input);
                      print (x) ;
                    },
                    searchTextEditingController: searchController,
                    horizontalPadding: 5),
              ],
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(children: [
                          TextFormField(
                            controller: userNameController,
                            decoration: const InputDecoration(
                              label: Text('User Name'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              label: Text('Email'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: FilledButton(
                                style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () async {
                                  final user = User(
                                      userName: userNameController.text,
                                      email: emailController.text);
                                  database.insertToDatabase(user).then((value) {
                                    getUsers();
                                    Navigator.pop(context);
                                    log('$value');
                                  });
                                },
                                child: const Text('Add User')),
                          )
                        ]),
                      ),
                    ),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemBuilder: (_, index) {
                  User user = users[index];
                  return Card(
                      child: ListTile(
                    title: Text(user.userName),
                    subtitle: Text(user.email),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          database.deleteFromDatabase(user.id!).then((value) {
                            getUsers();
                          });
                        },
                      ),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            currentIndex = index;
                            userNameController.text = users[index].userName;
                            emailController.text = users[index].email;
                            await showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: SizedBox(
                                      height: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(children: [
                                          TextFormField(
                                            controller: userNameController,
                                            decoration: const InputDecoration(
                                              label: Text('User Name'),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                              label: Text('Email'),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: double.maxFinite,
                                            child: FilledButton(
                                                style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                onPressed: () {
                                                  User x = users[currentIndex];
                                                  x.userName = userNameController.text;
                                                  x.email = emailController.text;
                                                  database.updateData(x, x.id!);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Edit data')),
                                          )
                                        ]),
                                      ),
                                    ),
                                  );
                                });
                          })
                    ]),
                  ));
                },
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemCount: users.length));
  }
}
