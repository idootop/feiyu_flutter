import 'dart:math';

//生成定长随机数
String randomCodeX(int strlenght) {
  String alphabet = '0123456789';
  String left = '';
  for (var i = 0; i < strlenght; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}

//生成时间戳
String randomCode(int strlenght) => '${DateTime.now().millisecondsSinceEpoch}';

randomListItem(List temp) => temp[Random().nextInt(temp.length)];

List copyList(List temp) =>
    List.generate(temp.length, (int index) => temp[index], growable: true);

List randomList(List order) {
  List old = copyList(order);
  int index = 0;
  while (old.length > 1) {
    var e = randomListItem(old);
    order[index] = e;
    old.remove(e);
    index++;
  }
  return order;
}

