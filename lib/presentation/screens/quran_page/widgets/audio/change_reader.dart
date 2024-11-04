part of '../../quran.dart';

class ChangeReader extends StatelessWidget {
  const ChangeReader({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.over,
      child: Semantics(
        button: true,
        enabled: true,
        label: 'Change Font Size',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
                  '${ayahReaderInfo[AudioController.instance.state.readerIndex.value]['name']}'
                      .tr,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 13,
                      fontFamily: 'kufi'),
                )),
            Semantics(
              button: true,
              enabled: true,
              label: 'Change Reader',
              child: Icon(Icons.keyboard_arrow_down_outlined,
                  size: 20, color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      itemBuilder: (context) => List.generate(
          ayahReaderInfo.length,
          (index) => PopupMenuItem(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ListTile(
                  title: Text(
                    '${ayahReaderInfo[index]['name']}'.tr,
                    style: TextStyle(
                        color: AudioController.instance.state.readerValue ==
                                ayahReaderInfo[index]['readerD']
                            ? Theme.of(context).colorScheme.inversePrimary
                            : const Color(0xffcdba72),
                        fontSize: 14,
                        fontFamily: "kufi"),
                  ),
                  trailing: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AudioController.instance.state.readerValue ==
                                  ayahReaderInfo[index]['readerD']
                              ? Theme.of(context).colorScheme.inversePrimary
                              : const Color(0xffcdba72),
                          width: 2),
                      // color: const Color(0xff39412a),
                    ),
                    child: AudioController.instance.state.readerValue ==
                            ayahReaderInfo[index]['readerD']
                        ? Icon(Icons.done,
                            size: 14,
                            color: Theme.of(context).colorScheme.inversePrimary)
                        : null,
                  ),
                  onTap: () async =>
                      await AudioController.instance.changeReadersOnTap(index),
                  leading: Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/${ayahReaderInfo[index]['readerI']}.jpg'),
                          fit: BoxFit.fitWidth,
                          opacity: AudioController.instance.state.readerValue ==
                                  ayahReaderInfo[index]['readerD']
                              ? 1
                              : .4,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 2)),
                  ),
                ),
              )),
    );
  }
}
