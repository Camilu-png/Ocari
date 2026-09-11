import { initializeApp } from "firebase-admin/app";
import { Timestamp, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

initializeApp();

const db = getFirestore();

interface RecordSongCompletionResponse {
  user_id: string;
  song_id: string;
  play_count: number;
  completed: boolean;
  last_played_at: string;
  created_at: string;
}

export const recordSongCompletion = onCall(
  async (request): Promise<RecordSongCompletionResponse> => {
    const userId = request.auth?.uid;
    if (!userId) {
      throw new HttpsError("unauthenticated", "You must be signed in.");
    }

    const songId = request.data?.songId;
    if (typeof songId !== "string" || songId.trim() === "") {
      throw new HttpsError("invalid-argument", "songId is required.");
    }

    const progressRef = db
      .collection("users")
      .doc(userId)
      .collection("songs")
      .doc(songId);

    const now = Timestamp.now();
    const doc = await progressRef.get();

    if (doc.exists) {
      const prev = doc.data()!;
      const playCount = Number(prev.play_count ?? 0) + 1;

      await progressRef.update({
        play_count: playCount,
        completed: true,
        last_played_at: now,
      });

      return {
        user_id: userId,
        song_id: songId,
        play_count: playCount,
        completed: true,
        last_played_at: now.toDate().toISOString(),
        created_at: toIsoString(prev.created_at),
      };
    }

    await progressRef.set({
      play_count: 1,
      completed: true,
      last_played_at: now,
      created_at: now,
    });

    return {
      user_id: userId,
      song_id: songId,
      play_count: 1,
      completed: true,
      last_played_at: now.toDate().toISOString(),
      created_at: now.toDate().toISOString(),
    };
  },
);

function toIsoString(value: unknown): string {
  if (value instanceof Timestamp) {
    return value.toDate().toISOString();
  }
  if (typeof value === "string") {
    return value;
  }
  if (value instanceof Date) {
    return value.toISOString();
  }
  return new Date().toISOString();
}