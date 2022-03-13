import 'dart:math';

String randomOTP() {
  final rng = new Random();
  final l = new List.generate(6, (_) => rng.nextInt(10));
  return l.join('');
}

dynamic getWithoutNull(Map object) {
  return object.removeWhere((key, value) => key == null || value == null);
}
