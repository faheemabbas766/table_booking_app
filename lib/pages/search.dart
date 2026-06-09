import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_booking/Entities/areaobject.dart';
import 'package:table_booking/Entities/searchobject.dart';
import 'package:table_booking/Providers/searchpro.dart';
import 'package:table_booking/theme/app_theme.dart';

import '../myserver.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _customer = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSearch();
  }

  @override
  void dispose() {
    _customer.dispose();
    super.dispose();
  }

  Future<void> _loadSearch() async {
    while (mounted) {
      final value = await MyServer.getAllSearch(context);
      if (value) {
        final provider = Provider.of<SearchPro>(context, listen: false);
        if (provider.areas.isNotEmpty) {
          provider.areas.insert(0, AreaObject(0, "All areas"));
          provider.selectedarea = provider.areas.first;
          provider.loaded1 = true;
        } else {
          provider.loaded1 = false;
        }
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
            Provider.of<SearchPro>(context, listen: false).clearAll();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Search"),
          ),
          body: Consumer<SearchPro>(
            builder: (context, provider, child) {
              if (provider.loaded1 == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.loaded1 == false) {
                return const _SearchEmptyState();
              }

              return Column(
                children: [
                  _SearchFilters(
                    provider: provider,
                    customer: _customer,
                    onPickDate: _pickDate,
                    onSearch: _runSearch,
                  ),
                  Expanded(
                    child: provider.nothingsearched
                        ? const _SearchHint()
                        : provider.loaded2
                            ? _SearchResults(results: provider.searches)
                            : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final provider = Provider.of<SearchPro>(context, listen: false);
    final date = await showDatePicker(
      context: context,
      initialDate: provider.d ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(data: AppTheme.pickerTheme(context), child: child!);
      },
    );
    if (date == null) {
      return;
    }

    provider.d = date;
    provider.datetext = DateFormat('dd MMM yyyy').format(date);
    provider.notifyListenerz();
  }

  Future<void> _runSearch() async {
    final provider = Provider.of<SearchPro>(context, listen: false);
    if (provider.d == null) {
      return;
    }

    provider.selectedarea ??= provider.areas.first;
    provider.nothingsearched = false;
    provider.loaded2 = false;
    provider.notifyListenerz();

    await MyServer.searchBooking(
      "${provider.d!.year}-${provider.d!.month}-${provider.d!.day}",
      _customer.text.trim(),
      provider.selectedarea!,
      context,
    );

    if (!mounted) {
      return;
    }
    provider.loaded2 = true;
    provider.notifyListenerz();
  }
}

class _SearchFilters extends StatelessWidget {
  const _SearchFilters({
    required this.provider,
    required this.customer,
    required this.onPickDate,
    required this.onSearch,
  });

  final SearchPro provider;
  final TextEditingController customer;
  final VoidCallback onPickDate;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Filters", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: OutlinedButton.icon(
                    onPressed: onPickDate,
                    icon: const Icon(Icons.calendar_month),
                    label: Text(provider.datetext),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: customer,
                    decoration: const InputDecoration(
                      labelText: "Customer",
                      prefixIcon: Icon(Icons.person_search),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<AreaObject>(
                    initialValue: provider.selectedarea,
                    decoration: const InputDecoration(labelText: "Area"),
                    items: provider.areas
                        .map(
                          (area) => DropdownMenuItem(
                            value: area,
                            child: Text(area.areaname),
                          ),
                        )
                        .toList(),
                    onChanged: (area) {
                      provider.selectedarea = area;
                      provider.notifyListenerz();
                    },
                  ),
                ),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: provider.d == null ? null : onSearch,
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.results});

  final List<SearchObject> results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const _NoResults();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = results[index];
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
                    Icons.event_seat,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${item.areaname} • ${item.tablename}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a')
                            .format(item.bookedfor),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Rs ${item.advance}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text("${item.ttlpersons} persons"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return const _CenteredMessage(
      icon: Icons.manage_search,
      title: "Search bookings",
      message: "Select a date and apply filters to find reservations.",
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    return const _CenteredMessage(
      icon: Icons.grid_view,
      title: "No areas available",
      message: "Add areas and tables before searching bookings.",
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return const _CenteredMessage(
      icon: Icons.search_off,
      title: "No results found",
      message: "Try a different date, customer name, or area.",
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
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
