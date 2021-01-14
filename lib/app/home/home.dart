import 'package:another_flushbar/flushbar.dart';

import 'package:the_boring_app/routing/app_router.dart';
import 'package:the_boring_app/services/boring_exceptions.dart';
import 'package:the_boring_app/services/savedBoring_service.dart';
import 'package:the_boring_app/state/boring_state.dart';
import 'package:the_boring_app/state/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer(
            builder: (context, watch, child) {
              final themeIsDark = watch(themeNotifier.state);
              final themeNotify = context.read(themeNotifier);
              return IconButton(
                icon: themeIsDark
                    ? Icon(Icons.wb_sunny_rounded)
                    : Icon(Icons.nightlight_round),
                //color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                onPressed: () {
                  themeNotify.toggleTheme();
                },
                splashRadius: 27,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.save_rounded),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.saved);
              },
              splashRadius: 27,
            ),
          ),
        ],
      ),
      body: ProviderListener<StateController<SavedBoringActivityException>>(
        provider: savedExceptionProvider,
        onChange: (
          BuildContext context,
          StateController<SavedBoringActivityException> exceptionState,
        ) {
          Flushbar(
            message: exceptionState.state.error.toString(),
            isDismissible: false,
            //backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
            icon: Icon(
              Icons.error_outline_rounded,
              size: 27.0,
              color: Colors.red,
            ),
            flushbarStyle: FlushbarStyle.FLOATING,
            margin: EdgeInsets.all(20),
            borderRadius: 8,
            duration: Duration(seconds: 3),
            animationDuration: Duration(milliseconds: 200),
            leftBarIndicatorColor: Colors.red,
          )..show(context);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BoringTitle(),
              BoringTextActivity(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    BoringButton(),
                    SizedBox(width: 10),
                    BoringButtonSave(),
                  ],
                ),
              ),
              BoredApiCredits(),
            ],
          ),
        ),
      ),
    );
  }
}

class BoredApiCredits extends StatelessWidget {
  const BoredApiCredits({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 120, right: 120),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          //
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Using  ',
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            Text(
              'Bored Api',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoringTitle extends StatelessWidget {
  const BoringTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'THE BORING APP',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Theme.of(context).textTheme.headline6.color,
      ),
    );
  }
}

class BoringTextActivity extends StatelessWidget {
  const BoringTextActivity({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Consumer(
            builder: (context, watch, child) {
              final boringActivity = watch(boringActivityProvider.state);
              return boringActivity.when(
                data: (activity) {
                  return Text(
                    activity.activity,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (e, s) {
                  if (e is BoringException) {
                    return _Error(message: e.message);
                  }
                  return _Error(
                    message: 'Oh no! Something unexpected happened',
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              onPressed: () {
                context.read(boringActivityProvider).retryGetBoringActivity();
              },
              child: Text(
                'Try again',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class BoringButton extends StatelessWidget {
  const BoringButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        onPressed: () {
          context.read(boringActivityProvider).getBoringActivity();
        },
        child: Text(
          'I\'m bored',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}

class BoringButtonSave extends StatelessWidget {
  const BoringButtonSave({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
      onPressed: () {
        context.read(savedBoringActivityProvider.state).whenData(
          (listSaved) {
            context.read(savedBoringActivityProvider).addSavedBoringActivity();
          },
        );
      },
      child: Icon(
        Icons.bookmark,
        color: Theme.of(context).colorScheme.background.withOpacity(0.5),
      ),
      color: Theme.of(context).accentColor,
    );
  }
}
