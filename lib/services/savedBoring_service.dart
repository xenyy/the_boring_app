import 'dart:math';

import 'package:the_boring_app/models/boringActivity_model.dart';
import 'package:flutter_riverpod/all.dart';

final savedBoringServiceProvider =
    Provider<SavedBoringService>((ref) => SavedBoringService());

abstract class SavedBoringServices {
  Future<List<BoringActivity>> getSavedBoringActivity();

  Future<void> addSavedBoringActivity(BoringActivity boringActivity);

  Future<void> removeSavedBoringActivity(String key);

  Future<void> toggleDoneSaved(String key);

  Future<void> deleteAllSaved();
}

class SavedBoringActivityException implements Exception {
  const SavedBoringActivityException(this.error);

  final String error;

  @override
  String toString() {
    return '''Saved Boring Activity Error: $error''';
  }
}

const double errorLikelihood = 0.4;

final _savedBoringActivities = [
  /*BoringActivity(
    activity: "Explore a park you have never been to before",
    type: "recreational",
    participants: 1,
    price: 0,
    link: "",
    key: "8159356",
    accessibility: 0,
    saved: true,
    done: false,
  ),
  BoringActivity(
    activity: "Text a friend you haven't talked to in a long time",
    type: "social",
    participants: 2,
    price: 0.05,
    link: "",
    key: "6081071",
    accessibility: 0.2,
    saved: true,
    done: false,
    ),*/
];

class SavedBoringService implements SavedBoringServices {
  SavedBoringService() : random = Random() {
    savedBoringActivitiesStorage = [..._savedBoringActivities];
    //getSavedBoringActivity()
  }

  final Random random;
  List<BoringActivity> savedBoringActivitiesStorage;

  @override
  Future<List<BoringActivity>> getSavedBoringActivity() async {
    await _waitRandomTime();
    // retrieving mock storage
    if (random.nextDouble() < errorLikelihood) {
      throw const SavedBoringActivityException(
          'Saved boring activities could not be return');
    } else {
      return savedBoringActivitiesStorage;
    }
  }

  @override
  Future<void> addSavedBoringActivity(BoringActivity boringActivity) async {
    await _waitRandomTime();
    // add to storage
    if (random.nextDouble() < errorLikelihood) {
      throw const SavedBoringActivityException('Activity could not be saved');
    } else {
      savedBoringActivitiesStorage = [...savedBoringActivitiesStorage]
        ..add(boringActivity);
    }
  }

  @override
  Future<void> removeSavedBoringActivity(String key) async {
    await _waitRandomTime();
    if (random.nextDouble() < errorLikelihood) {
      throw const SavedBoringActivityException('Activity could not be removed');
    } else {
      savedBoringActivitiesStorage =
          savedBoringActivitiesStorage.where((e) => e.key != key).toList();
    }
  }

  @override
  Future<void> toggleDoneSaved(String key) async {
    await _waitRandomTime();
    if (random.nextDouble() < errorLikelihood) {
      //I dont think is necessary this error here IDK
      throw const SavedBoringActivityException('Activity could not be toggled');
    } else {
      savedBoringActivitiesStorage =
          savedBoringActivitiesStorage.map((activity) {
        if (activity.key == key) {
          return BoringActivity(
            activity: activity.activity,
            type: activity.type,
            participants: activity.participants,
            price: activity.price,
            link: activity.link,
            key: activity.key,
            accessibility: activity.accessibility,
            saved: activity.saved,
            done: !activity.done, //toggles bool to opposite
          );
        }
        return activity;
      }).toList();
    }
  }

  @override
  Future<void> deleteAllSaved() async {
    await _waitRandomTime();
    if (random.nextDouble() < errorLikelihood) {
      throw const SavedBoringActivityException(
          'Could not delete saved activities');
    } else {
      savedBoringActivitiesStorage.clear();
    }
  }

  // simulate loading
  Future<void> _waitRandomTime() async {
    await Future.delayed(
      Duration(seconds: random.nextInt(3)),
    );
  }
}
