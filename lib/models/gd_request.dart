class Gd_request {
  int? id;
  String? staticId;
  String? type;
  String? reason;
  int? user;
  int? gd;

  Gd_request(
      {this.id, this.staticId, this.type, this.reason, this.user, this.gd});

  Gd_request.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staticId = json['static_id'];
    type = json['type'];
    reason = json['reason'];
    user = json['user'];
    gd = json['gd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['static_id'] = staticId;
    data['type'] = type;
    data['reason'] = reason;
    data['user'] = user;
    data['gd'] = gd;
    return data;
  }
}
