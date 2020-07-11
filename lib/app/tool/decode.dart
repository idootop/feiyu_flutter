import 'dart:convert';

String encodex(String s) => urlEncode(b64(s));

String b64(s) => base64Encode(utf8.encode(s));

String urlEncode(String s) => Uri.encodeComponent(s);

String toBase64(String data) {
  var content = utf8.encode(data);
  var digest = base64Encode(content);
  return digest;
}

String fromBase64(String data) {
  return utf8.decode(base64Decode(data));
}



