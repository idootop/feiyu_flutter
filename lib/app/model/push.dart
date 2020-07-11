class Push {
  String flag;
  String force;
  String info;
  String about;

  Push({this.flag, this.info, this.about, this.force});

  Push.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    force = json['force'];
    info = json['info'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['force'] = this.force;
    data['info'] = this.info;
    data['about'] = this.about;
    return data;
  }
}
