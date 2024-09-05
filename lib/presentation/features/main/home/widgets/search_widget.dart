import 'package:auth_flow_flutter_rxdart/common/extensions/bloc_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_bloc.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/profile/profile_state.dart';

const String icSearch = AppImages.icSearch;

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    return StreamBuilder(
        stream: profileBloc?.getProfileMessage$,
        builder: (context, snapshot) {
          return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data is ProfileSuccess
                            ? "Welcome, ${snapshot.data?.data.displayName} 🤟"
                            : '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Let's relax and watch a movie!",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: HexColor.fromHex('7F7D83')),
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    icSearch,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    fit: BoxFit.scaleDown,
                    width: 24.0,
                    height: 24.0,
                  ),
                ],
              ));
        });
  }
}
