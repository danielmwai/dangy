import { PayloadStorage } from "./payloadStorage";

// Storage instance that will be set by the main app
let _storage: PayloadStorage | null = null;

export function setStorage(storage: PayloadStorage) {
  _storage = storage;
}

export function getStorage(): PayloadStorage {
  if (!_storage) {
    throw new Error("Storage not initialized. Make sure to call setStorage() first.");
  }
  return _storage;
}