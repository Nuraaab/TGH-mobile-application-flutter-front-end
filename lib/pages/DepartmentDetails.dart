import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/webViewWidget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../data/my_colors.dart';
import '../models/department.dart';
import '../widget/my_text.dart';
class DepartmentDetails extends StatefulWidget {
  final List list; // list variable used to accept list from department page
  final int index; // index used to accept department index from department page
  const DepartmentDetails({super.key,  required this.list, required this.index}); //assign to the constructor
@override
  State<DepartmentDetails> createState() => _DepartmentDetailsState();
}

class _DepartmentDetailsState extends State<DepartmentDetails> {
// late List<dynamic> modelList = widget.list.cast<Department>();
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
  }
  bool _isEnglish =false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? false;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  @override
  Widget build(BuildContext context) {
    //declare variable to store the description fetched from the database
    final String description = '${widget.list[widget.index].bodyEn}';
    final String encodeDescription = jsonEncode(description);// encode id
    final String noQuotesDescription = encodeDescription.replaceAll('"', '');//replace the double quote
    final String breakReplaced = noQuotesDescription.replaceAll(RegExp(r'<br>|<\/br>'), ''); // replace the break


    final String descriptionAm = '${widget.list[widget.index].bodyAm}';
    final String encodeDescriptionAm = jsonEncode(descriptionAm);// encode id
    final String noQuotesDescriptionAm = encodeDescriptionAm.replaceAll('"', '');//replace the double quote
    final String breakReplacedAm = noQuotesDescriptionAm.replaceAll(RegExp(r'<br>|<\/br>'), '');
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: ListView.builder(
          itemCount: widget.list == null ? 0 : 1,
          itemBuilder: (context,i){
            return Column(
              children: [
                Container(
                  child: GestureDetector(
                    child: CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl:
                      'http://www.teklehaimanothospital.com/admin/${widget.list[widget.index].icon}',// display the image
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/place_holder.png',// display the default image if error happens
                        height: 250,
                        width:double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                        fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 3),
                  child: Column(
                      children: [
                        Center(
                          child: Text(_isEnglish ? widget.list[widget.index].titleEn : widget.list[widget.index].titleAm,//display the title
                            textAlign: TextAlign.center,
                            style: MyText.subhead(context)!.copyWith(
                                color: MyColors.grey_80, fontSize: 27, letterSpacing: 1, fontWeight: FontWeight.w500),
                          ),

                        ),
                        SizedBox(height: 5),
                        _isEnglish ? WebViewWidget(webViewContents:breakReplaced,) : WebViewPlusAm(amharicContent: breakReplacedAm),

                      ]
                  ),
                ),

              ],
            );
          }

      ),
      bottomNavigationBar: const SubBottomNavBarContainer(),
      // display floating action button
    );
  }
}
