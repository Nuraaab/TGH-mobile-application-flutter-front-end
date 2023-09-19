import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/services.dart';

class SubBottomNavBarContainer extends StatefulWidget {
  const SubBottomNavBarContainer({Key? key}) : super(key: key);

  @override
  State<SubBottomNavBarContainer> createState() => _SubBottomNavBarContainerState();
}

class _SubBottomNavBarContainerState extends State<SubBottomNavBarContainer> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.black54.withOpacity(0.5),
      showUnselectedLabels: false,
      showSelectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedFontSize: 0,
      selectedFontSize: 1,
      elevation: 20,
      type: BottomNavigationBarType.shifting,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(label:'Home' , icon: Icon(Icons.apps, size: 25,)),
        BottomNavigationBarItem(label: 'Doctor' , icon: Icon(Icons.medical_services, size: 25,)),
        BottomNavigationBarItem(label:'Department' , icon: Icon(Icons.people, size: 25,)),
        BottomNavigationBarItem(label: 'Contact' , icon: Icon(Icons.contact_page_outlined, size: 25,)),
      ],
      currentIndex: 0,
      onTap: (index) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('status', false);
        Services.onItemTapped(context, index);
      }
    );
  }
}
