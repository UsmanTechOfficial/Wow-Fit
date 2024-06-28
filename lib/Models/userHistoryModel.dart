class HistoryData {
  String? date;
  String? exerciseName;
  List<Dairy>? dairy;

  HistoryData(this.date, this.dairy, this.exerciseName);

  HistoryData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    exerciseName = json['exerciseName'];
    dairy = json['dairy'] != null
        ? List.from(json['dairy'])
            .map((element) => Dairy.fromJson(element))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['exerciseName'] = exerciseName;
    data['dairy'] = dairy?.map((element) => element.toJson()).toList();
    return data;
  }
}

class Dairy {
  String? date;
  List<UserHistoryModel>? history;
  // UserNotes? userNotes;

  Dairy({
    this.date,
    this.history,
  });

  Dairy.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    //history = UserHistoryModel.fromJson(json['history']);
    history = [];
    history = json['history'] != null
        ? List.from(json['history'])
            .map((element) => UserHistoryModel.fromJson(element))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    //data['history'] = history!.toJson();
    data['history'] = history?.map((element) => element.toJson()).toList();
    return data;
  }
}

class UserHistoryModel {
  String? id;
  String? workOutId;
  String? type;
  String? exeIndexId;
  String? number;
  String? weight;
  String? reps;
  String? time;
  bool? playBtn;
  bool? tick;
  bool? isAddData;

  UserHistoryModel({
    this.id,
    this.number,
    this.weight,
    this.reps,
    this.time,
    this.playBtn,
    this.tick,
    required this.isAddData,
    this.workOutId,
    this.type,
    this.exeIndexId,
  });

  UserHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    weight = json['weight'];
    reps = json['reps'];
    time = json['time'];
    playBtn = json['playBtn'];
    tick = json['tick'];
    workOutId = json['workOutId'];
    type = json['type'];
    exeIndexId = json['exeIndexId'];
    isAddData = json['isAddData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['number'] = number;
    data['weight'] = weight;
    data['reps'] = reps;
    data['time'] = time;
    data['playBtn'] = playBtn;
    data['tick'] = tick;
    data['workOutId'] = workOutId;
    data['type'] = type;
    data['exeIndexId'] = exeIndexId;
    data['isAddData'] = isAddData;
    return data;
  }
}

class UserNotes {
  String? id;
  String? text;
  String? link;
  String? date;
  UserNotes({this.id, this.date, this.text,this.link});
  UserNotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    link = json['link'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['link'] = link;
    data['date'] = date;
    return data;
  }
}
