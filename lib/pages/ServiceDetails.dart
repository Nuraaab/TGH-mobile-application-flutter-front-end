import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/ExpandableWidgetContainer.dart';
import 'package:testing1212/pages/webViewWidget.dart';
import 'package:testing1212/widget/navigation_drawer.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../data/my_colors.dart';
import '../widget/my_text.dart';

class ServiceDetails extends StatefulWidget {
  List list;
  int index;
  bool isEnglish;
   ServiceDetails({super.key, required this.list, required this.index, required this.isEnglish});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {
    final String description = """${widget.list[ widget.index].descriptionEn}""";
    final String encodedDescription = jsonEncode(description);
    final String noQuotesDescription = encodedDescription.replaceAll("\"", "");
    String stringWithoutQuotes = encodedDescription.substring(1, encodedDescription.length - 1);

    final String descriptionAm = """${widget.list[ widget.index].descriptionAm}""";
    final String encodedDescriptionAm = jsonEncode(descriptionAm);
    print(stringWithoutQuotes);
    final String noQuotesDescriptionAm = encodedDescriptionAm.replaceAll("\"", "");
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.isEnglish ? '${widget.list[widget.index].titleEn}' : '${widget.list[widget.index].titleAm}',
            style: MyText.subhead(context)!.copyWith(
                color: MyColors.grey_3, fontSize: 20, fontWeight: FontWeight.w500)
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: MyColors.navBarColor,
        foregroundColor: MyColors.grey_3,
      ),
          floatingActionButton: CustomFloatingActionButton(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 20,),
            widget.isEnglish ? WebViewWidget(webViewContents: noQuotesDescription,) : WebViewPlusAm(amharicContent: noQuotesDescriptionAm),
              ],
            ),
          ),
      bottomNavigationBar: SubBottomNavBarContainer(),
    );
  }
}
