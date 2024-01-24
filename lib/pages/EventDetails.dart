import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/webViewWidget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
class EventDetails extends StatefulWidget {
  final List list;
  final int index;
  const EventDetails({super.key, required this.list, required this.index});
  @override
  State<EventDetails> createState() => _EventDetailsState();
}
class _EventDetailsState extends State<EventDetails> {
  @override
  void initState(){
    super.initState();
    _checkLanguageStatus();
  }
  bool _isEnglish =false;
  void _checkLanguageStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isEnglish = prefs.getBool('isEnglish') ?? true;
    setState(() {
      _isEnglish = isEnglish;
    });
  }
  WebViewPlusController? _controller;
  double _height = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomFloatingActionButton(),
      body: ListView.builder(
          itemCount: widget.list == null ? 0 : 1,
          itemBuilder: (context,i){
            final String description = """${widget.list[widget.list.length - 1 - widget.index].descriptionEn}""";
            final String encodedDescription = jsonEncode(description);
            final String noQuotesDescription = encodedDescription.replaceAll('"', '');

            final String descriptionAm = """${widget.list[widget.list.length - 1 - widget.index].descriptionAm}""";
            final String encodedDescriptionAm = jsonEncode(descriptionAm);
            final String noQuotesDescriptionAm = encodedDescriptionAm.replaceAll('"', '');
            // String noHTMLDescription = noQuotesDescription.replaceAll(RegExp(r'<br[^>]*>'), ' ');
            return Column(
              children: [
                GestureDetector(
                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl:
                    'http://www.teklehaimanothospital.com/admin/${widget.list[widget.list.length - 1 - widget.index].image}',
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/place_holder.png',
                      height: 250,
                      width:300,
                      fit: BoxFit.cover,
                    ),
                    fit:BoxFit.cover,
                  ),
                ),
                 Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  child: Column(
                    children: [
                      const SizedBox(height: 5,),
                      Card(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10, left: 3, right: 3),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Center(
                                child: Text(_isEnglish ? widget.list[widget.list.length - 1 - widget.index].titleEn.toString() : widget.list[widget.list.length - 1 - widget.index].titleAm.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.bold,

                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              _isEnglish ? WebViewWidget(webViewContents: noQuotesDescription,) : WebViewPlusAm(amharicContent: noQuotesDescriptionAm),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
      ),
      bottomNavigationBar: const SubBottomNavBarContainer(),
    );
  }
}
