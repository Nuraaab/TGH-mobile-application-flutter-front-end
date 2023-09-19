import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/my_colors.dart';
import '../widget/my_text.dart';
import 'DepartmentDetails.dart';
import 'doctors.dart';

class SearchDepartments extends SearchDelegate{
  bool isEnglish;
  BuildContext context;
  bool status;
  List list;
  SearchDepartments({required this.list, required this.status, required this.context, required this.isEnglish});
  String get searchFieldLabel => isEnglish ? 'Search':'ይፈልጉ';
  void _navigateToPages(int i, List result){
    if(status == false){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
          DepartmentDetails(list: result, index: i),
      ));
    }else{
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
          DoctorsPage(id: result[i].id,),
      ));
    }
  }
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
    final results = isEnglish ? list.where((departments) => departments.titleEn.toLowerCase().contains(query.toLowerCase())).toList() :list.where((departments) => departments.titleAm.toLowerCase().contains(query.toLowerCase())).toList();
   if(query.isEmpty) {
     return Center(
       child: Text(isEnglish ? 'Search departments' : 'የስራ ክፍሎችን ይፈልጉ',
         style: MyText.body1(context)?.copyWith(
             color: MyColors.grey_60,
             fontWeight: FontWeight.w400,
             fontSize: 15
         ),
       ),
     );
   }else{
     return results.isEmpty ?  Center(child:  Text(isEnglish ? 'Sorry! department not found.' :'ይቅርታ！ የስራ ክፍሎችን ማግኘት አልተቻለም',
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
       itemCount: results== null ? 0 : results.length,
       itemBuilder: (context, i) {
         return Padding(
           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
           child: GestureDetector(
             onTap: (){
               _navigateToPages(i, results);
             },
             child: Card(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(3),
               ),
               elevation: 15,
               child: Column(
                 children: [
                   Expanded(
                     child: CachedNetworkImage(
                       key: UniqueKey(),
                       imageUrl:
                       'http://www.teklehaimanothospital.com/admin/${results[i].icon}',
                       placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                       errorWidget: (context, url, error) => Image.asset(
                         'assets/images/place_holder.png',
                         height: 230,
                         width:300,
                         fit: BoxFit.cover,
                       ),
                       width:300,
                       fit: BoxFit.cover,
                     ),
                   ),
                   Container(height: 10),
                   Text(isEnglish ? results[i].titleEn : results[i].titleAm,
                       style: MyText.medium(context).copyWith(
                           color: MyColors.grey_60,
                           fontWeight: FontWeight.w400,
                           fontSize: 15
                       ),
                     textAlign:  TextAlign.center,
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