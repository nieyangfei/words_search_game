import 'package:flutter/material.dart';

class LetterGrid extends StatefulWidget {
  final List<List<String>> grid;
  final Function(String) onWordSelected;

  const LetterGrid({
    super.key,
    required this.grid,
    required this.onWordSelected,
  });

  @override
  State<LetterGrid> createState() => _LetterGridState();
}

class _LetterGridState extends State<LetterGrid> {
  final List<Offset> _selectedPositions = [];

  void _onPanStart(DragStartDetails details, double cellSize) {
    final pos = _getCellPosition(details.localPosition, cellSize);
    if (pos != null) {
      setState(() {
        _selectedPositions.clear();
        _selectedPositions.add(pos);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details, double cellSize) {
    final pos = _getCellPosition(details.localPosition, cellSize);
    if (pos != null && !_selectedPositions.contains(pos)) {
      setState(() {
        _selectedPositions.add(pos);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final word = _getSelectedWord();
    widget.onWordSelected(word);
    setState(() {
      _selectedPositions.clear();
    });
  }

  Offset? _getCellPosition(Offset localPos, double cellSize) {
    final row = localPos.dy ~/ cellSize;
    final col = localPos.dx ~/ cellSize;
    if (row >= 0 && row < widget.grid.length && col >= 0 && col < widget.grid.length) {
      return Offset(row.toDouble(), col.toDouble());
    }
    return null;
  }

  String _getSelectedWord() {
    String word = '';
    for (var pos in _selectedPositions) {
      word += widget.grid[pos.dx.toInt()][pos.dy.toInt()];
    }
    return word;
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = widget.grid.length;
    final cellSize = 28.0; // Small but big enough for fingers!

    return Center(
      child: Container(
        width: gridSize * cellSize,
        height: gridSize * cellSize,
        color: Colors.transparent,
        child: GestureDetector(
          onPanStart: (details) => _onPanStart(details, cellSize),
          onPanUpdate: (details) => _onPanUpdate(details, cellSize),
          onPanEnd: _onPanEnd,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              final row = index ~/ gridSize;
              final col = index % gridSize;
              final isSelected = _selectedPositions.contains(Offset(row.toDouble(), col.toDouble()));

              return Container(
                width: cellSize,
                height: cellSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 0.5),
                  color: isSelected ? Colors.yellowAccent : Colors.transparent,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.grid[row][col],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
