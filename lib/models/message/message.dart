import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  factory Message({
    String? id,
    String? content,
    @JsonKey(name: "sender_id") String? senderId,
    @JsonKey(name: "receiver_id") String? receiverId,
    @JsonKey(name: "conversation_id") String? conversationId,
    @JsonKey(name: "read_status") bool? readStatus,
    @JsonKey(name: "url_file") String? urlFile,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
