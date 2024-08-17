import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  return File('$dir/test/$name').readAsStringSync();
}
