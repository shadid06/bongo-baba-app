class LastPathModel {
  var sura;
  var sura_name;
  var VerseIDAr;

  LastPathModel({
    this.sura,
    this.sura_name,
    this.VerseIDAr,
  });

  LastPathModel.fromJson(Map<String, dynamic> json) {
    sura = json['sura'];
    sura_name = json['sura_name'];
    VerseIDAr = json['VerseIDAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sura'] = this.sura;
    data['sura_name'] = this.sura_name;
    data['VerseIDAr'] = this.VerseIDAr;

    return data;
  }
}
