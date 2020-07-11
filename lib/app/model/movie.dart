class Movie {
  String title;
  String desp;
  String cover;
  List<Playlist> playlist;

  Movie({this.title, this.desp, this.cover, this.playlist});

  Movie.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desp = json['desp'];
    cover = json['cover'];
    if (json['playlist'] != null) {
      playlist = new List<Playlist>();
      json['playlist'].forEach((v) {
        playlist.add(new Playlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['desp'] = this.desp;
    data['cover'] = this.cover;
    if (this.playlist != null) {
      data['playlist'] = this.playlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Playlist {
  String name;
  String m3u8;

  Playlist({this.name, this.m3u8});

  Playlist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    m3u8 = json['m3u8'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['m3u8'] = this.m3u8;
    return data;
  }
}
