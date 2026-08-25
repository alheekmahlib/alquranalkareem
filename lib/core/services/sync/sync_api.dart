import 'package:either_dart/either.dart';

import '../../utils/constants/api_constants.dart';
import '../api_client.dart' show ApiClient, HttpMethod;
import '../error_handling_system.dart' show Failure;
import 'sync_models.dart';

/// عميل خدمة المزامنة (Cloudflare Worker) — يركب على `ApiClient` القائم
/// بنمط `Either<Failure, T>` نفسه. الـ Worker يعتبر room_id هو سرّ التفويض،
/// لذا يُمرر ضمن المسار دون ترويسات إضافية.
class SyncApi {
  final ApiClient _client = ApiClient();

  String _roomPath(String roomId, [String suffix = '']) =>
      '${ApiConstants.syncApiUrl}/v1/rooms/$roomId$suffix';

  /// يحوّل استجابة الـ Worker إلى Either — الـ Worker يعيد أخطاء 4xx
  /// بجسم `{error: {code, message}}` وDio يمررها كنجاح (status < 500).
  Either<Failure, Map<String, dynamic>> _parse(dynamic data) {
    if (data is Map && data['error'] == null) {
      return Right(Map<String, dynamic>.from(data));
    }
    if (data is Map && data['error'] is Map) {
      final error = Map<String, dynamic>.from(data['error'] as Map);
      return Left(
        Failure(
          _httpStatusFor(error['code'] as String?),
          error['message'] as String? ?? 'Sync request failed',
        ),
      );
    }
    return Left(Failure(400, 'Invalid sync response'));
  }

  int _httpStatusFor(String? code) {
    switch (code) {
      case 'ROOM_FULL':
        return 403;
      case 'ROOM_NOT_FOUND':
        return 404;
      case 'PAYLOAD_TOO_LARGE':
        return 413;
      case 'RATE_LIMITED':
        return 429;
      default:
        return 400;
    }
  }

  Future<Either<Failure, String>> createRoom() async {
    final result = await _client.request(
      endpoint: '${ApiConstants.syncApiUrl}/v1/rooms',
      method: HttpMethod.post,
    );
    return result.fold(
      (failure) => Left(failure),
      (data) => _parse(data).fold(
        (failure) => Left(failure),
        (map) => Right(map['room_id'] as String),
      ),
    );
  }

  Future<Either<Failure, SyncJoinResult>> joinRoom(
    String roomId,
    String deviceId,
  ) async {
    final result = await _client.request(
      endpoint: _roomPath(roomId, '/join'),
      method: HttpMethod.post,
      data: {'device_id': deviceId},
    );
    return result.fold(
      (failure) => Left(failure),
      (data) => _parse(data).fold((failure) => Left(failure), (map) {
        final items = (map['items'] as List? ?? [])
            .map(
              (item) => SyncChange.fromPullJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
        return Right(
          SyncJoinResult(
            latestSeq: (map['latest_seq'] as num).toInt(),
            deviceCount: (map['device_count'] as num).toInt(),
            items: items,
          ),
        );
      }),
    );
  }

  Future<Either<Failure, int>> pushChanges(
    String roomId,
    String deviceId,
    List<SyncChange> changes,
  ) async {
    final result = await _client.request(
      endpoint: _roomPath(roomId, '/changes'),
      method: HttpMethod.post,
      data: {
        'device_id': deviceId,
        'changes': changes.map((change) => change.toRequestJson()).toList(),
      },
    );
    return result.fold(
      (failure) => Left(failure),
      (data) => _parse(data).fold(
        (failure) => Left(failure),
        (map) => Right((map['latest_seq'] as num).toInt()),
      ),
    );
  }

  Future<Either<Failure, (List<SyncChange>, int latestSeq, bool hasMore)>>
  pullChanges(String roomId, int since) async {
    final result = await _client.request(
      endpoint: _roomPath(roomId, '/changes'),
      method: HttpMethod.get,
      queryParameters: {'since': since},
    );
    return result.fold(
      (failure) => Left(failure),
      (data) => _parse(data).fold((failure) => Left(failure), (map) {
        final changes = (map['changes'] as List? ?? [])
            .map(
              (item) => SyncChange.fromPullJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
        return Right((
          changes,
          (map['latest_seq'] as num).toInt(),
          (map['has_more'] as bool? ?? false),
        ));
      }),
    );
  }

  Future<Either<Failure, SyncRoomInfo>> roomInfo(String roomId) async {
    final result = await _client.request(
      endpoint: _roomPath(roomId),
      method: HttpMethod.get,
    );
    return result.fold(
      (failure) => Left(failure),
      (data) => _parse(data).fold(
        (failure) => Left(failure),
        (map) => Right(
          SyncRoomInfo(
            deviceCount: (map['device_count'] as num).toInt(),
            lastActiveAt: (map['last_active_at'] as num).toInt(),
            latestSeq: (map['latest_seq'] as num).toInt(),
          ),
        ),
      ),
    );
  }
}
