import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testing1212/pages/BottomNavBar.dart';
import 'package:testing1212/pages/webViewWidget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../data/my_colors.dart';
import '../widget/my_text.dart';
import 'ExpandableWidgetContainer.dart';

class TipsDetails extends StatefulWidget {
  List list;
  int index;
  bool isEnglish;
   TipsDetails({super.key, required this.list, required this.index, required this.isEnglish});

  @override
  State<TipsDetails> createState() => _TipsDetailsState();
}

class _TipsDetailsState extends State<TipsDetails> {
  @override
  Widget build(BuildContext context) {
    final String description = """${widget.list[widget.index].descriptionEn}""";
    final String encodedDescription = jsonEncode(description);
    final String noQuotesDescription = encodedDescription.replaceAll('"', '');
    final String descriptionAm = """${widget.list[widget.index].descriptionAm}""";
    final String encodedDescriptionAm = jsonEncode(descriptionAm);
    final String noQuotesDescriptionAm = encodedDescriptionAm.replaceAll('"', '');
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.isEnglish ? widget.list[widget.index].titleEn.toString() : widget.list[widget.index].titleAm.toString(),
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
