import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';

const _vehicleProfileId = 1;

class VehicleRepository {
  VehicleRepository(this._db);

  final MarsFlowDatabase _db;

  Stream<VehicleProfile?> watchProfile() {
    return (_db.select(_db.vehicleProfiles)..where((t) => t.id.equals(_vehicleProfileId))).watchSingleOrNull();
  }

  Future<VehicleProfile> getOrCreateProfile() async {
    final existing = await (_db.select(_db.vehicleProfiles)..where((t) => t.id.equals(_vehicleProfileId))).getSingleOrNull();
    if (existing != null) return existing;
    await _db.into(_db.vehicleProfiles).insert(
          VehicleProfilesCompanion.insert(id: const Value(_vehicleProfileId)),
        );
    return (await (_db.select(_db.vehicleProfiles)..where((t) => t.id.equals(_vehicleProfileId))).getSingle());
  }

  Future<void> save({
    required String make,
    required String model,
    required String year,
    required String vin,
    required String plate,
    required String color,
    int? odometerKm,
    required String notes,
  }) async {
    final now = DateTime.now();
    await getOrCreateProfile();
    await (_db.update(_db.vehicleProfiles)..where((t) => t.id.equals(_vehicleProfileId))).write(
          VehicleProfilesCompanion(
            make: Value(make),
            model: Value(model),
            year: Value(year),
            vin: Value(vin),
            plate: Value(plate),
            color: Value(color),
            odometerKm: Value(odometerKm),
            notes: Value(notes),
            updatedAt: Value(now),
          ),
        );
  }
}

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository(ref.watch(databaseProvider));
});
