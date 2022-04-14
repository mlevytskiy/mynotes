class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CloudNotCreateNoteException extends CloudStorageException {}

class CloudNotGetAllNotesException extends CloudStorageException {}

class CloudNotUpdateNotesException extends CloudStorageException {}

class CloudNotDeleteNotesException extends CloudStorageException {}