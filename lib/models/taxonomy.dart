import 'dart:convert';


class Taxonomy {
	final int? id;
	final String? guid;
	final String? slug;
	final String? name;

	const Taxonomy({this.id, this.guid, this.slug, this.name});

	@override
	String toString() {
		return 'Taxonomy(id: $id, guid: $guid, slug: $slug, name: $name)';
	}

	factory Taxonomy.fromMap(Map<String, dynamic> data) => Taxonomy(
				id: data['id'] as int?,
				guid: data['Guid'] as String?,
				slug: data['slug'] as String?,
				name: data['name'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'Guid': guid,
				'slug': slug,
				'name': name,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Taxonomy].
	factory Taxonomy.fromJson(String data) {
		return Taxonomy.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Taxonomy] to a JSON string.
	String toJson() => json.encode(toMap());

	Taxonomy copyWith({
		int? id,
		String? guid,
		String? slug,
		String? name,
	}) {
		return Taxonomy(
			id: id ?? this.id,
			guid: guid ?? this.guid,
			slug: slug ?? this.slug,
			name: name ?? this.name,
		);
	}
}
