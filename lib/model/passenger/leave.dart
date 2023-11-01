

import 'dart:ffi';

class Leave {
  
  final int? id;
  final int childId;
  final int type;     // 1 - ECA, 2 - Holiday, 3 - MC, 4 - Pickup, 5 - Sending
  final DateTime start;
  final DateTime end;
  final int status;
  
  Leave({
    this.id,
    required this.childId,
    required this.type,
    required this.start,
    required this.end,
    required this.status
});
  
  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
        id: json['id'],
        childId: json['childId'], 
        type: json['type'], 
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
        status: json['status']
    );
  }

  Map<String, dynamic> toJson () {
    Map<String, dynamic> data = {};
    data['childId'] = childId;
    data['type'] = type;
    data['start'] = start.toLocal().toIso8601String();
    data['end'] = end.toLocal().add(const Duration(seconds: 57599)).toIso8601String();
    data['status'] = status;
    return data;
}
}