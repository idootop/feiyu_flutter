class Player {
  String server;
  String title;
  String m3u8;
  String public;

  Player({this.server, this.title, this.m3u8, this.public});

  Player.fromJson(Map<String, dynamic> json) {
    server = json['server'];
    title = json['title'];
    m3u8 = json['m3u8'];
    public = json['public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['server'] = this.server;
    data['title'] = this.title;
    data['m3u8'] = this.m3u8;
    data['public'] = this.public;
    return data;
  }
}
