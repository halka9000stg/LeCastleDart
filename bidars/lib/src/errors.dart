abstract class BidarsError {}

class BidarsIdentifierError extends Object implements BidarsError {}

class BidarsParseError extends Object implements BidarsError{
  
}

class BidarsIllegalValueError extends FormatException implements BidarsError{
  
}