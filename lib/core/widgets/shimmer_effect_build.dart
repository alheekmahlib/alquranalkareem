import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectBuild extends StatelessWidget {
  const ShimmerEffectBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          Container(
            height: 15,
            width: 130,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) => Container(
                height: 15,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            ),
          ),
          Container(
            height: 15,
            width: 130,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) => Container(
                height: 15,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            ),
          ),
          Container(
            height: 15,
            width: 130,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) => Container(
                height: 15,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
