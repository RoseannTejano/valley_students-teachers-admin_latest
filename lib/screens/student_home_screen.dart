import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:valley_students_and_teachers/services/add_notif.dart';
import 'package:valley_students_and_teachers/utils/media_query.dart';
import 'package:valley_students_and_teachers/utils/routes.dart';
import 'package:valley_students_and_teachers/widgets/button_widget.dart';
import 'package:valley_students_and_teachers/widgets/reservation_dialog.dart';
import 'package:valley_students_and_teachers/widgets/text_widget.dart';
import 'package:valley_students_and_teachers/widgets/textfield_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

import '../services/add_chatroom.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool isSchedule = true;
  bool isAvailability = false;
  final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  String myName = '';

  String myId = '';

  String myRole = '';

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
            image: DecorationImage(
              opacity: 200,
              image: AssetImage(
                'assets/images/back.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot>(
                  stream: userData,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    } else if (snapshot.hasError) {
                      return const SizedBox();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    dynamic data = snapshot.data;

                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      myName = data['name'];

                      myRole = data['role'];
                      myId = data.id;
                      membersId.add(data.id);
                    });
                    return Container(
                      height: double.infinity,
                      width: deviceSize.width,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(143, 0, 0, 0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextBold(
                            text: 'Welcome!',
                            fontSize: 32,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Image.asset(
                            'assets/images/avatar.png',
                            height: 125,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextBold(
                            text: data['name'],
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextBold(
                            text: data['idNumber'],
                            fontSize: 18,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                nameController.text = data['name'];
                                emailController.text = data['idNumber'];
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: TextBold(
                                        text: 'Edit Profile',
                                        fontSize: 18,
                                        color: Colors.black),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFieldWidget(
                                          label: 'Name',
                                          controller: nameController,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFieldWidget(
                                          label: 'Email',
                                          controller: emailController,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: TextBold(
                                            text: 'Close',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(data.id)
                                              .update({
                                            'name': nameController.text,
                                            'idNumber': emailController.text,
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: TextBold(
                                            text: 'Save',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: TextBold(
                              text: 'Edit Profile',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAvailability = false;
                                isSchedule = true;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return consultation();
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color:
                                      isSchedule ? Colors.white : Colors.grey,
                                  size: 48,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                TextBold(
                                  text: 'Consultation',
                                  fontSize: 24,
                                  color:
                                      isSchedule ? Colors.white : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 75, right: 75),
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAvailability = true;
                                isSchedule = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return reservation();
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: isAvailability
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 48,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                TextBold(
                                  text: 'Reservation',
                                  fontSize: 24,
                                  color: isAvailability
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 75, right: 75),
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ButtonWidget(
                            label: 'View Faculty Workload',
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, Routes().teacherlist);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
              // isSchedule ? consultation() : reservation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget consultation() {
    return AlertDialog(
      title: Container(
        width: deviceSize.width,
        color: Colors.transparent,
        height: deviceSize.height * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Chats')
                    .where('membersId',
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .where('creator',
                        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton(
                        icon: Badge(
                          backgroundColor: Colors.red,
                          label: TextRegular(
                              text: data.docs.length.toString(),
                              fontSize: 14,
                              color: Colors.white),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                        itemBuilder: (context) {
                          return [
                            for (int i = 0; i < data.docs.length; i++)
                              PopupMenuItem(
                                  onTap: () {
                                    chatroomDialog(data.docs[i].id);
                                    chatroomDialog(data.docs[i].id);
                                  },
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.notifications,
                                      color: Colors.black,
                                    ),
                                    title: TextBold(
                                        text: 'You have new message ',
                                        fontSize: 16,
                                        color: Colors.black),
                                    subtitle: TextRegular(
                                        text: DateFormat.yMMMd()
                                            .add_jm()
                                            .format(data.docs[i]['dateTime']
                                                .toDate()),
                                        fontSize: 12,
                                        color: Colors.black),
                                  ))
                          ];
                        },
                      ));
                }),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: deviceSize.height * .52,
              width: deviceSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  TextBold(
                      text: 'MESSAGES ',
                      fontSize: 18,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      onPressed: () {
                        createGroupDialog();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      label: TextBold(
                        text: 'Create group',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Chats')
                          .where('membersId',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          );
                        }

                        final data = snapshot.requireData;

                        return Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: data.docs.length,
                              itemBuilder: (context, index) {
                                String date = DateFormat.yMMMd()
                                    .add_jm()
                                    .format(
                                        data.docs[index]['dateTime'].toDate());
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 0, right: 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      chatroomDialog(data.docs[index].id);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.chat,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        TextBold(
                                            text: data.docs[index]['messages']
                                                    .isNotEmpty
                                                ? data.docs[index]['messages'][
                                                    data.docs[index]['messages']
                                                            .length -
                                                        1]['msg']
                                                : 'No message yet...',
                                            fontSize: 11,
                                            color: Colors.black),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextRegular(
                                            text:
                                                '${date.substring(0, 12)} \n${date.substring(12)}',
                                            // DateFormat.yMMMd()
                                            //     .add_jm()
                                            //     .format(data.docs[index]
                                            //             ['dateTime']
                                            //         .toDate()),
                                            fontSize: 12,
                                            color: Colors.black),
                                        // const SizedBox(
                                        //   width: 5,
                                        // ),
                                        IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Chats')
                                                .doc(data.docs[index].id)
                                                .delete();
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final searchController = TextEditingController();

  String nameSearched = '';

  List members = [];
  List membersId = [];

  createGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Container(
              height: 35,
              width: 180,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    nameSearched = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search member',
                  hintStyle: TextStyle(fontFamily: 'QRegular'),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 0.5, color: Colors.black54),
                  ),
                  contentPadding: EdgeInsets.only(top: 5),
                ),
                controller: searchController,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    width: 300,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .where('name',
                                isGreaterThanOrEqualTo:
                                    toBeginningOfSentenceCase(nameSearched))
                            .where('name',
                                isLessThan:
                                    '${toBeginningOfSentenceCase(nameSearched)}z')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < data.docs.length; i++)
                                  data.docs[i].id !=
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? ListTile(
                                          onTap: () {
                                            if (membersId.contains(
                                                    data.docs[i].id) ==
                                                false) {
                                              setState(
                                                () {
                                                  members.add({
                                                    'name': data.docs[i]
                                                        ['name'],
                                                    'role': data.docs[i]
                                                        ['role'],
                                                    'userId': data.docs[i].id,
                                                    'email': data.docs[i]
                                                        ['idNumber']
                                                  });
                                                  membersId
                                                      .add(data.docs[i].id);
                                                },
                                              );
                                            }
                                          },
                                          leading: const Icon(
                                            Icons.account_circle_outlined,
                                            size: 32,
                                          ),
                                          title: TextBold(
                                              text: data.docs[i]['name'],
                                              fontSize: 16,
                                              color: Colors.black),
                                          trailing: TextRegular(
                                              text: data.docs[i]['role'],
                                              fontSize: 12,
                                              color: Colors.black),
                                        )
                                      : const SizedBox(),
                              ],
                            ),
                          );
                        }),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < members.length; i++)
                          ListTile(
                            leading: const Icon(
                              Icons.account_circle_outlined,
                              size: 32,
                            ),
                            title: TextBold(
                                text: members[i]['name'],
                                fontSize: 16,
                                color: Colors.black),
                            subtitle: TextRegular(
                                text: members[i]['role'],
                                fontSize: 12,
                                color: Colors.black),
                            trailing: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      membersId.removeAt(i);
                                      members.removeAt(i);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.remove)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  members.clear();
                  Navigator.pop(context);
                },
                child: TextBold(
                  text: 'Close',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () async {
                  print(members);
                  //                final Uri emailLaunchUri = Uri(
                  //   scheme: 'mailto',
                  //   path: mailPath,
                  //   queryParameters: {'subject': 'Added to groupchat', 'body': ''},
                  // );
                  // if (await canLaunchUrlString(emailLaunchUri.toString())) {
                  //   await launchUrlString(emailLaunchUri.toString());
                  // } else {
                  //   throw 'Could not launch email';
                  // }

                  setState(
                    () {
                      members.add({
                        'name': myName,
                        'role': myRole,
                        'userId': myId,
                      });
                    },
                  );
                  addChatroom(members, membersId);
                  Navigator.pop(context);

                  for (int i = 0; i < members.length; i++) {
                    if (members[i]['role'] == 'Teacher') {
                      addNotif(
                          members[i]['name'],
                          'You have been added to a consultation',
                          members[i]['userId']);
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: members[i]['email'],
                        queryParameters: {
                          'subject': 'Added to consultation',
                          'body': ''
                        },
                      );
                      if (await canLaunchUrlString(emailLaunchUri.toString())) {
                        await launchUrlString(emailLaunchUri.toString());
                      } else {
                        throw 'Could not launch email';
                      }
                    }
                  }
                  members.clear();
                },
                child: TextBold(
                  text: 'Create',
                  fontSize: 14,
                  color: Colors.black,
                ),
              )
            ],
          );
        });
      },
    );
  }

  Widget reservation() {
    return AlertDialog(
      title: SingleChildScrollView(
        child: Container(
          width: deviceSize.width,
          color: Colors.transparent,
          height: deviceSize.height * .5 - 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Notif')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        )),
                      );
                    }

                    final data = snapshot.requireData;
                    return Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton(
                          icon: Badge(
                            backgroundColor: Colors.red,
                            label: TextRegular(
                                text: data.docs.length.toString(),
                                fontSize: 14,
                                color: Colors.white),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                          itemBuilder: (context) {
                            return [
                              for (int i = 0; i < data.docs.length; i++)
                                PopupMenuItem(
                                    child: ListTile(
                                  leading: const Icon(
                                    Icons.notifications,
                                    color: Colors.black,
                                  ),
                                  title: TextBold(
                                      text: data.docs[i]['name'],
                                      fontSize: 16,
                                      color: Colors.black),
                                  subtitle: TextRegular(
                                      text: DateFormat.yMMMd().add_jm().format(
                                          data.docs[i]['dateTime'].toDate()),
                                      fontSize: 12,
                                      color: Colors.black),
                                ))
                            ];
                          },
                        ));
                  }),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Reservations')
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return Expanded(
                            child: Container(
                              // color: Colors.red,
                              child: ListView.builder(
                                itemCount: data.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 0, right: 0),
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 30,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        TextBold(
                                            text: data.docs[index]['name'],
                                            fontSize: 16,
                                            color: Colors.black),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        TextRegular(
                                            text:
                                                '${data.docs[index]['date']} \n${data.docs[index]['time']}',
                                            //  data.docs[index]['date'] +
                                            //     ' ' +
                                            //     data.docs[index]['time'],
                                            fontSize: 14,
                                            color: Colors.black),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Reservations')
                                                .doc(data.docs[index].id)
                                                .delete();
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const ReservationDialog();
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          label: TextBold(
                            text: 'Create',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final msgController = TextEditingController();

  chatroomDialog(String docId) {
    final Stream<DocumentSnapshot> chatrooms =
        FirebaseFirestore.instance.collection('Chats').doc(docId).snapshots();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 500,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton(
                        icon: const Icon(
                          Icons.groups_2_outlined,
                          color: Colors.grey,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: TextRegular(
                                text: ' ',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  StreamBuilder<DocumentSnapshot>(
                      stream: chatrooms,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Expanded(child: SizedBox());
                        } else if (snapshot.hasError) {
                          return const Expanded(child: SizedBox());
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        dynamic data = snapshot.data;
                        List msgs = data['messages'];

                        return Expanded(
                          child: SizedBox(
                            child: ListView.separated(
                              itemCount: msgs.length,
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.message),
                                  title: TextRegular(
                                    text: msgs[index]['msg'],
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  subtitle: TextRegular(
                                    text: msgs[index]['name'],
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  trailing: TextRegular(
                                    text: DateFormat.yMMMd()
                                        .add_jm()
                                        .format(msgs[index]['date'].toDate()),
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                  const Divider(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextFormField(
                      controller: msgController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Chats')
                                .doc(docId)
                                .update({
                              'messages': FieldValue.arrayUnion([
                                {
                                  'name': myName,
                                  'userId':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'msg': msgController.text,
                                  'date': DateTime.now(),
                                }
                              ]),
                            });
                            msgController.clear();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
