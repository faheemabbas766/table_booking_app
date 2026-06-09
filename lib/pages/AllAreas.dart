import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:table_booking/Providers/allareaspro.dart';
import 'package:table_booking/theme/app_theme.dart';

import '../Api & Routes/routes.dart';
import '../Providers/alltablespro.dart';
import '../myserver.dart';

class AllAreas extends StatefulWidget {
  const AllAreas({super.key});

  @override
  State<AllAreas> createState() => _AllAreasState();
}

class _AllAreasState extends State<AllAreas> {
  @override
  void initState() {
    super.initState();
    _loadAllAreas();
  }

  Future<void> _loadAllAreas() async {
    while (mounted) {
      final value = await MyServer.getAllAreas(context);
      if (value) {
        final provider = Provider.of<AllAreasPro>(context, listen: false);
        provider.reload = !provider.reload;
        provider.isloaded = true;
        provider.notifyListenerz();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Select Area"),
        ),
        body: Consumer<AllAreasPro>(
          builder: (context, provider, child) {
            if (!provider.isloaded) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.areas.isEmpty) {
              return const _AreaEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: provider.areas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final area = provider.areas[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _openArea(index),
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
                              Icons.deck,
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
                          const Icon(
                            Icons.chevron_right,
                            color: AppTheme.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _openArea(int index) async {
    final area = Provider.of<AllAreasPro>(context, listen: false).areas[index];
    final tablesPro = Provider.of<AllTablesPro>(context, listen: false);
    tablesPro.areaid = area.areaid;
    tablesPro.areaname = area.areaname;

    final hasTables = await MyServer.checkTablesCount(area.areaid);
    if (!mounted || !hasTables) {
      return;
    }

    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushNamed(RouteManager.alltablespage);
  }
}

class _AreaEmptyState extends StatelessWidget {
  const _AreaEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.deck, size: 44, color: AppTheme.textSecondary),
            const SizedBox(height: 12),
            Text("No areas added",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              "Create an area first, then add tables from the manage screen.",
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
