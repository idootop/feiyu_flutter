class Site {
  String name;
  String server;
  String title;
  String link;
  String desp;
  String item;
  String m3u8;
  String cover;
  String xml;

  Site(
      {this.name,
      this.server,
      this.title,
      this.link,
      this.desp,
      this.item,
      this.m3u8,
      this.cover,
      this.xml});

  Site.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    server = json['server'];
    title = json['title'];
    link = json['link'];
    desp = json['desp'];
    item = json['item'];
    m3u8 = json['m3u8'];
    cover = json['cover'];
    xml = json['xml'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['server'] = this.server;
    data['title'] = this.title;
    data['link'] = this.link;
    data['desp'] = this.desp;
    data['item'] = this.item;
    data['m3u8'] = this.m3u8;
    data['cover'] = this.cover;
    data['xml'] = this.xml;
    return data;
  }
}
