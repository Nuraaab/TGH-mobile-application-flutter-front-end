import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/my_colors.dart';
import '../widget/my_text.dart';
import 'DoctorDetails.dart';
class SearchDoctors extends SearchDelegate{
  bool isEnglish;
  List list;
  SearchDoctors({ required this.list, required this.isEnglish});
  String get searchFieldLabel => isEnglish ? 'Search':'ይፈልጉ';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query ='';
      }, icon: Icon(Icons.close),),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
   return buildSuggestions(context);
    }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = isEnglish ? list.where((doctor) => doctor.nameEn.toLowerCase().contains(query.toLowerCase())).toList() : list.where((doctor) => doctor.nameAm.toLowerCase().contains(query.toLowerCase())).toList();
    if(query.isEmpty) {
      return Center(
        child: Text(isEnglish ? 'Search doctors' : 'ዶክተሮችን ይፈልጉ',
          style: MyText.body1(context)?.copyWith(
              color: MyColors.grey_60,
              fontWeight: FontWeight.w400,
              fontSize: 15
          ),
        ),
      );
    }else{
      return results.isEmpty ? Center(child: Text(isEnglish ? 'Sorry! doctor not found.' : 'ይቅርታ！ ሀኪሙን ማግኘት አልተቻለም',
        style: MyText.body1(context)?.copyWith(
            color: MyColors.grey_60,
            fontWeight: FontWeight.w400,
            fontSize: 15
        ),
      ),) : GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 230,
          childAspectRatio: 1,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
        ),
        itemCount: results == null ? 0 : results.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('timetable', false);
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
                    DoctorsDetails(list: results, index: i),
                ));
              },
              child: Card(
                color: MyColors.grey_3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),elevation: 15,
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          key: UniqueKey(),
                          imageUrl:
                          'http://www.teklehaimanothospital.com/admin/${results[i].photo}',
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/place_holder.png',
                            height: 155,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          fit: BoxFit.cover,
                          width: 200,
                        ),
                      ),
                    ),
                    Container(height: 10),
                    Text(isEnglish ? results[i].nameEn.toString() : results[i].nameAm.toString(),
                      style: MyText.medium(context).copyWith(
                          color: MyColors.grey_60,
                          fontWeight: FontWeight.w400,
                          fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(isEnglish ? results[i].poEn.toString() :results[i].poAm.toString(),
                      style: MyText.body1(context)?.copyWith(
                          color: MyColors.grey_60,
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    Container(height: 10),
                  ],
                ),
              ),
            ),
          );

        },
      );
    }
  }
  
}