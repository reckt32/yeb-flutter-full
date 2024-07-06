class Gd_details {
  String? staticId;
  String? date;
  String? time;
  String? link;
  String? eventName;
  List<ParticipantDetails>? participantDetails;

  Gd_details(
      {this.staticId,
      this.date,
      this.time,
      this.link,
      this.eventName,
      this.participantDetails});

  Gd_details.fromJson(Map<String, dynamic> json) {
    staticId = json['static_id'];
    date = json['date'];
    time = json['time'];
    link = json['link'];
    eventName = json['event_name'];
    if (json['participant_details'] != null) {
      participantDetails = <ParticipantDetails>[];
      json['participant_details'].forEach((v) {
        participantDetails!.add(new ParticipantDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['static_id'] = staticId;
    data['date'] = date;
    data['time'] = time;
    data['link'] = link;
    data['event_name'] = eventName;
    if (participantDetails != null) {
      data['participant_details'] =
          participantDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParticipantDetails {
  String? name;
  int? mobile;
  String? email;

  ParticipantDetails({this.name, this.mobile, this.email});

  ParticipantDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    return data;
  }
}
