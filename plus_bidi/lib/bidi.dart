export "package:intl/intl.dart" show Bidi;

class BidiUnit {
  final bool isRtl;
  final int startPos; //inclusive
  final int endPos; //exclusive
  final String textUnit;

  BidiUnit(this.isRtl, this.startPos, this.endPos, this.textUnit);
  BidiUnit.first(this.isRtl, int startPos, String char):
    this.startPos = startPos,
    this.endPos = this.startPos + char.length,
    this.textUnit = char;

  BidiUnit followedBy(String char)
    => BidiUnit(this.isRtl, this.startPos, this.endPos + char.length, this.textUnit + char);
}

extension on Bidi {
  String escapeForLreInText(String text){
    if(!this.hasAnyRtl()) return text;
    Iterable<BidiUnit> bu = this.splitByDirection(text);
    String s = (bu.first.isRtl ? Bidi.RLE : "") + bu.first.textUnit;
    s += bu.skip(1).map<String>((BidiUnit u) => (u.isRtl ? Bidi.RLE : Bidi.LRE) + u.textUnit + Bidi.PDF).join("");
  }

  Iterable<BidiUnit> splitByDirection(String text){
    Iterable<bool> isRtlc = text.split("").map<({bool isRtl, String chr})>((String chr) => this.startsWithRtl(chr));
    Iterable<BidiUnit> bu = isRtlc.indexed.fold<Iterable<BidiUnit>>(<BidiUnit>[], (Iterable<BidiUnit> li, (int, ({bool isRtl, String chr})) ie) {
      if(li.isEmpty) return BidiUnit.first(ie.$2.isRtl, ie.$1, ie.$2.chr);
      if(li.last.isRtl == ie.$2.isRtl){
        return li.take(li.length - 1).followedBy(<BidiUnit>[li.last.followedBy(ie.$2.chr)]);
      }else{
       return BidiUnit.first(ie.$2.isRtl, ie.$1, ie.$2.chr);
      }
});
    return bu;
  }
}

class BidiText {
  final String lang;
  final String text;
  final bool alwaysLRE;

  BidiText(this.text, {this.lang = "ja", this.alwaysLRE = false});

  @override
  String toString(){
    if(Bidi.isRtlLanguage(this.lang)){
      return Bidi.RLE + this.text + Bidi.PDF;
    }
    if(this.alwaysLRE){
      return Bidi.LRE + this.text + Bidi.PDF;
    }
    return this.text;
  }
}

class BidiName extends BidiText {
  BidiName(String text, {String lang = "ja"}):
    super(text, lang: lang, alwaysLRE: true);
}