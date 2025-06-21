import "dart:convert";
import "package:yaml/yaml.dart";
import "package:bidars/src/common.dart";
import "package:bidars/src/elements.dart";
import "package:bidars/src/errors.dart";

class BidarsParser {
  BidarsNode parse(String input){
    final List<String> lines = BidarsParser.ls.convert(input);
    
    final RegExp attrParenStartRe = BidarsParser.nonEscapedSymbol(BidarsParser.attrParen.start);
    final RegExp attrParenEndRe = BidarsParser.nonEscapedSymbol(BidarsParser.attrParen.end, suffix: "$");

    int linePos = 0;
    int tempLP = 0;
    String currLine = "";
    

    Set<BidarsIdent> idents = <BidarsIdent>{};
    List<BidarsEntry> entries = <BidarsEntry>[];

    while(linePos < lines.length){
      tempLP = BidarsParser._firstSymbolOf(lines, linePos);
      if(tempLP >= lines.length){
        linePos = tempLP;
        continue;
      }
      currLine = BidarsParser._ignoredLine(lines[tempLP], needTrimR: true);

      // #, skip to close
     // $, read op expre; non-attributes; pre-op is no-space; expre is able to be multi-lines(ex. enum, struct, etc.)
     // %, read type, ident, value, and treat attributes; pre-type is no-space; value is able to be multi-lines (ex. string and collective)
     // !!, read ident and value; non-attributes; pre-ident is able to have space; value is able to be multi-lines (ex. string and collective)
      

     

      // treat attributes
      attrParenEndRe.

      if(content){
        // content closing
        if(currLine.trim() == BidarsParser.entryCloseSymbol){
          content = false;
          continue;
        }
        // element of collective entry
        // multi-line value
      }else{
        currLine = currLine.trim();
        // entry
        if(BidarsParser.precSymbols.any((String ps) => currLine.startsWith(ps))){
          Object op = switch(BidarsParser.precSymbolChar(currLine)){
            "#" => ignoreTo(currLine),
            "%" => entryTo(currLine),
            "\$" => pragmaTo(currLine), 
            "!!" => metaTo(currLine),
            _ => errorTo(currLine),
          }
        }
      }
  }

  static List<String> rootEntryCand = <String>["entry", "root", "main"];
  static List<String> precSymbols = <String>["%", "\$", "#", "!!"];
  static String entryCloseSymbol = "---";
  static String inlineCommentSymbol = "";
  static EnvelopeString attrParen = (start: "[", end: "]");
  static LineSplitter ls = LineSplitter();
  static RegExp nonEscapedSymbol(String symbol, {String prefix = "", String suffix = ""}) => RegExp(prefix + r"(?<!\\)" + symbol + suffix);
  static String precSymbolChar(String line){
    final int maxLen = 
    final String cand = line.substring(0, maxLen);
    late String ret;

    for(int i = 0; i < maxLen; i++){
      ret = cand.substring(0, maxLen - i);
      if(BidarsParser.precSymbols.contains(ret)){
        return ret;
      }
    }
    return "";
  }

  static int _firstSymbolOf(List<String> lines, int prevEndPos)
    => BidarsParser._firstMatchOf(lines, prevEndPos, (String ca)
    => BidarsParser.precSymbols.any((String ps) => ca.startsWith(ps)), false, midVoidOnly: true);
  static int _firstCloseOf(List<String> lines, int prevEndPos)
    => BidarsParser._firstMatchOf(lines, prevEndPos, (String ca) => ca == BidarsParser.entryCloseSymbol, true);

  static int _firstMatchOf(List<String> lines, int prevEndPos, bool Function(String) test, bool startTrim, {bool midVoidOnly = false}){
    Iterable<int> cand =  lines.skip(prevEndPos)
      .map<String>(String b) => BidarsParser._ignoredLine(b, needTrimR: true, needTrimL: startTrim))
      .indexed
      .where(((int, String) c) => test(c.$2))
      .where(((int, String) c) => midVoidOnly && c.$1 > 1 ? lines.skip(prevEndPos).take(c.$1).every((String l) => BidarsParser._ignoredLine(l, needTrimR: true, needTrimL: true) == "") : true)
      .map<int>(((int, String) e) => e.$1);
    if(cand.isEmpty){
      return lines.length + prevEndPos + 2;
    }else{
      return cand.first + prevEndPos:
    }
  }

  static String _ignoredLine(String baseLine, {bool needTrimL = false, bool needTrimR = false}){
    final RegExp inlineCommentRe = BidarsParser.nonEscapedSymbol(BidarsParser.inlineCommentSymbol);
    late String nonComment;
    if(inlineCommentRe.hasMatch(baseLine)){
      nonComment = baseLine.substring(0, inlineCommentRe.firstMatch(baseLine));
    } else {
      nonComment = baseLine; 
    }
    if(needTrimL && needTrimR) {
      return nonComment.trim();
    } else if(needTrimL) {
      return nonComment.trimLeft();
    } else if(needTrimR) {
      return nonComment.trimRight();
    } else {
      return nonComment;
    }
  }
}