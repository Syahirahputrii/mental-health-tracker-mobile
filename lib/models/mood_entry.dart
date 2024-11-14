import 'dart:convert';

MoodEntry moodEntryFromJson(String str) => MoodEntry.fromJson(json.decode(str));

String moodEntryToJson(MoodEntry data) => json.encode(data.toJson());

class MoodEntry {
    String greeting;
    List<List<Instruction>> instructions;

    MoodEntry({
        required this.greeting,
        required this.instructions,
    });

    factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        greeting: json["greeting"],
        instructions: List<List<Instruction>>.from(json["instructions"].map((x) => List<Instruction>.from(x.map((x) => Instruction.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "greeting": greeting,
        "instructions": List<dynamic>.from(instructions.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    };
}

class Instruction {
    String model;
    String pk;
    Fields fields;

    Instruction({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String mood;
    DateTime time;
    String feelings;
    int moodIntensity;

    Fields({
        required this.user,
        required this.mood,
        required this.time,
        required this.feelings,
        required this.moodIntensity,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        mood: json["mood"],
        time: DateTime.parse(json["time"]),
        feelings: json["feelings"],
        moodIntensity: json["mood_intensity"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "mood": mood,
        "time": "${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}",
        "feelings": feelings,
        "mood_intensity": moodIntensity,
    };
}
