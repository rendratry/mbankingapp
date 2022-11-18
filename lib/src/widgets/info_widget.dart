import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final Map<String, dynamic> map;

  const InfoWidget({
    Key? key,
    required this.map,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => map.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: map.keys.map((key) {
            final value = map[key];

            return Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    key,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$value',
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
}
