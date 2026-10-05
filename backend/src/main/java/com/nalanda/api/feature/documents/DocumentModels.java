package com.nalanda.api.feature.documents;

import java.time.Instant;
import java.util.List;

record DocumentUpload(Long programId, String filename, String contentType, long size) {
}

record DocumentRenameRequest(String filename) {
}

record DocumentDownload(String filename, String contentType, byte[] content) {
}