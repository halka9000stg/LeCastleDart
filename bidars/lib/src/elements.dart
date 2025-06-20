import "dart:math" show Point, Rectangle;
import "dart:convert" show base64Decode;
import "package:complex/complex.dart" show Complex;
import "package:color/color.dart";
import "package:bidars/src/common.dart";
import "package:bidars/path.dart" show BidarsVisitor;


abstract class BidarsEntry<T> {
  final BidarsType type;
  final BidarsIdent ident;
  final BidarsAttributes attributes;
  final String valueText;
  final T value;

  void accept(BidarsVisitor visitor);
}


abstract class BidarsScalar<T> extends BidarsEntry<T> {
  
}
class BidarsInt extends BidarsScalar<int> {
  @override
  final BidarsType type = BidarsType.integer;

  BidarsInt(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsInt parse(BidarsIdent ident, String text, BidarsAttributes attributes){}
}
class BidarsPointed extends BidarsScalar<double> {
  @override
  final BidarsType type = BidarsType.pointed;

  BidarsPointed(this.ident, this.attributes, this.valueText, this.value);

  static BidarsPointed parse(BidarsIdent ident, String text, BidarsAttributes attributes) => BidarsPointed(ident, attributes, text, double.parse(text));
}
class BidarsFrac extends BidarsScalar<> {
  @override
  final BidarsType type = BidarsType.frac;

  BidarsFrac(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsFrac parse(BidarsIdent ident, String text, BidarsAttributes attributes){}
}

class BidarsComplex extends BidarsScalar<Complex> {
  @override
  final BidarsType type = BidarsType.complex;

  BidarsComplex(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsComplex parse(BidarsIdent ident, String text, BidarsAttributes attributes){}
}
class BidarsRatio extends BidarsScalar<{}> {
  @override
  final BidarsType type = BidarsType.ratio;

  BidarsRatio(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsRatio parse(BidarsIdent ident, String text, BidarsAttributes attributes){}
}

class BidarsString extends BidarsScalar<String> {
  @override
  final BidarsType type = BidarsType.string;

  BidarsString(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsString parse(BidarsIdent ident, String text, BidarsAttributes attributes){}
}

class BidarsBool extends BidarsScalar<bool> {
  @override
  final BidarsType type = BidarsType.boolean;

  BidarsBool(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsBool parse(BidarsIdent ident, String text, BidarsAttributes attributes){
    bool val = switch(text){
      "true" "t" => true,
      "false" "f" => false,
      _ BidarsIllegalValueError(BidarsType.boolean, ident, text)
    };
  }
}

class BidarsPoint<N extends num> extends BidarsScalar<Point<N>> {
  @override
  final BidarsType type = BidarsType.point;

  BidarsPoint(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsPoint parse(BidarsIdent ident, String text, BidarsAttributes attributes){
    replace(RegExp(r""), "").replace("")
  }
}
class BidarsRect<N extends num> extends BidarsScalar<Rectangle<N>> {
  @override
  final BidarsType type = BidarsType.rect;

  BidarsRect(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsRect parse(BidarsIdent ident, String text, BidarsAttributes attributes){}
}

class BidarsColor extends BidarsScalar<Color> {
  @override
  final BidarsType type = BidarsType.color;

  BidarsColor(this.ident, this.attributes, this.valueText, this.value);
  
  static BidarsColor parse(BidarsIdent ident, String text, BidarsAttributes attributes){}

}

class BidarsChrono extends BidarsScalar<DateTime> {
  @override
  final BidarsType type = BidarsType.chrono;

  BidarsChrono(this.ident, this.attributes, this.valueText, this.value);

  static BidarsChrono parse(BidarsIdent ident, String text, BidarsAttributes attributes) => BidarsChrono(ident, attributes, text, DateTime.parse(text));
}

abstract class BidarsCollective<E, T extends Iterable<E>> extends BidarsEntry<T> {
  
}

class BidarsNode<T> {
  final BidarsEntry<T> entry;
  List<BidarsNode> _children;

  BidarsNode(this.entry, [List<BidarsNode>? children]): this._children = children ?? <BidarsNode>[];

  void append(BidarsEntry entry) {
    this.add(BidarsNode(entry));
  }
  List<BidarsNode> get children => <BidarsNode>[...(this
_.children)];
  String get type => this.entry.type;
  String get valueText => this.entry.valueText;
  T get value => this.entry.value;
}