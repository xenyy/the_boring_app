import 'package:another_flushbar/flushbar.dart';
import 'package:the_boring_app/models/boringActivity_model.dart';
import 'package:the_boring_app/state/boring_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedScreen extends StatefulWidget {
  static const String routeName = '/saved';

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    context.read(savedBoringActivityProvider).getSavedBoringActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => DeleteAllAlertDialog(),
              );
            },
            splashRadius: 27,
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.done_all_rounded),
              onPressed: () {
                // TODO mark as done all saved boring activities
              },
              splashRadius: 27,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SavedTitle(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read(savedBoringActivityProvider).refreshSavedList(),
              child: Consumer(
                builder: (context, watch, child) {
                  final saved = watch(savedProvider);
                  return saved.when(
                    data: (saved) {
                      if (saved.isEmpty) {
                        return Center(
                          // Todo put this prettier
                          child: Text(
                              'You should start saving activities for later!!'),
                        );
                      } else {
                        return ListView(
                          children: [
                            ...saved
                                .map(
                                  (item) => SavedActivity(
                                    item: item,
                                    onDismissed: (direction) => dismissItem(
                                        context, item.key, direction),
                                  ),
                                )
                                .toList(),
                          ],
                        );
                      }
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (e, s) => _Error(
                        message:
                            'Saved Boring Activities could not be load :('),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dismissItem(BuildContext context, itemKey, DismissDirection direction) {
    switch (direction) {
      case DismissDirection.endToStart:
        context
            .read(savedBoringActivityProvider)
            .removeSavedBoringActivity(itemKey)
            .whenComplete(
              () => Flushbar(
                message: 'Activity deleted',
                //backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
                icon: Icon(
                  Icons.delete_forever_rounded,
                  size: 27.0,
                  color: Colors.redAccent,
                ),
                flushbarStyle: FlushbarStyle.FLOATING,
                margin: EdgeInsets.all(20),
                borderRadius: 8,
                duration: Duration(seconds: 3),
                animationDuration: Duration(milliseconds: 200),
                leftBarIndicatorColor: Colors.redAccent,
              )..show(context),
            );

        break;
      default:
        //Nothing will happen :D
        break;
    }
  }
}

class DeleteAllAlertDialog extends StatelessWidget {
  const DeleteAllAlertDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.amber,
          ),
          SizedBox(width: 15),
          Text("Delete all"),
        ],
      ),
      content:
          Text("Hey! are you sure you want to delete all saved activities?"),
      actionsPadding: EdgeInsets.fromLTRB(10, 0, 20, 5),
      actions: <Widget>[
        FlatButton(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
          splashColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
          child: Text(
            'Sure!',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          onPressed: () {
            context
                .read(savedBoringActivityProvider)
                .deleteAllSaved()
                .whenComplete(() => Flushbar(
                      message: 'All activities deleted',
                      //backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
                      icon: Icon(
                        Icons.delete_forever_rounded,
                        size: 27.0,
                        color: Colors.redAccent,
                      ),
                      flushbarStyle: FlushbarStyle.FLOATING,
                      margin: EdgeInsets.all(20),
                      borderRadius: 8,
                      duration: Duration(seconds: 3),
                      animationDuration: Duration(milliseconds: 200),
                      leftBarIndicatorColor: Colors.redAccent,
                    )..show(context));
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          splashColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
          child: Text(
            'Nope',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class SavedTitle extends StatelessWidget {
  const SavedTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(
        'Saved Boring activities for later',
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).textTheme.headline6.color,
        ),
      ),
    );
  }
}

class SavedActivity extends StatelessWidget {
  const SavedActivity({
    Key key,
    @required this.item,
    @required this.onDismissed,
  }) : super(key: key);

  final BoringActivity item;
  final DismissDirectionCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(item.key),
      onDismissed: onDismissed,
      background: Container(color: Colors.green),
      secondaryBackground: buildRightSwipe(context),
      child: ListTile(
        leading: Checkbox(
          value: item.done,
          onChanged: (_) {
            context
                .read(savedBoringActivityProvider)
                .toggleDoneSavedBoringActivity(item.key)
                .whenComplete(() {
              if (!item.done) {
                Flushbar(
                  message: 'Activity done',
                  //backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
                  icon: Icon(
                    Icons.done_all_rounded,
                    size: 27.0,
                    color: Colors.green,
                  ),
                  flushbarStyle: FlushbarStyle.FLOATING,
                  margin: EdgeInsets.all(20),
                  borderRadius: 8,
                  duration: Duration(seconds: 3),
                  animationDuration: Duration(milliseconds: 200),
                  leftBarIndicatorColor: Colors.green,
                )..show(context);
              } else {
                Flushbar(
                  message: 'Activity undone',
                  //backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
                  icon: Icon(
                    Icons.clear,
                    size: 27.0,
                    color: Colors.amber,
                  ),
                  flushbarStyle: FlushbarStyle.FLOATING,
                  margin: EdgeInsets.all(20),
                  borderRadius: 8,
                  duration: Duration(seconds: 3),
                  animationDuration: Duration(milliseconds: 200),
                  leftBarIndicatorColor: Colors.amber,
                )..show(context);
              }
            });
          },
        ),
        focusColor: Colors.red,
        hoverColor: Colors.red,
        title: Text(item.activity),
      ),
    );
  }

  Container buildRightSwipe(context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 40),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.background.withOpacity(0.5),
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
              onPressed: () async {
                context
                    .read(savedBoringActivityProvider)
                    .retryGetSavedBoringList();
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
