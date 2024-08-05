import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/domain/entities/movie/movie_detail.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/box_wapper.dart';
import 'package:flutter/material.dart';

class GenresWidget extends StatelessWidget {
  final List<Genre> _genres;

  const GenresWidget({super.key, required List<Genre> genre}) : _genres = genre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _genres.isNotEmpty
          ? const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0)
          : const EdgeInsets.all(0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Genres',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8.0),
        Row(
            children: _genres
                .map((item) => BoxWapper(
                    borderRadius: 16.0,
                    title: '${item.name}',
                    color: HexColor.fromHex('7F7D83')))
                .toList()),
      ]),
    );
  }
}
