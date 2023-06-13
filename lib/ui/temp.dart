
// import 'dart:math';

// import 'package:patientapp/doctor/doctorInfo.dart';
// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class doctorList extends StatefulWidget {
//   Map<String, String>? medicalArea;
//   Map<String, String>? allArea;
//   // final String patientName;
//   final String phone;
//   final String? id;
//   doctorList(
//       {Key? key,
//       required this.medicalArea,
//       required this.allArea,
//       required this.phone,
//       required this.id})
//       : super(key: key);

//   @override
//   _doctorListState createState() => _doctorListState();
// }

// class _doctorListState extends State<doctorList> {
//   double roundDouble(double value, int places) {
//     num mod = pow(10.0, places);
//     return ((value * mod).round().toDouble() / mod);
//   }

//   // List area = [];
//   Map<String, int> names = {};
//   bool isPresseed = false;

//   TextEditingController searchController = TextEditingController();
//   TextEditingController editingController = TextEditingController();

//   final key = new GlobalKey<ScaffoldState>();

//   final TextEditingController _filter = new TextEditingController();

//   int minexp = 0, maxexp = 1000, minfees = 0, maxfees = 10000;
//   String? filterUrl;

//   @override
//   void initState() {
//     String day = DateFormat('EEEE').format(DateTime.now()).substring(0, 3);
//     DateTime date = DateTime.now();
//     String str = date.toString().substring(11, 16);
//     print("Day is: $day  and str is:$str ${widget.medicalArea?.keys.toString().runtimeType}");
//     var a  = widget.medicalArea?.entries.toList();
//     print('object ${a![0].key}');
//     filterUrl = 'https://doctor2-kylo.herokuapp.com/doctor/info/all?medical_areas=${a[0].key}';
//     super.initState();

