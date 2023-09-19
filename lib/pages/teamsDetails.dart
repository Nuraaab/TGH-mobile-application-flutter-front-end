import 'package:flutter/material.dart';
import '../data/my_colors.dart';
import '../widget/my_text.dart';
import 'BottomNavBar.dart';
import 'ExpandableWidgetContainer.dart';
class TeamsDetails extends StatefulWidget {
  List list;
  int index;
  bool isEnglish;
  TeamsDetails({super.key, required this.list, required this.index, required this.isEnglish});
  @override
  State<TeamsDetails> createState() => _TeamsDetailsState();
}
class _TeamsDetailsState extends State<TeamsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.isEnglish ? '${widget.list[widget.index].nameEn}' : '${widget.list[widget.index].nameAm}',
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
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.list[widget.index].position,
                  style: MyText.title(context)!.copyWith(
                    color: Color.fromRGBO(29, 33, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  )
              ),
              SizedBox(height: 10,),
              Text(widget.isEnglish ? '${widget.list[widget.index].descEn}' : '${widget.list[widget.index].descAm}',
                  style: MyText.subhead(context)!
                      .copyWith(color: Color.fromRGBO(119, 119, 119, 1)),
              ),
            ],
          ),
        )
      ),
      bottomNavigationBar: SubBottomNavBarContainer(),
    );
  }
}
