import "package:bidars/src/common.dart";
import "package:bidars/src/elements.dart";

abstract class BidarsVisitor {
  bool visitCollectiveBefore(BidarsCollective entry);
  void visitCollectiveAfter(BidarsCollective entry);
  void visitScalar(BidarsScalar entry);
}

abstract class BidarsPath implements BidarsVisitor {
  late 
  static BidarsRootPath get root => BidarsRootPath();

  BidarsPath child<BP extends BidarsTwigPath>(BP pathEntry){}

  BidarsPath nomen(String ident) => this.child<BidarsNomenPath>(BidarsNomenPath(ident));
  BidarsPath glob(String text) =>
  BidarsPath typed(BidarsType type) =>
  BidarsPath attred() =>
  BidarsEntry find(BidarsNode base){
    base.entry.accept(this);
  }
}
class BidarsRootPath extends BidarsPath {
  @override
  bool visitCollectiveBefore(BidarsCollective entry) => true;
  @override
  void visitCollectiveAfter(BidarsCollective entry){}
  @override
  void visitScalar(BidarsScalar entry){}
}
abstract class BidarsTwigPath extends BidarsPath {}
class BidarsNomenPath extends BidarsTwigPath {
  final BidarsType type;
  final BidarsIdent ident;

  BidarsNomenPath(this.ident);

  bool visitCollectiveBefore(BidarsCollective<E, T extends Iterable<E>> entry){}
  void visitCollectiveAfter(BidarsCollective<E, T extends Iterable<E>> entry){}
  void visitScalar(BidarsScalar<E> entry){}
}