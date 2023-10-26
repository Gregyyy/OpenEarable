// ignore_for_file: unnecessary_this

import 'dart:async';
import 'dart:math';

import 'package:open_earable/apps/posture_tracker/model/attitude.dart';
import 'package:open_earable/apps/posture_tracker/model/attitude_tracker.dart';

class MockAttitudeTracker extends AttitudeTracker {
  Stream<Attitude> _attitudeStream = Stream.empty();
  StreamSubscription<Attitude>? _attitudeSubscription;

  @override
  bool get isTracking => this._attitudeSubscription != null && !this._attitudeSubscription!.isPaused; 

  MockAttitudeTracker({Function(AttitudeTracker)? didChangeAvailability}) : super() {
    this._attitudeStream = Stream.periodic(Duration(milliseconds: 100), (count) {
      return Attitude(
        roll: sin(count / 10) * pi / 4,
        pitch: sin(count / 20) * pi / 4,
        yaw: sin(count / 30) * pi / 4
      );
    });
    this.didChangeAvailability = didChangeAvailability ?? (_) { };

    this.didChangeAvailability(this);
  }

  @override
  void start() {
    if (this._attitudeSubscription != null) {
      if (this._attitudeSubscription!.isPaused) {
        this._attitudeSubscription!.resume();
      }
      return;
    }

    this._attitudeSubscription = this._attitudeStream.listen((value) {
      this.attitudeStreamController.add(value);
    });
  }

  @override
  void stop() {
    this._attitudeSubscription?.pause();
  }

  @override
  void cancle() {
    this._attitudeSubscription?.cancel();
    super.cancle();
  }
}