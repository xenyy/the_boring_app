import 'package:the_boring_app/models/boringActivity_model.dart';
import 'package:the_boring_app/state/boring_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedScreen extends StatelessWidget {
  static const String routeName = '/saved';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              //Todo delete all saved boring activities
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
              onRefresh: () => context.read(savedBoringActivityProvider).refreshSavedList(),
              child: Consumer(
                builder: (context, watch, child) {
                  final saved = watch(savedProvider);
                  return saved.when(
                    data: (saved) {
                      return ListView(children: [
                        ...saved
                            .map(
                              (item) => SavedActivity(
                                item: item,
                                onDismissed: (direction) =>
                                    dismissItem(context, item.key, direction),
                              ),
                            )
                            .toList(),
                      ]);
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (e, s) => _Error(message: 'Saved Boring Activities could not be load :('),
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
        context.read(savedBoringActivityProvider).removeSavedBoringActivity(itemKey);
        break;
      default:
        //Nothing will happen :D
        break;
    }
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
          value: false, //todo.completed,
          onChanged: (_) {
            //context.read(todosNotifierProvider).toggle(todo.id);
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
                context.read(savedBoringActivityProvider).retryGetSavedBoringList();
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
