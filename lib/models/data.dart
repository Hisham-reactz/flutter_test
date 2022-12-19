import 'dart:convert';


import 'datum.dart';

class Data {
	final List<Datum>? data;

	const Data({this.data});

	@override
	String toString() => 'Data(data: $data)';

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				data: (data['data'] as List<dynamic>?)
						?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toMap() => {
				'data': data?.map((e) => e.toMap()).toList(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
	factory Data.fromJson(String data) {
		return Data.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
	String toJson() => json.encode(toMap());

	Data copyWith({
		List<Datum>? data,
	}) {
		return Data(
			data: data ?? this.data,
		);
	}
}
