import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_booking/Entities/bookingobject.dart';
import 'package:table_booking/Entities/tableobject.dart';
import 'package:table_booking/Providers/alltablespro.dart';
import 'package:table_booking/Providers/homepro.dart';
import 'package:table_booking/theme/app_theme.dart';

import '../myserver.dart';

class AllTables extends StatefulWidget {
  const AllTables({super.key});

  @override
  State<AllTables> createState() => _AllTablesState();
}

class _AllTablesState extends State<AllTables> {
  @override
  void initState() {
    super.initState();
    _loadWholeArea();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _loadWholeArea() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    if (!mounted) {
      return;
    }

    final provider = Provider.of<AllTablesPro>(context, listen: false);
    final date = Provider.of<HomePro>(context, listen: false).d!;
    while (mounted) {
      final loaded = await MyServer.getWholeAreaForBooking(
        provider.areaid,
        date,
        context,
      );
      if (loaded) {
        provider.isloaded = true;
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
            Provider.of<AllTablesPro>(context, listen: false).clearAll();
          }
        },
        child: Scaffold(
          backgroundColor: AppTheme.background,
          body: Consumer2<AllTablesPro, HomePro>(
            builder: (context, tablesPro, homePro, child) {
              if (!tablesPro.isloaded) {
                return const Center(child: CircularProgressIndicator());
              }

              final date = homePro.d ?? DateTime.now();
              return LayoutBuilder(
                builder: (context, constraints) {
                  final booked = tablesPro.mytables
                      .where((table) => table.booking != null)
                      .length;

                  return Row(
                    children: [
                      Expanded(
                        child: _BookingFloor(
                          areaName: tablesPro.areaname,
                          date: date,
                          tables: tablesPro.mytables,
                          onTableTap: _handleTableTap,
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth < 760 ? 220 : 280,
                        child: _BookingSummary(
                          areaName: tablesPro.areaname,
                          date: date,
                          totalTables: tablesPro.mytables.length,
                          bookedTables: booked,
                          onBack: () => Navigator.of(context).maybePop(),
                        ),
                      ),
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

  void _handleTableTap(int index) {
    final table =
        Provider.of<AllTablesPro>(context, listen: false).mytables[index];
    if (table.booking == null) {
      _showNewBookingDialog(index);
    } else {
      _showBookingDetails(index);
    }
  }

  Future<void> _showNewBookingDialog(int index) async {
    final tablesPro = Provider.of<AllTablesPro>(context, listen: false);
    final date = Provider.of<HomePro>(context, listen: false).d!;
    final table = tablesPro.mytables[index];

    final booking = await showDialog<_BookingFormData>(
      context: context,
      builder: (dialogContext) => _NewBookingDialog(
        areaName: tablesPro.areaname,
        tableName: table.tablename,
        date: date,
      ),
    );
    if (!mounted || booking == null) {
      return;
    }

    final saved = await MyServer.addBooking(
      tablesPro.areaid,
      table.tableid,
      date,
      booking.name,
      booking.phone,
      booking.persons,
      booking.advance,
      context,
    );
    if (!mounted) {
      return;
    }
    if (saved) {
      tablesPro.notifyListenerz();
      ft.Fluttertoast.showToast(
        msg: "Table booked",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> _showBookingDetails(int index) async {
    final tablesPro = Provider.of<AllTablesPro>(context, listen: false);
    final table = tablesPro.mytables[index];
    final booking = table.booking!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(table.tablename),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: "Customer", value: booking.name),
                _InfoRow(label: "Phone", value: booking.phn),
                _InfoRow(
                    label: "Persons", value: booking.ttlpersons.toString()),
                _InfoRow(label: "Advance", value: booking.advance.toString()),
                _InfoRow(
                  label: "Booked for",
                  value: DateFormat('dd MMM yyyy, hh:mm a')
                      .format(booking.booked_for),
                ),
                _InfoRow(
                  label: "Check-in",
                  value: booking.check_in == null
                      ? "Not checked in"
                      : DateFormat('hh:mm a').format(booking.check_in!),
                ),
                _InfoRow(
                  label: "Check-out",
                  value: booking.check_out == null
                      ? "Not checked out"
                      : DateFormat('hh:mm a').format(booking.check_out!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () => _cancelBooking(dialogContext, table, booking),
              style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
              child: const Text("Cancel Booking"),
            ),
            if (booking.check_in == null)
              ElevatedButton(
                onPressed: () => _checkIn(dialogContext, table, booking),
                child: const Text("Check In"),
              )
            else if (booking.check_out == null)
              ElevatedButton(
                onPressed: () => _checkOut(dialogContext, table, booking),
                child: const Text("Check Out"),
              ),
          ],
        );
      },
    );
  }

  Future<void> _cancelBooking(
    BuildContext dialogContext,
    TableObject table,
    BookingObject booking,
  ) async {
    final ok = await MyServer.cancel(booking.bookid);
    if (!mounted) {
      return;
    }
    if (ok) {
      table.booking = null;
      Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
      Navigator.of(dialogContext).pop();
    }
  }

  Future<void> _checkIn(
    BuildContext dialogContext,
    TableObject table,
    BookingObject booking,
  ) async {
    final now = DateTime.now();
    final ok = await MyServer.checkIn(booking.bookid, now);
    if (!mounted) {
      return;
    }
    if (ok) {
      booking.check_in = now;
      Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
      Navigator.of(dialogContext).pop();
    }
  }

  Future<void> _checkOut(
    BuildContext dialogContext,
    TableObject table,
    BookingObject booking,
  ) async {
    final now = DateTime.now();
    final ok = await MyServer.checkOut(booking.bookid, now);
    if (!mounted) {
      return;
    }
    if (ok) {
      booking.check_out = now;
      table.booking = null;
      Provider.of<AllTablesPro>(context, listen: false).notifyListenerz();
      Navigator.of(dialogContext).pop();
    }
  }
}

class _BookingFormData {
  const _BookingFormData({
    required this.name,
    required this.phone,
    required this.persons,
    required this.advance,
  });

  final String name;
  final String phone;
  final int persons;
  final int advance;
}

class _NewBookingDialog extends StatefulWidget {
  const _NewBookingDialog({
    required this.areaName,
    required this.tableName,
    required this.date,
  });

  final String areaName;
  final String tableName;
  final DateTime date;

  @override
  State<_NewBookingDialog> createState() => _NewBookingDialogState();
}

class _NewBookingDialogState extends State<_NewBookingDialog> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _persons = TextEditingController();
  final TextEditingController _advance = TextEditingController(text: "0");

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _persons.dispose();
    _advance.dispose();
    super.dispose();
  }

  void _submit() {
    final persons = int.tryParse(_persons.text.trim());
    final advance = int.tryParse(_advance.text.trim());
    if (_name.text.trim().isEmpty ||
        _phone.text.trim().isEmpty ||
        persons == null ||
        persons <= 0 ||
        advance == null) {
      ft.Fluttertoast.showToast(
        msg: "Enter valid booking details",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    Navigator.of(context).pop(
      _BookingFormData(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        persons: persons,
        advance: advance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Booking"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _InfoRow(label: "Area", value: widget.areaName),
              _InfoRow(label: "Table", value: widget.tableName),
              _InfoRow(
                label: "Date",
                value: DateFormat('dd MMM yyyy, hh:mm a').format(widget.date),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(labelText: "Customer name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone number"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _persons,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Persons"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _advance,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Advance"),
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Book Table"),
        ),
      ],
    );
  }
}

class _BookingFloor extends StatelessWidget {
  const _BookingFloor({
    required this.areaName,
    required this.date,
    required this.tables,
    required this.onTableTap,
  });

  final String areaName;
  final DateTime date;
  final List<TableObject> tables;
  final ValueChanged<int> onTableTap;

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
                    Text(areaName,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      DateFormat('EEEE, dd MMM yyyy • hh:mm a').format(date),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const _LegendDot(color: AppTheme.success, label: "Available"),
              const SizedBox(width: 12),
              const _LegendDot(color: AppTheme.danger, label: "Booked"),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: DecoratedBox(
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size =
                        Size(constraints.maxWidth, constraints.maxHeight);
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _FloorGridPainter()),
                        ),
                        if (tables.isEmpty)
                          const Center(child: Text("No tables in this area")),
                        for (int i = 0; i < tables.length; i++)
                          Positioned(
                            left: tables[i].dx.clamp(8.0, size.width - 88),
                            top: tables[i].dy.clamp(8.0, size.height - 92),
                            child: _BookableTable(
                              table: tables[i],
                              onTap: () => onTableTap(i),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookableTable extends StatelessWidget {
  const _BookableTable({required this.table, required this.onTap});

  final TableObject table;
  final VoidCallback onTap;

  static const Map<String, String> _assets = {
    "table": "images/table.png",
    "big_table": "images/big_table.png",
    "circle": "images/circle.png",
    "square": "images/Square.png",
    "round_bed": "images/round_bed.png",
    "bed_beach": "images/bed_beach.png",
  };

  @override
  Widget build(BuildContext context) {
    final booked = table.booking != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 88,
          height: 92,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: booked ? AppTheme.danger : AppTheme.success,
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
              Expanded(
                child: Image.asset(
                  _assets[table.shape] ?? "images/table.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                table.tablename,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: booked ? AppTheme.danger : AppTheme.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  child: Text(
                    booked ? "Booked" : "Open",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingSummary extends StatelessWidget {
  const _BookingSummary({
    required this.areaName,
    required this.date,
    required this.totalTables,
    required this.bookedTables,
    required this.onBack,
  });

  final String areaName;
  final DateTime date;
  final int totalTables;
  final int bookedTables;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final available = totalTables - bookedTables;
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
          Text("Booking", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            "Tap an available table to create a booking.",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _StatCard(label: "Total", value: totalTables.toString()),
          _StatCard(label: "Available", value: available.toString()),
          _StatCard(label: "Booked", value: bookedTables.toString()),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text("Back"),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
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
