// import 'package:flutter/material.dart';

// import 'package:sched_master/services/server.dart';
// import 'package:sched_master/class/replacements_history.dart';

// import 'package:sched_master/screen/error_screen.dart';
// import 'package:sched_master/screen/loading_screen.dart';

// class HistoryScreen extends StatelessWidget {
//   const HistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'История замен БГЛК',
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<ReplacementsHistory>>(
//         future: getHistoryReplacement(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const LoadingScreen();
//           } else if (snapshot.hasError) {
//             return const ErrorScreen();
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const ErrorScreen();
//           } else {
//             final replacements = snapshot.data!;

//             return SingleChildScrollView(
//               child: Column(
//                 children: replacements.map((day) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ExpansionTile(
//                           title: Text(
//                             'Замены на ${day.data}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromRGBO(64, 64, 64, 1),
//                             ),
//                           ),
//                           children: [
//                             Card(
//                               color: Colors.white,
//                               margin: const EdgeInsets.symmetric(vertical: 4.0),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15.0),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Row(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             'Группа',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(155, 155, 155, 1),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             'Пара',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(155, 155, 155, 1),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Text(
//                                             'На что заменили',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(155, 155, 155, 1),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Text(
//                                             'Что заменили',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(155, 155, 155, 1),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             'Ауд.',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(155, 155, 155, 1),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const Divider(
//                                       color: Color.fromRGBO(194, 194, 194, 1),
//                                       thickness: 1,
//                                     ),
//                                     Column(
//                                       children: List.generate(day.replacement.length, (index) {
//                                         final replacement = day.replacement[index];
//                                         return Column(
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.symmetric(vertical: 4.0),
//                                               child: Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                                 children: [
//                                                   Expanded(
//                                                     flex: 1,
//                                                     child: Text(
//                                                       replacement[0],
//                                                       textAlign: TextAlign.center,
//                                                       style: const TextStyle(
//                                                         fontSize: 13,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     flex: 1,
//                                                     child: Text(
//                                                       replacement[1],
//                                                       textAlign: TextAlign.center,
//                                                       style: const TextStyle(
//                                                         fontSize: 13,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     flex: 2,
//                                                     child: Text(
//                                                       replacement[3],
//                                                       textAlign: TextAlign.center,
//                                                       overflow: TextOverflow.ellipsis,
//                                                       style: const TextStyle(
//                                                         fontSize: 13,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     flex: 2,
//                                                     child: Text(
//                                                       replacement[5],
//                                                       textAlign: TextAlign.center,
//                                                       overflow: TextOverflow.ellipsis,
//                                                       style: const TextStyle(
//                                                         fontSize: 13,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Expanded(
//                                                     flex: 1,
//                                                     child: Text(
//                                                       replacement[2], 
//                                                       textAlign: TextAlign.center,
//                                                       style: const TextStyle(
//                                                         fontSize: 13,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             if (index != day.replacement.length - 1)
//                                               const Divider(
//                                                 color: Color.fromRGBO(219, 219, 220, 1),
//                                                 thickness: 1,
//                                               ),
//                                           ],
//                                         );
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
