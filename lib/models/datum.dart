import 'dart:convert';

import 'taxonomy.dart';

class Datum {
  final String? name;
  final String? slug;
	bool? isExpanded =false;
  final List<Taxonomy>? taxonomies;

   Datum({this.name, this.slug, this.taxonomies, this.isExpanded});

  @override
  String toString() {
    return 'Datum(name: $name, slug: $slug, taxonomies: $taxonomies)';
  }

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        taxonomies: (data['taxonomies'] as List<dynamic>?)
            ?.map((e) => Taxonomy.fromMap(e as Map<String, dynamic>))
            .toList(),
        isExpanded: data['isExpanded'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'slug': slug,
        'taxonomies': taxonomies?.map((e) => e.toMap()).toList(),
        'isExpanded': false,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  Datum copyWith({
    String? name,
    String? slug,
    List<Taxonomy>? taxonomies,
		bool? isExpanded,
  }) {
    return Datum(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      taxonomies: taxonomies ?? this.taxonomies,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
