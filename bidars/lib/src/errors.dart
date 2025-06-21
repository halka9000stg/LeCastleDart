abstract class BidarsError {}

class BidarsTypeError extends FormatException implements BidarsError {
  String text;
  
  BidarsTypeNameError(this.text);
  
  @override
  String toString() => "Illegal format for typename: ${this.text}";
}

class BidarsIdentifierError extends FormatException implements BidarsError {
  String text;
  
  BidarsIdentifierError(this.text);
  
  @override
  String toString() => "Illegal format for identifier: ${this.text}";
}

class BidarsParseError extends FormatException implements BidarsError {
  
}

class BidarsIllegalValueError extends FormatException implements BidarsError {
  BidarsType type;
  BidarsIdent ident;
  String text;
  
  BidarsIllegalValueError(this.type, this.ident, this.text);
  
  @override
  String toString() => "Illegal format for value of ${this.type} type (for ${this.ident}): ${this.text}";
}