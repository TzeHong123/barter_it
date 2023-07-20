class Record {
  String? recordId;
  String? recordBill;
  String? traderId;
  String? ownerId;
  String? ownerPhone;
  String? recordDate;
  String? recordStatus;
  String? recordLat;
  String? recordLng;

  Record(
      {this.recordId,
      this.recordBill,
      this.traderId,
      this.ownerId,
      this.ownerPhone,
      this.recordDate,
      this.recordStatus,
      this.recordLat,
      this.recordLng});

  Record.fromJson(Map<String, dynamic> json) {
    recordId = json['record_id'];
    recordBill = json['record_bill'];
    traderId = json['trader_id'];
    ownerId = json['owner_id'];
    ownerPhone = json['owner_phone'];
    recordDate = json['record_date'];
    recordStatus = json['record_status'];
    recordLat = json['record_lat'];
    recordLng = json['record_lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['record_id'] = recordId;
    data['record_bill'] = recordBill;
    data['trader_id'] = traderId;
    data['owner_id'] = ownerId;
    data['owner_phone'] = ownerPhone;
    data['record_date'] = recordDate;
    data['record_status'] = recordStatus;
    data['record_lat'] = recordLat;
    data['record_lng'] = recordLng;
    return data;
  }
}
