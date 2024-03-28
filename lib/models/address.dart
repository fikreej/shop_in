class Address {
  final String address;
  final String city;
  final String postcode;
  final String state;
  bool selected;

  Address({
    required this.address,
    required this.city,
    required this.postcode,
    required this.state,
    this.selected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'postcode': postcode,
      'state': state,
      'selected': selected,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      postcode: json['postcode'],
      state: json['state'],
      selected: json['selected'] ?? false,
    );
  }
}
