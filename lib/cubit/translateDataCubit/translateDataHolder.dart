import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '_cubit.dart';

class TranslateDataHolder extends StatefulWidget {
  final Widget child;

  const TranslateDataHolder({Key? key, required this.child}) : super(key: key);

  @override
  TranslateDataHolderState createState() => TranslateDataHolderState();
}

class TranslateDataHolderState extends State<TranslateDataHolder> {
  late final TranslateDataCubit translateDataCubit;

  @override
  void initState() {
    super.initState();
    translateDataCubit = TranslateDataCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: translateDataCubit,
      child: widget.child,
    );
  }
}
