import 'dart:math';

class RandomToken {
  static const _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static final _rnd = Random.secure();
  static String generate32() =>
      List.generate(32, (_) => _chars[_rnd.nextInt(_chars.length)]).join();
}
