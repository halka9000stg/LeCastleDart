import "package:bidars/src/errors.dart";

typedef Varidator = bool Function(String);
typedef EnvelopeString = ({String start, String end});

extension Checker on bool Function(String) {
  String checkFor<E extends >(String input, {E Function(String)? onIllegal}){
    if(this(input)) return input;
    if(onIllegal != null) {
      throw onIllegal(input);
    } else {
      throw 
    }
  }
}

extension ReCheck on RegExp {
  String checkFor<E extends >(String input, {E Function(String)? onIllegal}) => this.hasMatch.checkFor<E>(input, onIllegal: onIllegal);
}


class BidarsType {
  final String name;

  BidarsType(String name): this.name = BidarsType.re.checkFor(name);

  bool get isScalar => BidarsType.scalarTypes.contains(this.name);
  bool get isCollective => BidarsType.collectiveTypes.contains(this.name);

  static RegExp re = RegExp(r"^[a-z][a-z0-9]*([_/:][a-z][a-z0-9]*)*$");
  static List<String> scalarTypes = <String>["int", "pointed", "frac", "complex", "ratio", "string", "bool"];
  static List<String> collectiveTypes = <String>["table", "set"];

  static bool descriptable(String name) => BidarsType.scalarTypes.contains(name) || BidarsType.collectiveTypes.contains(name);

  //specials
  static BidarsType any = BidarsType("any");
  static BidarsType refer = BidarsType("refer");
  static BidarsType option = BidarsType("option");
  static BidarsType or = BidarsType("or");

  //scalars
  static BidarsType integer = BidarsType("int");
  static BidarsType pointed = BidarsType("pointed");
  static BidarsType frac = BidarsType("frac");
  static BidarsType complex = BidarsType("complex");
  static BidarsType ratio = BidarsType("ratio");
  static BidarsType string = BidarsType("string");
  static BidarsType boolean = BidarsType("bool");

  //collectives
  static BidarsType table = BidarsType("table");
  static BidarsType set = BidarsType("set");
}

class BidarsIdent {
  final String ident;

  BidarsIdent(String ident): this.ident = BidarsIdent.re.checkFor(ident);

  static RegExp re = RegExp(r"^[a-zA-Z][a-zA-Z0-9]*([_/:][a-z][a-z0-9]*)*$");
}

class BidarsAttributes {
  BidarsAttributes()
  BidarsAttributes parse(String input){}
}