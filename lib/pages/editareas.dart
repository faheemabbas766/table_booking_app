import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:provider/provider.dart';
import 'package:table_booking/Providers/manageareapro.dart';
import 'package:table_booking/theme/app_theme.dart';

import '../Api & Routes/routes.dart';
import '../Providers/editareaspro.dart';
import '../myserver.dart';

class EditAreas extends StatefulWidget {
  const EditAreas({super.key});

  @override
  State<EditAreas> createState() => _EditAreasState();
}

class _EditAreasState extends State<EditAreas> {
  final TextEditingController _areaName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllAreas();
  }

  @override
  void dispose() {
    _areaName.dispose();
    super.dispose();
  }

  Future<void> _loadAllAreas() async {
    while (mounted) {
      final value = await MyServer.getEditAllAreas(context);
      if (value) {
        final provider = Provider.of<EditAreasPro>(context, listen: false);
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
          if (!didPop) {
            return;
          }
          Provider.of<EditAreasPro>(context, listen: false).clearAll();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Areas"),
          ),
          body: Consumer<EditAreasPro>(
            builder: (context, provider, child) {
              if (!provider.isloaded) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.areas.isEmpty) {
                return _EmptyState(
                  icon: Icons.grid_view,
                  title: "No areas added",
                  message: "Add an area from the home menu to manage tables.",
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: provider.areas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final area = provider.areas[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.table_restaurant,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              area.areaname,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            tooltip: "Edit",
                            onPressed: () => _showUpdateAreaDialog(index),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: "Delete",
                            onPressed: () => _deleteArea(index),
                            color: AppTheme.danger,
                            icon: const Icon(Icons.delete_outline),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.success,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            onPressed: () => _manageArea(index),
                            child: const Text("Manage"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _manageArea(int index) {
    final area = Provider.of<EditAreasPro>(context, listen: false).areas[index];
    final managePro = Provider.of<ManageAreaPro>(context, listen: false);
    managePro.areaid = area.areaid;
    managePro.areaname = area.areaname;

    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    ).then((value) {
      Navigator.of(context).pushNamed(RouteManager.manageareapage);
    });
  }

  Future<void> _showUpdateAreaDialog(int index) async {
    final provider = Provider.of<EditAreasPro>(context, listen: false);
    _areaName.text = provider.areas[index].areaname;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Update Area"),
          content: TextField(
            controller: _areaName,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(hintText: "Enter area name"),
            onSubmitted: (_) => _updateArea(dialogContext, index),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => _updateArea(dialogContext, index),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    _areaName.clear();
  }

  Future<void> _updateArea(BuildContext dialogContext, int index) async {
    final name = _areaName.text.trim();
    if (name.isEmpty) {
      ft.Fluttertoast.showToast(
        msg: "Please enter area name",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    final provider = Provider.of<EditAreasPro>(context, listen: false);
    final updated =
        await MyServer.updateAreaNAme(provider.areas[index].areaid, name);
    if (!mounted) {
      return;
    }
    if (updated) {
      provider.areas[index].areaname = name;
      provider.notifyListenerz();
      Navigator.of(dialogContext).pop();
      ft.Fluttertoast.showToast(
        msg: "Updated successfully",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> _deleteArea(int index) async {
    final provider = Provider.of<EditAreasPro>(context, listen: false);
    final area = provider.areas[index];
    final hasTables = await MyServer.checkTablesCount(area.areaid);
    if (!mounted) {
      return;
    }
    if (hasTables) {
      ft.Fluttertoast.showToast(
        msg: "Remove tables before deleting this area",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
      return;
    }

    final deleted = await MyServer.deleteArea(area.areaid);
    if (!mounted) {
      return;
    }
    if (deleted) {
      provider.areas.removeAt(index);
      provider.notifyListenerz();
      ft.Fluttertoast.showToast(
        msg: "Area deleted",
        toastLength: ft.Toast.LENGTH_SHORT,
      );
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: AppTheme.textSecondary),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
