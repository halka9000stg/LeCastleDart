import "package:qreki_dart/qreki_dart.dart";
import "package:calc_wareki/calc_wareki.dart";

typedef Wareki = ({required EraName era, required int year});
enum EraName {
  meiji("明治", "明", "M"),
  taisho("大正", "大", "T"),
  showa("昭和", "昭", "S"),
  heisei("平成", "平", "H"),
  reiwa("令和", "令", "R");

  const EraName(String name, String abbrJa, String abbrEn);

  static EraName search(String input) {
    final Iterable<EraName> es EraName.values.where((EraName e) => e.name == input || e.abbrJa == input || e.abbrEn == input);
    try{
      return es.single;
    }catch(_){
      throw Exception("Unmatch input as era name: $input");
    }
}

  static Calendar calender = Calendar();
  static Wareki asWareki(int year, int month, int day){
    final String wareki = EraName.calender.yearToWareki(year, month, day);
      int pos = wareki.indexOf(RegExp(r"\d+"));
    return ({
      era: EraName.search(wareki.substring(0, pos)),
      year: int.parse(wareki.substring(pos))
     });
  }
}

class JpDateTime extends Comparable<JpDateTime>{
  final DateTime base;
  final bool isLeap; //leap year
  final int year; //christian year in sinreki
  final EraName era; //era name in sinreki
  final int yearW; //wareki year in sinreki
  final int month; //month in sinreki
  final int day; // day in sinreki
  final int yearQ; //christian year in kyureki
  final EraName eraQ; //era name in kyureki
  final int yearWQ; //wareki year in kyureki
  final int monthQ; //month in kyureki
  final bool isLeapQ; //leap month in kyureki
  final int dayQ; //day in kyureki
  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final int microsecond;

  JpDateTime._(this.base, this.isLeap, this.year, this.era, this.yearW, this.month, this.day, this.yearQ, this.eraQ, this.yearWQ, this.monthQ, this.isLeapQ, this.dayQ, this.hour, this.minute, this.second, this.millisecond, this.microsecond);
  factory JpDateTime(DateTime dt){ 
    final int yearD = dt.year;
    final bool isLeapY = yearD % 4 == 0 && yearD % 100 != 0 || yearD % 400 == 0;
    final Wareki wa = EraName.asWareki(dt.year, dt.month, dt.day);
    final String qDate = Kyureki.fromDate(dt);
    final bool isLeapQ = qDate.contains("閏");
    final int yearQ = int.parse(qDate.substring(0, qDate.indexOf("年")));
    final int monthQ = int.parse(qDate.substring(qDate.indexOf(isLeapQ ? "閏" : "年") + 1, qDate.indexOf("月")));
    final int dayQ = int.parse(qDate.substring(qDate.indexOf("月") + 1, qDate.indexOf("日")));
    final qWa = EraName.asWareki(yearQ, monthQ, dayQ);
    return JpDateTime._(dt, isLeapY, yearD, wa.era, wa.year, dt.month, dt.day, yearQ, qWa.era, qWa.year, monthQ, isLeapQ, dayQ, dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
  }
  factory JpDateTime.now(){
    return JpDateTime(DateTime.now());
  }

  @override
  int compareTo(JpDateTime other) => this.base.compareTo(other.base);
}