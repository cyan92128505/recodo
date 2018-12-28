class Recode {
  final String name;
  final String value;

  Recode(this.name, this.value);
  
  Recode.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['value'];

  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'value': value,
    };
}