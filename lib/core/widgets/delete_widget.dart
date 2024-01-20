import 'package:flutter/material.dart';

import '../services/l10n/app_localizations.dart';

class DeleteWidget extends StatelessWidget {
  const DeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 55,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.close_outlined,
                color: Colors.white,
                size: 18,
              ),
              Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.close_outlined,
                color: Colors.white,
                size: 18,
              ),
              Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
