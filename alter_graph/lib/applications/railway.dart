import "package:alter_graph/graph.dart";

class StationNode extends Node {
  StationNode(String name, Point<num> coord): super(name, coord);
}
class LineData extends Weight {
  final num operKm;
  LineData(this.operKm);
}
class WayLine extends Link<LineData>{
  final String line;
  WayLine(int from, int to, num operKm, [this.line = ""]): super(from, to, LineData(operKm), true);
}
class RailGraph extends Graph<StationNode, LineData, WayLine>{
  @override
  List<int> sssp(int from, int to, [num Function(W)? _]) => super.sssp(from, to, (LineData ld) => ld.operKm);
}