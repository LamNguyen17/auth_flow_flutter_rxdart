import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_reservation/widgets/projector_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_reservation/widgets/select_date_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_reservation/widgets/select_seat_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_reservation/widgets/select_time_widget.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_bar.dart';

class MovieReservationScreen extends StatefulWidget {
  const MovieReservationScreen({super.key});

  @override
  _MovieReservationScreenState createState() => _MovieReservationScreenState();
}

class _MovieReservationScreenState extends State<MovieReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(
                  parent: Platform.isIOS
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics()),
              slivers: const <Widget>[
                SliverToBoxAdapter(child: ProjectorWidget()),
                SliverToBoxAdapter(child: SelectSeatWidget()),
                SliverToBoxAdapter(child: SelectDateWidget()),
                SliverToBoxAdapter(child: SelectTimeWidget()),
                SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total price',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp 100.000',
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: const Text('Buy Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400)),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
