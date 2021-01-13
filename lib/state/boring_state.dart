import 'package:the_boring_app/models/boringActivity_model.dart';
import 'package:the_boring_app/services/boring_exceptions.dart';
import 'package:the_boring_app/services/boring_service.dart';
import 'package:the_boring_app/services/savedBoring_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//new from api
final boringActivityProvider =
    StateNotifierProvider<BoringNotifier>((ref) => BoringNotifier(ref.read));

class BoringNotifier extends StateNotifier<AsyncValue<BoringActivity>> {
  BoringNotifier(this.read, [AsyncValue<BoringActivity> boringActivity])
      : super(boringActivity ?? const AsyncValue.loading()) {
    getBoringActivity();
  }

  final Reader read;

  Future<void> getBoringActivity() async {
    try {
      final boringActivity =
          await read(boringServiceProvider).getBoringActivity();
      state = AsyncValue.data(boringActivity);
    } on BoringException catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> retryGetBoringActivity() async {
    state = AsyncValue.loading();
    try {
      final boringActivity =
          await read(boringServiceProvider).getBoringActivity();
      state = AsyncValue.data(boringActivity);
    } on BoringException catch (e) {
      state = AsyncValue.error(e);
    }
  }
}

//saved
final savedProvider = Provider<AsyncValue<List<BoringActivity>>>((ref) {
  final savedState = ref.watch(savedBoringActivityProvider.state);
  return savedState.whenData(
      (saved) => saved.where((savedState) => savedState.saved).toList());
});

final savedBoringActivityProvider = StateNotifierProvider<SavedBoringNotifier>(
    (ref) => SavedBoringNotifier(ref.read));

final savedExceptionProvider =
    StateProvider<SavedBoringActivityException>((ref) {
  return null;
});

class SavedBoringNotifier
    extends StateNotifier<AsyncValue<List<BoringActivity>>> {
  SavedBoringNotifier(this.read, [AsyncValue<List<BoringActivity>> saved])
      : super(saved ?? const AsyncValue.loading()) {
    getSavedBoringActivities();
  }

  final Reader read;
  AsyncValue<List<BoringActivity>> previousState;

  Future<void> getSavedBoringActivities() async {
    try {
      final savedBoringActivity =
          await read(savedBoringServiceProvider).getSavedBoringActivity();
      state = AsyncValue.data(savedBoringActivity);
    } on SavedBoringActivityException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> retryGetSavedBoringList() async {
    state = AsyncValue.loading();
    try {
      final savedBoringActivity =
          await read(savedBoringServiceProvider).getSavedBoringActivity();
      state = AsyncValue.data(savedBoringActivity);
    } on SavedBoringActivityException catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> refreshSavedList() async {
    try {
      final savedBoringActivity =
          await read(savedBoringServiceProvider).getSavedBoringActivity();
      state = AsyncValue.data(savedBoringActivity);
    } on SavedBoringActivityException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSavedBoringActivity() async {
    _cacheState(); //save state before change it
    bool repeated = false;
    BoringActivity toSaveActivity;

    read(boringActivityProvider.state).whenData((value) {
      toSaveActivity = BoringActivity(
        activity: value.activity,
        type: value.type,
        participants: value.participants,
        price: value.price,
        link: value.link,
        key: value.key,
        accessibility: value.accessibility,
        saved: true,
      );
      state.whenData((saved) {
        if (saved.map((e) => e.key).contains(toSaveActivity.key)) {
          repeated = true;
          state = AsyncValue.data([...saved]);
          _handleException(
              SavedBoringActivityException('You already saved this activity'));
        } else {
          state = AsyncValue.data([...saved]..add(toSaveActivity));
        }
      });
    });

    try {
      if (!repeated) {
        await read(savedBoringServiceProvider)
            .addSavedBoringActivity(toSaveActivity);
      }
    } on SavedBoringActivityException catch (e) {
      _handleException(e);
      //state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeSavedBoringActivity(String key) async {
    _cacheState();
    state = state
        .whenData((value) => value.where((item) => item.key != key).toList());
    try {
      await read(savedBoringServiceProvider).removeSavedBoringActivity(key);
    } on SavedBoringActivityException catch (e) {
      _handleException(e);
    }
  }

  Future<void> toggleDoneSavedBoringActivity(String key) async {
    _cacheState();

    state = state.whenData(
      (value) => value.map((activity) {
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
      }).toList(),
    );

    try {
      await read(savedBoringServiceProvider).toggleDoneSaved(key);
    } on SavedBoringActivityException catch (e) {
      _handleException(e);
    }
  }

  Future<void> deleteAllSaved() async {
    _cacheState();
    List<BoringActivity> list = [];

    state.whenData((savedList) {
      state = AsyncValue.data(list);
    });

    try {
      await read(savedBoringServiceProvider).deleteAllSaved();
    } on SavedBoringActivityException catch (e) {
      _handleException(e);
    }
  }

  void _cacheState() {
    previousState = state;
  }

  void _resetState() {
    if (previousState != null) {
      state = previousState;
      previousState = null;
    }
  }

  void _handleException(SavedBoringActivityException e) {
    _resetState();
    read(savedExceptionProvider).state = e;
  }
}
