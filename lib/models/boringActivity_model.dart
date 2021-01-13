class BoringActivity {
  BoringActivity({
    this.activity,
    this.type,
    this.participants,
    this.price,
    this.link,
    this.key,
    this.accessibility,
  });

  final String activity;
  final String type;
  final int participants;
  final double price;
  final String link;
  final String key;
  final double accessibility;

  factory BoringActivity.fromJson(Map<String, dynamic> json) => BoringActivity(
    activity: json["activity"] == null ? null : json["activity"],
    type: json["type"] == null ? null : json["type"],
    participants: json["participants"] == null ? null : json["participants"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    link: json["link"] == null ? null : json["link"],
    key: json["key"] == null ? null : json["key"],
    accessibility: json["accessibility"] == null ? null : json["accessibility"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "activity": activity == null ? null : activity,
    "type": type == null ? null : type,
    "participants": participants == null ? null : participants,
    "price": price == null ? null : price,
    "link": link == null ? null : link,
    "key": key == null ? null : key,
    "accessibility": accessibility == null ? null : accessibility,
  };
}