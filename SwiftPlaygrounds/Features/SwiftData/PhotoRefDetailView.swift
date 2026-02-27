import SwiftData
import SwiftUI

struct PhotoRefDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var photoRef: PhotoRef

    @State private var isMissing = false

    var body: some View {
        Form {
            Section("Photo") {
                PhotoAssetImageView(
                    localIdentifier: photoRef.assetLocalIdentifier,
                    targetSize: CGSize(width: 1200, height: 1200),
                    contentMode: .fit
                ) { missing in
                    handleResolutionResult(isMissing: missing)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                if isMissing {
                    Text("写真が見つかりません")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            Section("Memo") {
                TextField("メモ", text: $photoRef.memo, axis: .vertical)
            }

            Section("Metadata") {
                LabeledContent("Asset ID", value: photoRef.assetLocalIdentifier)
                LabeledContent("Created At", value: photoRef.createdAt.formatted(date: .abbreviated, time: .shortened))
                if let lastResolvedAt = photoRef.lastResolvedAt {
                    LabeledContent("Last Resolved", value: lastResolvedAt.formatted(date: .abbreviated, time: .shortened))
                }
            }

            Section {
                Button("削除", role: .destructive) {
                    deletePhotoRef()
                }
            }
        }
        .navigationTitle("Photo Ref")
    }

    private func handleResolutionResult(isMissing: Bool) {
        self.isMissing = isMissing
        guard !isMissing else {
            return
        }
        photoRef.lastResolvedAt = .now
    }

    private func deletePhotoRef() {
        modelContext.delete(photoRef)
        dismiss()
    }
}
