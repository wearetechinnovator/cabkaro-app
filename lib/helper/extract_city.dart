String extractCity(String address) {
  List parts = address.split(",");

  // remove Plus Code if exists (usually first part with '+')
  if (parts[0].contains("+")) {
    parts.removeAt(0);
  }

  // trim spaces
  parts = parts.map((e) => e.trim()).toList();

  // return last meaningful part before state
  if (parts.length >= 2) {
    return parts[parts.length - 2]; // usually city
  }

  return parts.first;
}