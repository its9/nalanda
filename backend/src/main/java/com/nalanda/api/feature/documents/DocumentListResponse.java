package com.nalanda.api.feature.documents;

import java.util.List;

public record DocumentListResponse(List<DocumentResponse> items, long total) {
}