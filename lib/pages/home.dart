import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:provider/provider.dart';
import 'package:table_booking/theme/app_theme.dart';

import '../Api & Routes/routes.dart';
import '../Providers/homepro.dart';
import '../myserver.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _areaName = TextEditingController();

  @override
  void dispose() {
    _areaName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final logoSize = shortestSide.clamp(120.0, 190.0);

    return SafeArea(
      child: Scaffold(
        drawer: _HomeDrawer(onAddArea: _showAddAreaDialog),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Book a Table"),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: logoSize,
                      height: logoSize,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Image.asset("images/logo.png"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "Table Booking",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Select a date and choose an available area to reserve a table.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _startBooking,
                        icon: const Icon(Icons.event_available),
                        label: const Text("Book Now"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddAreaDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("New Area"),
          content: TextField(
            controller: _areaName,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: "Enter area name",
            ),
            onSubmitted: (_) => _addArea(dialogContext),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => _addArea(dialogContext),
              child: const Text("Add Area"),
            ),
          ],
        );
      },
    );
    _areaName.clear();
  }

  Future<void> _addArea(BuildContext dialogContext) async {
    final name = _areaName.text.trim();
    if (name.isEmpty) {
      ft.Fluttertoast.showToast(
        msg: "Please enter area name",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    final added = await MyServer.addArea(name);
    if (!mounted) {
      return;
    }
    if (added) {
      final homePro = Provider.of<HomePro>(context, listen: false);
      homePro.totalareas = (homePro.totalareas ?? 0) + 1;
      homePro.notifyListenerz();
      Navigator.of(dialogContext).pop();
      ft.Fluttertoast.showToast(
        msg: "Area '$name' added",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
    } else {
      ft.Fluttertoast.showToast(
        msg: "Area already exists",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> _startBooking() async {
    if ((Provider.of<HomePro>(context, listen: false).totalareas ?? 0) == 0) {
      ft.Fluttertoast.showToast(
        msg: "No area added yet",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(data: AppTheme.pickerTheme(context), child: child!);
      },
    );
    if (!mounted || selectedDate == null) {
      return;
    }

    final pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return Theme(data: AppTheme.pickerTheme(context), child: child!);
      },
    );
    if (!mounted || pickedTime == null) {
      return;
    }

    Provider.of<HomePro>(context, listen: false).d = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    Navigator.of(context).pushNamed(RouteManager.allareaspage);
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer({required this.onAddArea});

  final VoidCallback onAddArea;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width.clamp(280.0, 340.0),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/logo.png",
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Dream Booking",
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _DrawerAction(
              icon: Icons.add_business,
              title: "Add Area",
              onTap: () {
                Navigator.of(context).pop();
                onAddArea();
              },
            ),
            _DrawerAction(
              icon: Icons.grid_view,
              title: "All Areas",
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RouteManager.editareaspage);
              },
            ),
            _DrawerAction(
              icon: Icons.search,
              title: "Search",
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RouteManager.searchpage);
              },
            ),
            _DrawerAction(
              icon: Icons.assessment,
              title: "Report",
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RouteManager.edittablespage);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerAction extends StatelessWidget {
  const _DrawerAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: onTap,
      ),
    );
  }
}
