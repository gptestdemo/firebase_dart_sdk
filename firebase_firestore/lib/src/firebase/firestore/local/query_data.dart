// File created by
// Lung Razvan <long1eu>
// on 20/09/2018

import 'dart:typed_data';

import 'package:firebase_firestore/src/firebase/firestore/core/query.dart';
import 'package:firebase_firestore/src/firebase/firestore/local/query_purpose.dart';
import 'package:firebase_firestore/src/firebase/firestore/model/snapshot_version.dart';
import 'package:firebase_firestore/src/firebase/firestore/remote/watch_stream.dart';

/// An immutable set of metadata that the store will need to keep track of for
/// each query.
class QueryData {
  final Query query;
  final int targetId;
  final int sequenceNumber;
  final QueryPurpose purpose;
  final SnapshotVersion snapshotVersion;
  final Uint8List resumeToken;

  /// Creates a new QueryData with the given values.
  ///
  /// The [query] being listened to. [targetId] to which the query corresponds,
  /// assigned by the [LocalStore] for user queries or the [SyncEngine] for
  /// limbo queries. [purpose] of the query. The latest [snapshotVersion] seen
  /// for this target. [resumeToken] is an opaque, server-assigned token that
  /// allows watching a query to be resumed after disconnecting without
  /// retransmitting all the data that matches the query. The resume token
  /// essentially identifies a point in time from which the server should resume
  /// sending results.
  QueryData(this.query, this.targetId, this.sequenceNumber, this.purpose,
      this.snapshotVersion, this.resumeToken)
      : assert(query != null),
        assert(snapshotVersion != null),
        assert(resumeToken != null);

  /// Convenience constructor for use when creating a [QueryData] for the first
  /// time.
  factory QueryData.init(
      Query query, int targetId, int sequenceNumber, QueryPurpose purpose) {
    return QueryData(
      query,
      targetId,
      sequenceNumber,
      purpose,
      SnapshotVersion.none,
      WatchStream.emptyResumeToken,
    );
  }

  /// Creates a new query data instance with an updated snapshot version and
  /// resume token.
  QueryData copy(SnapshotVersion snapshotVersion, List<int> resumeToken,
      int sequenceNumber) {
    return QueryData(
      query,
      targetId,
      sequenceNumber,
      purpose,
      snapshotVersion,
      Uint8List.fromList(resumeToken),
    );
  }
}