// part of '../../quran.dart';

// class ChangeTranslate extends StatelessWidget {
//   ChangeTranslate({super.key});
//   final translateCtrl = TranslateDataController.instance;

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       position: PopupMenuPosition.under,
//       child: Semantics(
//         button: true,
//         enabled: true,
//         label: 'Change Font Size',
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Semantics(
//               button: true,
//               enabled: true,
//               label: 'Change Reader',
//               child: Icon(Icons.keyboard_arrow_down_outlined,
//                   size: 20, color: Theme.of(context).colorScheme.primary),
//             ),
//             Obx(() => Text(
//                   QuranLibrary()
//                       .tafsirNameList[translateCtrl.transValue.value]
//                       .name,
//                   style: TextStyle(
//                       color: Theme.of(context).colorScheme.surface,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'kufi'),
//                 )),
//           ],
//         ),
//       ),
//       color: Theme.of(context).colorScheme.primaryContainer,
//       itemBuilder: (context) =>
//           List.generate(QuranLibrary().tafsirNameList.length, (index) {
//         // final index = i + 5;
//         return PopupMenuItem(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Obx(
//             () => Semantics(
//               button: true,
//               enabled: true,
//               excludeSemantics: true,
//               label: QuranLibrary().tafsirNameList[index].name,
//               child: ListTile(
//                 title: Text(
//                   QuranLibrary().tafsirNameList[index].name,
//                   style: TextStyle(
//                       color: translateCtrl.transValue.value == index
//                           ? Theme.of(context).primaryColorLight
//                           : const Color(0xffcdba72),
//                       fontSize: 14,
//                       fontFamily: "kufi"),
//                 ),
//                 trailing: Container(
//                   height: 20,
//                   width: 20,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(2.0)),
//                     border: Border.all(
//                         color: translateCtrl.transValue.value == index
//                             ? Theme.of(context).primaryColorLight
//                             : const Color(0xffcdba72),
//                         width: 2),
//                     color: const Color(0xff39412a),
//                   ),
//                   child: translateCtrl.transValue.value == index
//                       ? const Icon(Icons.done,
//                           size: 14, color: Color(0xffcdba72))
//                       : null,
//                 ),
//                 onTap: () => QuranLibrary().changeTafsirSwitch(index),
//                 leading: Container(
//                     height: 85.0,
//                     width: 41.0,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(4.0)),
//                         border: Border.all(
//                             color: Theme.of(context).dividerColor, width: 2)),
//                     child: Opacity(
//                       opacity: translateCtrl.transValue.value == index ? 1 : .4,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           customSvg(SvgPath.svgBookBack),
//                           customSvgWithCustomColor(SvgPath.svgLeftBook),
//                           Container(
//                             height: 60.h,
//                             width: 50.0,
//                             alignment: Alignment.center,
//                             child: Text(
//                               QuranLibrary().tafsirNameList[index].name,
//                               style: TextStyle(
//                                 fontSize: 8.0,
//                                 fontFamily: 'kufi',
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).canvasColor,
//                                 height: 1.5,
//                               ),
//                               maxLines: 3,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
