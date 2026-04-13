import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/shell_providers.dart';
import '../../../core/format/note_date_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../search/data/service_records_repository.dart';
import '../data/vehicle_repository.dart';

class VehiclePage extends ConsumerStatefulWidget {
  const VehiclePage({super.key});

  @override
  ConsumerState<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends ConsumerState<VehiclePage> {
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _vin = TextEditingController();
  final _plate = TextEditingController();
  final _color = TextEditingController();
  final _odometer = TextEditingController();
  final _notes = TextEditingController();

  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hydrate());
  }

  Future<void> _hydrate() async {
    final v = await ref.read(vehicleRepositoryProvider).getOrCreateProfile();
    if (!mounted) return;
    setState(() {
      _make.text = v.make;
      _model.text = v.model;
      _year.text = v.year;
      _vin.text = v.vin;
      _plate.text = v.plate;
      _color.text = v.color;
      _odometer.text = v.odometerKm != null ? '${v.odometerKm}' : '';
      _notes.text = v.notes;
      _hydrated = true;
    });
  }

  @override
  void dispose() {
    _make.dispose();
    _model.dispose();
    _year.dispose();
    _vin.dispose();
    _plate.dispose();
    _color.dispose();
    _odometer.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    final odo = int.tryParse(_odometer.text.trim().replaceAll(RegExp(r'\s'), ''));
    await ref.read(vehicleRepositoryProvider).save(
          make: _make.text.trim(),
          model: _model.text.trim(),
          year: _year.text.trim(),
          vin: _vin.text.trim(),
          plate: _plate.text.trim(),
          color: _color.text.trim(),
          odometerKm: odo,
          notes: _notes.text.trim(),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.vehicleSavedSnackbar)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final serviceRepo = ref.watch(serviceRecordsRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(l10n.vehicleTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text(l10n.vehicleSectionService, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          StreamBuilder<List<ServiceTypeLast>>(
            stream: serviceRepo.watchLastByActionType(),
            builder: (context, snap) {
              final rows = snap.data ?? [];
              if (rows.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.vehicleServiceEmpty, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => ref.read(mainTabProvider.notifier).state = 3,
                      icon: const Icon(Icons.build_outlined, size: 20),
                      label: Text(l10n.vehicleOpenServiceLog),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...rows.map(
                    (e) {
                      final label = e.actionType.trim().isEmpty ? '—' : e.actionType;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(label),
                        subtitle: Text(formatNoteListDate(context, e.lastPerformedAt)),
                      );
                    },
                  ),
                  TextButton.icon(
                    onPressed: () => ref.read(mainTabProvider.notifier).state = 3,
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text(l10n.vehicleOpenServiceLog),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text(l10n.vehicleSectionDetails, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          if (!_hydrated)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
          else ...[
            TextField(
              controller: _make,
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldMake,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _model,
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldModel,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _year,
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldYear,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _vin,
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldVin,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _plate,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldPlate,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _color,
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldColor,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _odometer,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldOdometer,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _notes,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: l10n.vehicleFieldNotes,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: () => _save(l10n),
                icon: const Icon(Icons.save_outlined),
                label: Text(l10n.vehicleSave),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
