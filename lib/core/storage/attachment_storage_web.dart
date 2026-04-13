/// Web attachments are stored inline in SQLite; this object satisfies [core_providers] only.
class AttachmentStorage {
  AttachmentStorage({required this.storageRoot});

  final String storageRoot;
}
