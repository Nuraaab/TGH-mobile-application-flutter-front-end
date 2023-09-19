import 'package:flutter/material.dart';

import '../data/my_colors.dart';
import '../widget/my_text.dart';

class SearchAppointments extends SearchDelegate{
  final TextEditingController _queryController = TextEditingController();
  List list;
  bool isEnglish;
  SearchAppointments({required this.list, required this.isEnglish});
  String get searchFieldLabel => isEnglish ? 'Search':'ይፈልጉ';
  @override
  TextField buildTextField(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
      ),
      onChanged: (query) {
        // Update the query and rebuild the search UI
        this.query = query;
        showResults(context);
      },
    );
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
      final results = isEnglish ? list.where((appointment) => appointment.nameEn.toLowerCase().contains(query.toLowerCase())).toList() : list.where((appointment) => appointment.nameAm.toLowerCase().contains(query.toLowerCase())).toList();
      if(query.isEmpty){
        return Center(
          child: Text(isEnglish ? 'Search Appointments' : "ቀጠሮዎችን ይፈልጉ",
            style: MyText.body1(context)?.copyWith(
                color: MyColors.grey_60,
                fontWeight: FontWeight.w400,
                fontSize: 15
            ),
          ),
        );
      }else {
        return results.isEmpty
            ?  Center(child: Text(isEnglish ? 'Sorry! appointment not found.' : 'ይቅርታ！ ቀጠሮውን ማግኘት አልተቻለም',
          style: MyText.body1(context)?.copyWith(
              color: MyColors.grey_60,
              fontWeight: FontWeight.w400,
              fontSize: 15
          ),
        ),)
            : ListView.builder(

            itemCount: results == null ? 0 : results?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Column(
                  children: [
                    Card(
                      color: MyColors.secondary,
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.calendar_month, color: MyColors.grey_3,),
                        title: isEnglish ? Text(results[index].selectedDay.toString(),
                          style: const TextStyle(
                            color: MyColors.grey_3,
                          ),
                        ) : (() {
                          switch (results[index].selectedDay){
                            case 'Monday':
                              return const Text('ሰኞ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Tuesday':
                              return const Text('ማክሰኞ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Wednesday':
                              return const Text('ረቡዕ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Thursday':
                              return const Text('ሐሙስ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Friday':
                              return const Text('ዓርብ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Saturday':
                              return const Text('ቅዳሜ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            case 'Sunday':
                              return const Text('እሑድ',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                            default:
                              return const Text('...',  style: TextStyle(
                                color: MyColors.grey_3,
                              ),);
                          }
                        })(),
                        trailing: GestureDetector(
                          // onTap: (){
                          //   _getBookingCount(widget.list[index]['selected_day'], widget.list[index]['selected_date'], widget.list[index]['selected_time']);
                          //    print('thise is no of booking ${_booking_no}');
                          //   },
                          child: Icon(
                            color: MyColors.grey_3, Icons.expand_more,),
                        ),

                        subtitle: Text(isEnglish
                            ? results[index].nameEn.toString()
                            : results[index].nameAm.toString(),
                          style: const TextStyle(
                            color: MyColors.grey_3,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ListTile(
                              leading: const Icon(
                                Icons.lock_clock, color: MyColors.grey_3,),
                              title: Text(isEnglish ? 'Time' : "የቀጠሮ ሰዓት",
                                style: TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                              trailing: Text(results[index].selectedTime.toString(),
                                style: const TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ListTile(
                              leading: const Icon(
                                Icons.person, color: MyColors.grey_3,),
                              title: Text(isEnglish ? 'Doctor' : 'የሀኪም ስም',
                                style: TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                              trailing: Text(isEnglish
                                  ? results[index].nameEn.toString()
                                  : results[index].nameAm.toString(),
                                style: const TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ListTile(
                              leading: const Icon(
                                Icons.date_range, color: MyColors.grey_3,),
                              title: Text(isEnglish ? 'Date' : 'የቀጠሮ ቀን',
                                style: TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                              trailing: Text(results[index].selectedDate.toString(),
                                style: const TextStyle(
                                  color: MyColors.grey_3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),



              );
            });
      }
      
  }

}