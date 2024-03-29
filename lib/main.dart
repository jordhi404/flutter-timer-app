import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'timer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp())
  );
}

final timerProvider = StateNotifierProvider <TimerNotifier, TimerModel>((ref) => TimerNotifier());
final _buttonState = Provider<ButtonState>((ref) {
  return ref.watch(timerProvider).buttonState;
});
final buttonProvider = Provider<ButtonState>((ref) {
  return ref.watch(_buttonState);
});
final _timeLeftprovider = Provider<String>((ref) {
  return ref.watch(timerProvider).timeLeft;
});
final timeLeftprovider = Provider<String>((ref) {
  return ref.watch(_timeLeftprovider);
});

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building MyHomePage');
    return Scaffold(
      appBar: AppBar(title: Text('My Timer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TimerTextWidget(),
            SizedBox(height: 20),
            ButtonsContainer(),
          ],
        ),
      ),
    );
  }
}

class TimerTextWidget extends HookWidget {
  const TimerTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final timeLeft = useProvider(timeLeftprovider);
   print('building TimerTextWidget $timeLeft');
   return Text(
    timeLeft, style: Theme.of(context).textTheme.headline2,
   );
  }
}

class ButtonsContainer extends HookWidget {
  const ButtonsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building ButtonsContainer');
    final state = useProvider(buttonProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(state == ButtonState.initial) ...[
          StartButton(),
        ],
        if(state == ButtonState.started) ...[
          PauseButton(),
          SizedBox(width: 20),
          ResetButton(),
        ],
        if(state == ButtonState.paused) ...[
          StartButton(),
          SizedBox(width: 20),
          ResetButton(),
        ],
        if(state == ButtonState.finished) ...[
          ResetButton()
        ],
      ],
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider.notifier).start();
      },
      child: Icon(Icons.play_arrow),
    );
  }
}

class PauseButton extends StatelessWidget {
  const PauseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider.notifier).pause();
      },
      child: Icon(Icons.pause),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider.notifier).reset();
      },
      child: Icon(Icons.replay),
    );
  }
}