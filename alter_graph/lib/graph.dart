import "dart:math";
import "package:collection/collection.dart";

// === Basic Classes ===
class Node {
  final String name;
  final Point<num> coord;

  Node(this.name, this.coord);

  double distance(Node other) {
    return sqrt(
      pow(this.coord.x - other.coord.x, 2) +
      pow(this.coord.y - other.coord.y, 2)
    );
  }
}

class Weight {} // default

class Link<W extends Weight> {
  final int from;
  final int to;
  final bool bidi;
  final W weight;

  Link(this.from, this.to, this.weight, [this.bidi = false]);

  double distance(Link<W> other) {
    return sqrt(
      pow(other.from - this.from, 2) +
      pow(other.to - this.to, 2),
    );
  }
}

// === Graph Class ===
class RouteCost<N extends Node> implements Comparable<RouteCost<N>> {
  final int index;
  final num cost;

  const RouteCost(this.index, this.cost);

  @override
  int compareTo(RouteCost<N> other) {
    return this.cost.compareTo(other.cost);
  }
}

class NodeNotFoundException implements Exception {
  final String name;
  const NodeNotFoundException(this.name);

  @override
  String toString() => "NodeNotFoundException: Node \"$name\" not found.";
}

class Graph<N extends Node, W extends Weight, L extends Link<W>> {
  final List<N> nodes;
  final List<L> links;

  Graph(this.nodes, this.links);

  int find(String name) {
    final Iterable<int> matches = this.nodes.asMap().entries
      .where((MapEntry<int, N> e) => e.value.name == name)
      .map((MapEntry<int, N> e) => e.key);
    return matches.isEmpty ? throw NodeNotFoundException(name) : matches.first;
  }

  void addByNames(String fromName, String toName, W weight, {bool bidi = false, String line = ""}) {
    final int fromIndex = this.find(fromName);
    final int toIndex = this.find(toName);
    this.links.add(Link<W>(fromIndex, toIndex, weight, bidi, line) as L);
  }

  bool hasLink(int from, int to) {
  final Set<int> visited = <int>{};
  final List<int> stack = <int>[from];

  while (stack.isNotEmpty) {
    final int current = stack.removeLast();
    if (current == to) {
      return true;
    }
    if (!visited.contains(current)) {
      visited.add(current);
      final Iterable<int> neighbors = this.links.where(
        (L link) => link.from == current || (link.bidi && link.to == current)
      ).map(
        (L link) => link.from == current ? link.to : link.from
      );
      stack.addAll(neighbors.where((int next) => !visited.contains(next)));
    }
  }

  return false;
}

bool hasLinkByNames(String fromName, String toName) {
  final int from = this.find(fromName);
  final int to = this.find(toName);
  return this.hasLink(from, to);
}

  int outdegree(int node) {
    return this.links.where(
      (L link) => link.from == node || (link.bidi && link.to == node)
    ).length;
  }

  int outdegreeByName(String nodeName) {
    final int node = this.find(nodeName);
    return this.outdegree(node);
  }

  int indegree(int node) {
    return this.links.where(
      (L link) => link.to == node || (link.bidi && link.from == node)
    ).length;
  }

  int indegreeByName(String nodeName) {
    final int node = this.find(nodeName);
    return this.indegree(node);
  }

  List<int> sssp(int from, int to, [num Function(W)? distance]) {
    final int nodeCount = this.nodes.length;
    final List<num> distances = List<num>.filled(nodeCount, double.infinity);
    final List<int?> previous = List<int?>.filled(nodeCount, null);

    final HeapPriorityQueue<RouteCost<N>> queue = HeapPriorityQueue<RouteCost<N>>();

    distances[from] = 0;
    queue.add(RouteCost<N>(from, 0));

    while (queue.isNotEmpty) {
      final RouteCost<N> current = queue.removeFirst();
      final int u = current.index;

      if (distances[u] < current.cost) {
        continue;
      }

      final Iterable<L> neighbors = this.links.where((L l) =>
        l.from == u || (l.bidi && l.to == u));

      for (final L link in neighbors) {
        final int v = (link.from == u) ? link.to : link.from;

        final num weight = (distance != null)
          ? distance(link.weight)
          : this.nodes[u].distance(this.nodes[v]);

        final num alt = distances[u] + weight;

        if (alt < distances[v]) {
          distances[v] = alt;
          previous[v] = u;
          queue.add(RouteCost<N>(v, alt));
        }
      }
    }

    final List<int> path = <int>[];
    int? current = to;

    while (current != null) {
      path.insert(0, current);
      current = previous[current];
    }

    if (path.isEmpty || path.first != from) {
      throw Exception("No path found from ${this.nodes[from].name} to ${this.nodes[to].name}");
    }

    return path;
  }

  List<int> ssspByNames(String fromName, String toName, [num Function(W)? distance]) {
    final int from = this.find(fromName);
    final int to = this.find(toName);
    return this.sssp(from, to, distance);
  }
}