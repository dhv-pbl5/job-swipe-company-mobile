import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pbl5/models/system_roles_response/system_roles_response.dart';

part 'language.freezed.dart';

part 'language.g.dart';

@freezed
class Language with _$Language {
  factory Language({
    String? id,
    @JsonKey(name: 'language') SystemConstant? languageConstant,
    String? score,
    @JsonKey(name: 'certificate_date') String? certificateDate,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _Language;

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
}
