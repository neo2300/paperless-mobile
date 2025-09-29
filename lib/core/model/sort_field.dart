enum SortField {
  archiveSerialNumber('archive_serial_number'),
  correspondentName('correspondent__name'),
  title('title'),
  documentType('document_type__name'),
  created('created'),
  added('added'),
  modified('modified'),
  notes('num_notes'),
  owner('owner'),
  page('page_count');

  final String value;

  const SortField(this.value);

  SortField? fromValue(String value) {
    return SortField.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SortField.archiveSerialNumber,
    );
  }
}
