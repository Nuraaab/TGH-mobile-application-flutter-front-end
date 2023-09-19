import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/pages/home.dart';
import 'package:testing1212/pages/login_card_overlap.dart';
import '../data/my_colors.dart';
class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);
  @override
  _CustomFloatingActionButtonState createState() =>
      _CustomFloatingActionButtonState();
}
class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  bool _isExpanded = false;
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
  @override
  void initState(){
    super.initState();
    _checkLoginStatus();
  }
  bool _isLoggedIn=false;
  void _checkLoginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _isLoggedIn = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isExpanded)
          Positioned(
            bottom: 50,
            right: 0,
            child: Container(
              width: 60,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(_isExpanded ? 0 : 10.0),
                  bottomLeft: Radius.circular(_isExpanded ? 0 : 10.0),
                ),
                color: MyColors.navBarColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                        );
                      },
                      icon: const Icon(Icons.home, color: MyColors.grey_3, size: 30,),
                      tooltip: 'Home',
                    ),
                    IconButton(
                      onPressed: () {
                        if(_isLoggedIn==false){
                          setState(() {
                            _isLoggedIn = true;
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginCardOverlapRoute()));
                          });
                        }else{
                          _logout();
                        }
                      },
                      icon: Icon(_isLoggedIn ? Icons.logout : Icons.login, color: MyColors.grey_3, size: 30,),
                      tooltip:_isLoggedIn ? 'Log out' : 'Log in',
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 60,
                child: FloatingActionButton(
                  backgroundColor: MyColors.navBarColor,
                  onPressed: _toggleExpanded,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(_isExpanded ? 0.0 : 10.0),
                      topLeft: Radius.circular(_isExpanded ? 0.0 : 10.0),
                      bottomLeft: Radius.circular(10),
                      bottomRight: const Radius.circular(10),
                    ),
                    side: const BorderSide(color: MyColors.navBarColor),
                  ),
                  child: Icon(_isExpanded ? Icons.close : Icons.add),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