//     print('${widget.medicalArea} ${widget.id} ${widget.phone}');
//     names.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var rating = 0.0;
//     var count = 0;
//     final String _name;
//     final String _experience;
//     String _imgURL;
//     String? _medicalAreas;
//     var rat = 0.0;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           "Doctors",
//           style: GoogleFonts.museoModerno(fontSize: 18.0, color: Colors.black),
//         ),
//         centerTitle: true,
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15.0),
//             child: IconButton(
//               onPressed: () {
//                 filter();
//               },
//               icon: Icon(Icons.tune),
//               color: Colors.black,
//             ),
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Column(children: [
//           Container(
//               child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: new Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               color: Color.fromARGB(255, 209, 207, 207),
//               child: ListTile(
//                 leading: Icon(Icons.search),
//                 title: TextField(
//                   // textDirection: TextDirection.LTR,
//                   controller: searchController,
//                   decoration: InputDecoration(
//                       hintText: 'Search', border: InputBorder.none),
//                   onChanged: (a) {
//                     setState(() {
//                       // searchController.text = a;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           )),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: doctorInfor,
//               child: FutureBuilder(
//                   future: doctorInfor(),
//                   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     if (snapshot.hasData) {
//                       return ListView.builder(
//                           itemCount: snapshot.data['data'].length,
//                           itemBuilder: (context, index) {
//                             bool ok = false;
//                             var exp = snapshot.data['data'][index]
//                                 ['experience_years'];
//                             bool _yoe = false;
//                             if (exp != null) {
//                               _yoe = true;
//                             }
//                             // area.clear();
//                             List? area =
//                                 snapshot.data['data'][index]['medical_areas'];

//                             // if (area != null && area.length >= 1) {
//                               Map<String, dynamic>? wHrs = {};
//                               bool wH = false;
//                               if (snapshot.data['data'][index]
//                                       ['working_hours'] !=
//                                   null) {
//                                 wH = true;
//                                 wHrs = Map<String, dynamic>.from(snapshot
//                                     .data['data'][index]['working_hours']);
//                               }

//                               bool wHours = false;
//                               if (snapshot.data['data'][index]
//                                       ['working_hours'] !=
//                                   null) {
//                                 wHours = true;
//                               }

//                               List? specialityList = [];

//                               var spec = widget.medicalArea?.entries.toList()[0].value;


//                               // for (var i = 0;
//                               //     i <
//                               //         snapshot
//                               //             .data['data'][index]['medical_areas']
//                               //             .length;
//                               //     i++) {
//                               //   if (widget.medicalArea?.containsKey(
//                               //           snapshot.data['data'][index]
//                               //               ['medical_areas'][i]) ==
//                               //       true) {
//                               //     ok = true;
//                               //     specialityList.add(widget.allArea![
//                               //         snapshot.data['data'][index]
//                               //             ['medical_areas'][i]]);
//                               //     // break;
//                               //   }
//                               // }

//                               // if (ok == true) {
//                                 _imgURL =
//                                     snapshot.data['data'][index]['profile_url'];

//                                 String fee = snapshot.data['data'][index]['fee']
//                                     .toString();
//                                 if (fee == null) {
//                                   fee = 0.toString();
//                                 }
//                                 List isInstant = ['ds'];
//                                 // List isInstant=snapshot.data['c_a_list'][index];
//                                 print('instant ${isInstant}');

//                                 if (snapshot.data['data'].length == 0) {
//                                   return Center(
//                                       child: Text('No Doctor Available'));
//                                 } else {
//                                   if (searchController.text.isEmpty) {
//                                     return ExpandableNotifier(
//                                       child: Card(
//                                         color: Colors.grey[50],
//                                         shape: RoundedRectangleBorder(
//                                           side: BorderSide(color: Colors.white),
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Material(
//                                               // elevation: 2,
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(20)),
//                                               child: Container(
//                                                 height: MediaQuery.of(context)
//                                                         .size
//                                                         .height *
//                                                     0.26,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(20)),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Container(
//                                                         height: 30,
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Text(
//                                                               "${snapshot.data['data'][index]['name']}",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize: 15),
//                                                             ),
//                                                             Container(
//                                                               height: 25,
//                                                               child: ElevatedButton
//                                                                   .icon(
//                                                                       style: ElevatedButton.styleFrom(
//                                                                           primary: Colors
//                                                                               .green,
//                                                                           padding: EdgeInsets.all(
//                                                                               0)),
//                                                                       onPressed:
//                                                                           () {},
//                                                                       icon:
//                                                                           Icon(
//                                                                         Icons
//                                                                             .star,
//                                                                         color: Colors
//                                                                             .white,
//                                                                         size:
//                                                                             17,
//                                                                       ),
//                                                                       label: Text(
//                                                                           "${roundDouble(snapshot.data['data'][index]['approval_rating']['avg'].toDouble(), 2)}",
//                                                                           style: TextStyle(
//                                                                               color: Colors.white,
//                                                                               fontSize: 12,
//                                                                               fontWeight: FontWeight.w500))),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Divider(
//                                                         thickness: 1,
//                                                         color: Colors.grey,
//                                                         height: 10,
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           CircleAvatar(
//                                                             backgroundImage:
//                                                                 NetworkImage(
//                                                                     "${snapshot.data['data'][index]['profile_url']}"),
//                                                             radius: 55,
//                                                             backgroundColor:
//                                                                 Colors
//                                                                     .transparent,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 30,
//                                                           ),
//                                                           Expanded(
//                                                             child: Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .start,
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                     "Speciality: ${spec}",
//                                                                     style: TextStyle(
//                                                                         color: Colors
//                                                                             .grey,
//                                                                         fontSize:
//                                                                             14)),
//                                                                 Text(
//                                                                   (() {
//                                                                     if (_yoe) {
//                                                                       return "Experience: ${snapshot.data['data'][index]['experience_years']} years";
//                                                                     }

//                                                                     return "Experience: 0 years";
//                                                                   })(),
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 // Text("Consultation Fee: ${snapshot.data['data'][index]['fee']}",
//                                                                 //     style: TextStyle(
//                                                                 //         color: Colors.grey,
//                                                                 //         fontSize: 14)),
//                                                                 Text(
//                                                                   (() {
//                                                                     if (snapshot.data['data'][index]
//                                                                             [
//                                                                             'fee'] ==
//                                                                         null) {
//                                                                       return "Consultation Fee: 0 Rs";
//                                                                     }

//                                                                     return "Consultation Fee: ${snapshot.data['data'][index]['fee']} Rs";
//                                                                   })(),
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 20,
//                                                                 ),
//                                                                 Container(
//                                                                   height: 30,
//                                                                   width: (MediaQuery.of(context)
//                                                                               .size
//                                                                               .width -
//                                                                           10) /
//                                                                       2,
//                                                                   child: ElevatedButton(
//                                                                       style: ElevatedButton.styleFrom(
//                                                                         primary:
//                                                                             Color(0xff3E64FF),
//                                                                         shape:
//                                                                             new RoundedRectangleBorder(
//                                                                           borderRadius:
//                                                                               new BorderRadius.circular(10.0),
//                                                                         ),
//                                                                       ),
//                                                                       child: Text(
//                                                                         "Pay and Consult",
//                                                                         style: TextStyle(
//                                                                             fontSize:
//                                                                                 15),
//                                                                       ),
//                                                                       onPressed: () async {
//                                                                         print(
//                                                                             "Instant List is: ${isInstant}");
//                                                                         await Navigator.push(
//                                                                             context,
//                                                                             MaterialPageRoute(
//                                                                                 builder: (context) => doctorInfo(
//                                                                                       snapshot.data['data'][index]['name'],
//                                                                                       snapshot.data['data'][index]['experience_years'].toString(),
//                                                                                       snapshot.data['data'][index]['approval_rating']['avg'].toDouble(),
//                                                                                       snapshot.data['data'][index]['profile_url'],
//                                                                                       spec,
//                                                                                       wHrs,
//                                                                                       snapshot.data['data'][index]['_id'],
//                                                                                       widget.phone,
//                                                                                       widget.id,
//                                                                                       fee,
//                                                                                       snapshot.data['data'][index]['email'],
//                                                                                       snapshot.data['data'][index]['bio'],
//                                                                                       snapshot.data['data'][index]['phone_number'].toString(),
//                                                                                       snapshot.data['data'][index]['hospital_name'],
//                                                                                       isInstant,
//                                                                                     )));
//                                                                       }),
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .height *
//                                                                       0.02,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                       SizedBox(
//                                                         height: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .height *
//                                                             0.01,
//                                                       ),
//                                                       Divider(
//                                                         thickness: 1,
//                                                         color: Colors.grey,
//                                                         height: 5,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             // SizedBox(height: -10,),
//                                             ScrollOnExpand(
//                                                 scrollOnExpand: true,
//                                                 scrollOnCollapse: false,
//                                                 child: ExpandablePanel(
//                                                     header: Text(
//                                                       "View More",
//                                                       style: TextStyle(
//                                                           color: Colors.grey,
//                                                           fontSize: 14),
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                     collapsed: Container(),
//                                                     expanded: Padding(
//                                                       padding:
//                                                           EdgeInsets.all(10),
//                                                       child: Row(
//                                                         children: [
//                                                           Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Text(
//                                                                 "Gender",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               // Text(
//                                                               //   "Email",
//                                                               //   style: TextStyle(
//                                                               //       color: Colors
//                                                               //           .grey,
//                                                               //       fontSize: 14),
//                                                               //   softWrap: true,
//                                                               // ),
//                                                               Text(
//                                                                 "Age",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               // Text(
//                                                               //   "Mobile",
//                                                               //   style: TextStyle(
//                                                               //       color: Colors
//                                                               //           .grey,
//                                                               //       fontSize: 14),
//                                                               //   softWrap: true,
//                                                               // ),
//                                                               Text(
//                                                                 "Education",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Experience",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Speciality Area",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           VerticalDivider(),
//                                                           Column(
//                                                             children: <Widget>[
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               // SizedBox(height: ,),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               // SizedBox(height: ,),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           VerticalDivider(),
//                                                           Expanded(
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['gender']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 // Text(
//                                                                 //   "${snapshot.data['data'][index]['email']}",
//                                                                 //   style: TextStyle(
//                                                                 //       color: Colors
//                                                                 //           .grey,
//                                                                 //       fontSize:
//                                                                 //           14),
//                                                                 //   softWrap: true,
//                                                                 // ),
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['age']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 // Text(
//                                                                 //   "${snapshot.data['data'][index]['phone_number']}",
//                                                                 //   style: TextStyle(
//                                                                 //       color: Colors
//                                                                 //           .grey,
//                                                                 //       fontSize:
//                                                                 //           14),
//                                                                 //   softWrap: true,
//                                                                 // ),
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['highest_qualification']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 Text(
//                                                                   (() {
//                                                                     if (_yoe) {
//                                                                       return "${snapshot.data['data'][index]['experience_years']} years";
//                                                                     }

//                                                                     return "0 years";
//                                                                   })(),
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),

//                                                                 Text(
//                                                                   "${spec}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     )))
//                                             // SizedBox(
//                                             //   height: 10,
//                                             // ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   } else if (snapshot.data['data'][index]
//                                               ['name']
//                                           .toString()
//                                           .toLowerCase()
//                                           .contains(searchController.text) ||
//                                       snapshot.data['data'][index]['name']
//                                           .toString()
//                                           .toUpperCase()
//                                           .contains(searchController.text) ||
//                                       snapshot.data['data'][index]['name']
//                                           .toString()
//                                           .contains(searchController.text)) {
//                                     return ExpandableNotifier(
//                                       child: Card(
//                                         color: Colors.grey[50],
//                                         shape: RoundedRectangleBorder(
//                                           side: BorderSide(color: Colors.white),
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Material(
//                                               // elevation: 2,
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(20)),
//                                               child: Container(
//                                                 height: MediaQuery.of(context)
//                                                         .size
//                                                         .height *
//                                                     0.26,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(20)),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Container(
//                                                         height: 30,
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Text(
//                                                               "${snapshot.data['data'][index]['name']}",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize: 15),
//                                                             ),
//                                                             Container(
//                                                               height: 25,
//                                                               child: ElevatedButton
//                                                                   .icon(
//                                                                       style: ElevatedButton.styleFrom(
//                                                                           primary: Colors
//                                                                               .green,
//                                                                           padding: EdgeInsets.all(
//                                                                               0)),
//                                                                       onPressed:
//                                                                           () {},
//                                                                       icon:
//                                                                           Icon(
//                                                                         Icons
//                                                                             .star,
//                                                                         color: Colors
//                                                                             .white,
//                                                                         size:
//                                                                             17,
//                                                                       ),
//                                                                       label: Text(
//                                                                           "${roundDouble(snapshot.data['data'][index]['approval_rating']['avg'].toDouble(), 2)}",
//                                                                           style: TextStyle(
//                                                                               color: Colors.white,
//                                                                               fontSize: 12,
//                                                                               fontWeight: FontWeight.w500))),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Divider(
//                                                         thickness: 1,
//                                                         color: Colors.grey,
//                                                         height: 10,
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           CircleAvatar(
//                                                             backgroundImage:
//                                                                 NetworkImage(
//                                                                     "${snapshot.data['data'][index]['profile_url']}"),
//                                                             radius: 55,
//                                                             backgroundColor:
//                                                                 Colors
//                                                                     .transparent,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 30,
//                                                           ),
//                                                           Expanded(
//                                                             child: Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .start,
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                     "Speciality: ${spec}",
//                                                                     style: TextStyle(
//                                                                         color: Colors
//                                                                             .grey,
//                                                                         fontSize:
//                                                                             14)),
//                                                                 Text(
//                                                                   (() {
//                                                                     if (_yoe) {
//                                                                       return "Experience: ${snapshot.data['data'][index]['experience_years']} years";
//                                                                     }

//                                                                     return "Experience: 0 years";
//                                                                   })(),
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 // Text("Consultation Fee: ${snapshot.data['data'][index]['fee']}",
//                                                                 //     style: TextStyle(
//                                                                 //         color: Colors.grey,
//                                                                 //         fontSize: 14)),
//                                                                 Text(
//                                                                   (() {
//                                                                     if (snapshot.data['data'][index]
//                                                                             [
//                                                                             'fee'] ==
//                                                                         null) {
//                                                                       return "Consultation Fee: 0 Rs";
//                                                                     }

//                                                                     return "Consultation Fee: ${snapshot.data['data'][index]['fee']} Rs";
//                                                                   })(),
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 20,
//                                                                 ),
//                                                                 Container(
//                                                                   height: 30,
//                                                                   width: (MediaQuery.of(context)
//                                                                               .size
//                                                                               .width -
//                                                                           10) /
//                                                                       2,
//                                                                   child: ElevatedButton(
//                                                                       style: ElevatedButton.styleFrom(
//                                                                         primary:
//                                                                             Color(0xff3E64FF),
//                                                                         shape:
//                                                                             new RoundedRectangleBorder(
//                                                                           borderRadius:
//                                                                               new BorderRadius.circular(10.0),
//                                                                         ),
//                                                                       ),
//                                                                       child: Text(
//                                                                         "Pay and Consult",
//                                                                         style: TextStyle(
//                                                                             fontSize:
//                                                                                 15),
//                                                                       ),
//                                                                       onPressed: () async {
//                                                                         print(
//                                                                             "Instant List is: ${isInstant}");
//                                                                         await Navigator.push(
//                                                                             context,
//                                                                             MaterialPageRoute(
//                                                                                 builder: (context) => doctorInfo(
//                                                                                       snapshot.data['data'][index]['name'],
//                                                                                       snapshot.data['data'][index]['experience_years'].toString(),
//                                                                                       snapshot.data['data'][index]['approval_rating']['avg'].toDouble(),
//                                                                                       snapshot.data['data'][index]['profile_url'],
//                                                                                       spec,
//                                                                                       wHrs,
//                                                                                       snapshot.data['data'][index]['_id'],
//                                                                                       widget.phone,
//                                                                                       widget.id,
//                                                                                       fee,
//                                                                                       snapshot.data['data'][index]['email'],
//                                                                                       snapshot.data['data'][index]['bio'],
//                                                                                       snapshot.data['data'][index]['phone_number'].toString(),
//                                                                                       snapshot.data['data'][index]['hospital_name'],
//                                                                                       isInstant,
//                                                                                     )));
//                                                                       }),
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .height *
//                                                                       0.02,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                       SizedBox(
//                                                         height: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .height *
//                                                             0.01,
//                                                       ),
//                                                       Divider(
//                                                         thickness: 1,
//                                                         color: Colors.grey,
//                                                         height: 5,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             // SizedBox(height: -10,),
//                                             ScrollOnExpand(
//                                                 scrollOnExpand: true,
//                                                 scrollOnCollapse: false,
//                                                 child: ExpandablePanel(
//                                                     header: Text(
//                                                       "View More",
//                                                       style: TextStyle(
//                                                           color: Colors.grey,
//                                                           fontSize: 14),
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                     collapsed: Container(),
//                                                     expanded: Padding(
//                                                       padding:
//                                                           EdgeInsets.all(10),
//                                                       child: Row(
//                                                         children: [
//                                                           Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Text(
//                                                                 "Gender",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Email",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Age",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Mobile",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Education",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Experience",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                               Text(
//                                                                 "Speciality Area",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontSize:
//                                                                         14),
//                                                                 softWrap: true,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           VerticalDivider(),
//                                                           Column(
//                                                             children: <Widget>[
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               // SizedBox(height: ,),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               // SizedBox(height: ,),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                               Text(
//                                                                 ":",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           VerticalDivider(),
//                                                           Expanded(
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['gender']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['email']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['age']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['phone_number']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 Text(
//                                                                   "${snapshot.data['data'][index]['highest_qualification']}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 Text(
//                                                                   (() {
//                                                                     if (_yoe) {
//                                                                       return "${snapshot.data['data'][index]['experience_years']} years";
//                                                                     }

//                                                                     return "0 years";
//                                                                   })(),
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                                 Text(
//                                                                   "${spec}",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .grey,
//                                                                       fontSize:
//                                                                           14),
//                                                                   softWrap:
//                                                                       true,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     )))
//                                             // SizedBox(
//                                             //   height: 10,
//                                             // ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     return Center(
//                                         child: Text('No Doctor Available'));
//                                   }
//                                 }
//                                 // }
//                                 // else
//                                 // {
//                                 //   return Container();
//                                 // }
//                               // } else {
//                               //   return Center(
//                               //     child: Container(),
//                               //   );
//                               // }
//                             // }
//                             // // }
//                             // else {
//                             //   return Center(
//                             //     child: Container(),
//                             //   );
//                             // }
//                           });
//                     } else if (snapshot.data == null) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.data == 'Data Not Availble') {
//                       return Center(
//                         child: Text('No data available'),
//                       );
//                     } else {
//                       return Center(
//                         child: Text('No data available'),
//                       );
//                     }
//                   }),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   Future filter() async {
//     //String? filterLocal;
//     TextEditingController minexp1 = TextEditingController();
//     TextEditingController maxexp1 = TextEditingController();
//     TextEditingController minfees1 = TextEditingController();
//     TextEditingController maxfees1 = TextEditingController();
//     return showDialog(
//         context: context,
//         builder: ((BuildContext context) {
//           return AlertDialog(
//             //content: Text('Select where you want to capture the image from'),
//             title: Container(
//               height: 250,
//               child: SingleChildScrollView(
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * .53,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Filter By',
//                         style: GoogleFonts.poppins(
//                             color: Color(0xff3E64FF),
//                             fontSize: 20,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                         height: 40,
//                         width: 250,
//                         child: TextFormField(
//                           controller: minexp1,
//                           maxLines: 1,
//                           textAlign: TextAlign.start,
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                           // onChanged: (value) => setState(() {
//                           //   filterLocal = value;
//                           // }),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xff3E64FF),
//                             hintText: "Enter Min Experience",
//                             isDense: true,
//                             contentPadding: EdgeInsets.all(10),
//                             hintStyle: GoogleFonts.poppins(
//                                 textStyle: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500)),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Container(
//                         height: 40,
//                         width: 250,
//                         child: TextFormField(
//                           controller: maxexp1,
//                           maxLines: 1,
//                           textAlign: TextAlign.start,
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                           // onChanged: (value) => setState(() {
//                           //   filterLocal = value;
//                           // }),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xff3E64FF),
//                             hintText: "Enter Max Experience",
//                             isDense: true,
//                             contentPadding: EdgeInsets.all(10),
//                             hintStyle: GoogleFonts.poppins(
//                                 textStyle: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500)),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Container(
//                         height: 40,
//                         width: 250,
//                         child: TextFormField(
//                           controller: minfees1,
//                           maxLines: 1,
//                           textAlign: TextAlign.start,
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xff3E64FF),
//                             hintText: "Enter Min Fees",
//                             isDense: true,
//                             contentPadding: EdgeInsets.all(10),
//                             hintStyle: GoogleFonts.poppins(
//                                 textStyle: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500)),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Container(
//                         height: 40,
//                         width: 250,
//                         child: TextField(
//                           controller: maxfees1,
//                           maxLines: 1,
//                           textAlign: TextAlign.start,
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                           // onChanged: (value) => setState(() {
//                           //   filterLocal = value;
//                           // }),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xff3E64FF),
//                             hintText: "Enter Max Fees",
//                             isDense: true,
//                             contentPadding: EdgeInsets.all(10),
//                             hintStyle: GoogleFonts.poppins(
//                                 textStyle: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500)),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                           onPressed: () async {
//                             setState(() {
//                               // print(' valure ${minexp1.text} ${maxexp1.text} $minfees1.text} ${maxfees1.text}');
//                               // minexp = int.parse(minexp1.text.isEmpty? '0': minexp1.text);
//                               minexp = int.parse(
//                                   minexp1.text.isEmpty ? '0' : minexp1.text);
//                               // print('${minexp.runtimeType} ${int.parse()}');
//                               maxexp = int.parse(
//                                   maxexp1.text.isEmpty ? '1000' : maxexp1.text);
//                               minfees = int.parse(
//                                   minfees1.text.isEmpty ? '0' : minfees1.text);
//                               maxfees = int.parse(maxfees1.text.isEmpty
//                                   ? '10000'
//                                   : maxfees1.text);
//                               // doctorInfoFilter(
//                               //     minexp, maxexp, minfees, maxfees);
//                               print(
//                                   'aa ${minexp} ${maxexp} ${minfees} ${maxfees}');

//                               if (minexp != 0 &&
//                                   maxexp == 1000 &&
//                                   minfees == 0 &&
//                                   maxfees == 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp';
//                               } else if (minexp == 0 &&
//                                   maxexp != 1000 &&
//                                   minfees == 0 &&
//                                   maxfees == 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_max=$maxexp';
//                               } else if (minexp == 0 &&
//                                   maxexp == 1000 &&
//                                   minfees != 0 &&
//                                   maxfees == 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?fees_min=$minfees';
//                               } else if (minexp == 0 &&
//                                   maxexp == 1000 &&
//                                   minfees == 0 &&
//                                   maxfees != 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?fees_max=$maxfees';
//                               } else if (minexp != 0 &&
//                                   maxexp != 1000 &&
//                                   minfees == 0 &&
//                                   maxfees == 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp';
//                               } else if (minexp != 0 &&
//                                   maxexp == 1000 &&
//                                   minfees != 0 &&
//                                   maxfees == 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&fee_min=$minfees';
//                               } else if (minexp != 0 &&
//                                   maxexp == 1000 &&
//                                   minfees == 0 &&
//                                   maxfees != 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&fee_max=$maxfees';
//                               } else if (minexp == 0 &&
//                                   maxexp != 1000 &&
//                                   minfees != 0 &&
//                                   maxfees == 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_max=$maxexp&fee_min=$minfees';
//                               } else if (minexp == 0 &&
//                                   maxexp != 1000 &&
//                                   minfees == 0 &&
//                                   maxfees != 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_max=$maxexp&fee_max=$maxfees';
//                               } else if (minexp == 0 &&
//                                   maxexp == 1000 &&
//                                   minfees != 0 &&
//                                   maxfees != 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?fee_min=$minfees&fee_max=$maxfees';
//                               } else if (minexp != 0 &&
//                                   maxexp != 1000 &&
//                                   minfees != 0 &&
//                                   maxfees == 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees';
//                               } else if (minexp != 0 &&
//                                   maxexp != 1000 &&
//                                   minfees == 0 &&
//                                   maxfees != 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_max=$maxfees';
//                               } else if (minexp == 0 &&
//                                   maxexp != 1000 &&
//                                   minfees != 0 &&
//                                   maxfees != 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                               } else if (minexp != 0 &&
//                                   maxexp == 1000 &&
//                                   minfees != 0 &&
//                                   maxfees != 10000) {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&fee_min=$minfees&fee_max=$maxfees';
//                               } else {
//                                 print('inside minexp');
//                                 // filterUrl =
//                                 //   'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                                 filterUrl =
//                                     'https://doctor2-kylo.herokuapp.com/doctor/info/all?experience_years_min=$minexp&experience_years_max=$maxexp&fee_min=$minfees&fee_max=$maxfees';
//                               }

//                               print('${filterUrl}');
//                               isPresseed = true;
//                             });
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: Size(250, 40),
//                             primary: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                           ),
//                           child: Text(
//                             "Apply Filter",
//                             style: GoogleFonts.poppins(
//                               textStyle: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           )),
//                       SizedBox(height: 15),
//                       ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               String day = DateFormat('EEEE')
//                                   .format(DateTime.now())
//                                   .substring(0, 3);
//                               DateTime date = DateTime.now();
//                               String str = date.toString().substring(11, 16);
//                               print("Day is: $day  and str is:$str ");
//                               print("Inside Info");
//                               filterUrl =
//                                   'https://doctor2-kylo.herokuapp.com/doctor/info/all';
//                             });
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: Size(250, 40),
//                             primary: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                           ),
//                           child: Text(
//                             'Remove Filter',
//                             style: GoogleFonts.poppins(
//                               textStyle: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ).build(context);
//         }));
//     // showDialog<AlertDialog>(context: context, a);
//   }

//   Future doctorInfor() async {
//     // String day = DateFormat('EEEE').format(DateTime.now()).substring(0, 3);
//     // DateTime date = DateTime.now();
//     // String str = date.toString().substring(11, 16);
//     // print("Day is: $day  and str is:$str ");
//     // print("Inside Info");
//     var client = http.Client();

//     var b = 'Data Not Availble';

//     var doctor_Info = await client.get(Uri.parse(filterUrl!));

//     print('in function ${filterUrl}');
//     var a = json.decode(doctor_Info.body);
//     print('func $a');
//     if (doctor_Info.statusCode == 200) {
//       return json.decode(doctor_Info.body);
//     } else {
//       return b;
//     }
//   }
// }


