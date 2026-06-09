import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:provider/provider.dart';
import 'package:table_booking/Entities/tableobject.dart';
import 'package:table_booking/Providers/manageareapro.dart';
import 'package:table_booking/theme/app_theme.dart';

import '../myserver.dart';

class ManageArea extends StatefulWidget {
  const ManageArea({super.key});

  @override
  State<ManageArea> createState() => _ManageAreaState();
}

class _ManageAreaState extends State<ManageArea> {
  int? _selectedIndex;

  static const List<_TableShape> _shapes = [
    _TableShape("table", "Table", "images/table.png"),
    _TableShape("big_table", "Large", "images/big_table.png"),
    _TableShape("circle", "Round", "images/circle.png"),
    _TableShape("square", "Square", "images/Square.png"),
    _TableShape("round_bed", "Round Bed", "images/round_bed.png"),
    _TableShape("bed_beach", "Beach Bed", "images/bed_beach.png"),
  ];

  @override
  void initState() {
    super.initState();
    _loadArea();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _loadArea() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    if (!mounted) {
      return;
    }

    final areaId = Provider.of<ManageAreaPro>(context, listen: false).areaid;
    while (mounted) {
      final loaded = await MyServer.getWholeArea(areaId, context);
      if (loaded) {
        final provider = Provider.of<ManageAreaPro>(context, listen: false);
        provider.isloaded = true;
        provider.isdonable = provider.mytables.isNotEmpty;
        provider.notifyListenerz();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            Provider.of<ManageAreaPro>(context, listen: false).clearAll();
          }
        },
        child: Scaffold(
          backgroundColor: AppTheme.background,
          body: Consumer<ManageAreaPro>(
            builder: (context, provider, child) {
              if (!provider.isloaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 760;
                  final editor = _FloorEditor(
                    provider: provider,
                    selectedIndex: _selectedIndex,
                    onSelect: (index) => setState(() => _selectedIndex = index),
                    onMove: _moveTable,
                  );
                  final tools = _EditorTools(
                    areaName: provider.areaname,
                    tableCount: provider.mytables.length,
                    selectedIndex: _selectedIndex,
                    shapes: _shapes,
                    onAdd: _showAddTableDialog,
                    onDelete: _deleteSelected,
                    onSave: provider.isdonable ? _saveArea : null,
                    onCancel: () => Navigator.of(context).maybePop(),
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        Expanded(child: editor),
                        SizedBox(height: 150, child: tools),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: editor),
                      SizedBox(width: 260, child: tools),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _moveTable(int index, Offset delta, Size canvasSize) {
    final provider = Provider.of<ManageAreaPro>(context, listen: false);
    final table = provider.mytables[index];
    const itemSize = 86.0;

    table.dx = (table.dx + delta.dx).clamp(8.0, canvasSize.width - itemSize);
    table.dy = (table.dy + delta.dy).clamp(8.0, canvasSize.height - itemSize);
    provider.isdonable = true;
    provider.notifyListenerz();
  }

  Future<void> _showAddTableDialog(_TableShape shape) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Add ${shape.label}"),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(hintText: "Table name"),
            onSubmitted: (_) => _addTable(dialogContext, controller, shape),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => _addTable(dialogContext, controller, shape),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
    controller.dispose();
  }

  void _addTable(
    BuildContext dialogContext,
    TextEditingController controller,
    _TableShape shape,
  ) {
    final name = controller.text.trim();
    if (name.isEmpty) {
      ft.Fluttertoast.showToast(
        msg: "Please enter table name",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    final provider = Provider.of<ManageAreaPro>(context, listen: false);
    final exists = provider.mytables.any(
      (table) => table.tablename.toLowerCase() == name.toLowerCase(),
    );
    if (exists) {
      ft.Fluttertoast.showToast(
        msg: "Table already exists",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    provider.mytables.add(
      TableObject(
        0,
        provider.areaid,
        name,
        null,
        40 + provider.mytables.length * 12,
        40 + provider.mytables.length * 12,
        shape.id,
      ),
    );
    provider.isdonable = true;
    provider.notifyListenerz();
    setState(() => _selectedIndex = provider.mytables.length - 1);
    Navigator.of(dialogContext).pop();
  }

  void _deleteSelected() {
    final index = _selectedIndex;
    if (index == null) {
      ft.Fluttertoast.showToast(
        msg: "Select a table first",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    final provider = Provider.of<ManageAreaPro>(context, listen: false);
    if (index < 0 || index >= provider.mytables.length) {
      setState(() => _selectedIndex = null);
      return;
    }

    if (provider.mytables[index].booking != null) {
      ft.Fluttertoast.showToast(
        msg: "This table has bookings",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    provider.mytables.removeAt(index);
    provider.isdonable = true;
    provider.notifyListenerz();
    setState(() => _selectedIndex = null);
  }

  Future<void> _saveArea() async {
    final provider = Provider.of<ManageAreaPro>(context, listen: false);
    final saved =
        await MyServer.addTablesInArea(provider.areaid, provider.mytables);
    if (!mounted) {
      return;
    }

    ft.Fluttertoast.showToast(
      msg: saved ? "Layout saved" : "Could not save layout",
      toastLength: ft.Toast.LENGTH_SHORT,
    );

    if (saved) {
      provider.clearAll();
      Navigator.of(context).maybePop();
    }
  }
}

class _FloorEditor extends StatelessWidget {
  const _FloorEditor({
    required this.provider,
    required this.selectedIndex,
    required this.onSelect,
    required this.onMove,
  });

  final ManageAreaPro provider;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final void Function(int index, Offset delta, Size canvasSize) onMove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.areaname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Drag tables to arrange the floor plan",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Chip(
                avatar: const Icon(Icons.table_restaurant, size: 18),
                label: Text("${provider.mytables.length} tables"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );

                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppTheme.floorSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x16000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _FloorGridPainter()),
                        ),
                        if (provider.mytables.isEmpty)
                          const Center(
                            child: _CanvasEmptyMessage(),
                          ),
                        for (int i = 0; i < provider.mytables.length; i++)
                          Positioned(
                            left: provider.mytables[i].dx
                                .clamp(8.0, canvasSize.width - 86),
                            top: provider.mytables[i].dy
                                .clamp(8.0, canvasSize.height - 86),
                            child: GestureDetector(
                              onTap: () => onSelect(i),
                              onPanStart: (_) => onSelect(i),
                              onPanUpdate: (details) {
                                onMove(i, details.delta, canvasSize);
                              },
                              child: _FloorTable(
                                table: provider.mytables[i],
                                selected: selectedIndex == i,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorTools extends StatelessWidget {
  const _EditorTools({
    required this.areaName,
    required this.tableCount,
    required this.selectedIndex,
    required this.shapes,
    required this.onAdd,
    required this.onDelete,
    required this.onSave,
    required this.onCancel,
  });

  final String areaName;
  final int tableCount;
  final int? selectedIndex;
  final List<_TableShape> shapes;
  final ValueChanged<_TableShape> onAdd;
  final VoidCallback onDelete;
  final VoidCallback? onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 14, 14, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Furniture", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            "Tap an item to add it to the layout.",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              itemCount: shapes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final shape = shapes[index];
                return _ShapeButton(
                  shape: shape,
                  onTap: () => onAdd(shape),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: selectedIndex == null ? null : onDelete,
            icon: const Icon(Icons.delete_outline),
            label: const Text("Delete selected"),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSave,
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShapeButton extends StatelessWidget {
  const _ShapeButton({required this.shape, required this.onTap});

  final _TableShape shape;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.background,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(shape.asset, fit: BoxFit.contain),
              ),
              const SizedBox(height: 6),
              Text(
                shape.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloorTable extends StatelessWidget {
  const _FloorTable({required this.table, required this.selected});

  final TableObject table;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final shape = _ManageAreaState._shapes.firstWhere(
      (item) => item.id == table.shape,
      orElse: () => _ManageAreaState._shapes.first,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: 86,
      height: 86,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color:
            selected ? AppTheme.primary.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? AppTheme.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(child: Image.asset(shape.asset, fit: BoxFit.contain)),
          const SizedBox(height: 4),
          Text(
            table.tablename,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CanvasEmptyMessage extends StatelessWidget {
  const _CanvasEmptyMessage();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_circle_outline, color: AppTheme.primary),
            const SizedBox(width: 10),
            Text(
              "Add furniture from the panel",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _FloorGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    const step = 32.0;

    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TableShape {
  const _TableShape(this.id, this.label, this.asset);

  final String id;
  final String label;
  final String asset;
}
