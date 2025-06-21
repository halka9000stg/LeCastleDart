import "package:bidars/src/errors.dart";

typedef UValidator<T> = bool Function(T);
typedef Validator = UValidator<String>;
typedef EnvelopeString = ({required String start, required String end});

extension Checker on bool Validator {
  String checkFor<E extends BidarsError>(String input, {E Function(String)? onIllegal}){
    if(this(input)) return input;
    if(onIllegal != null) {
      throw onIllegal(input);
    } else {
      throw FormatException();
    }
  }
  Validator or(Validator other) => (String input) => this(input) || other(input);
  Validator and(Validator other) => (String input) => this(input) && other(input);
  Validator ifThenAndU((T, U) Function(String) chomp, UValidator<T> left, UValidator<U> right) => (String input){
    if(this(input)){
      final(T l, U r) = chomp(input);
      return left(l) && right(r);
    }
    return false;
  }
  Validator ifThenAnd((String, String) chomp, Validator left, Validator right) => this.ifThenAndU(chomp, left, right);
}

extension ReCheck on RegExp {
  String checkFor<E extends BidarsError>(String input, {E Function(String)? onIllegal}) => this.asVaridator().checkFor<E>(input, onIllegal: onIllegal);
  Validator asVaridator() => this.hasMatch;
}


class BidarsType {
  final String name;
  Validator expects;

  BidarsType(String name, {Validator? expects}):
    this.name = BidarsType.re.checkFor(name),
    this.expects = expects ?? (String _) => true;

  bool get isScalar => BidarsType.scalarTypes.contains(this.name);
  bool get isCollective => BidarsType.collectiveTypes.contains(this.name);

  static RegExp re = RegExp(r"^[a-z][a-z0-9]*([_/:][a-z][a-z0-9]*)*$");
  static List<String> scalarTypes = <String>["int", "pointed", "frac", "complex", "ratio", "string", "bool"];
  static List<String> collectiveTypes = <String>["table", "set"];

  static bool descriptable(String name) => BidarsType.scalarTypes.contains(name) || BidarsType.collectiveTypes.contains(name);

  //specials
  static BidarsType any = BidarsType("any");
  static BidarsType refer = BidarsType("refer", expects: ((String i) => i.startsWith("&")).ifThen((String s) => s.substring(1), BidarsIdent.re.asVaridator()));
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