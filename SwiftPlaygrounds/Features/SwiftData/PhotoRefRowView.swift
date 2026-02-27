import SwiftData
import SwiftUI

struct PhotoRefRowView: View {
    @Bindable var photoRef: PhotoRef

    @State private var isMissing = false

    var body: some View {
        HStack(spacing: 12) {
            PhotoAssetImageView(
                localIdentifier: photoRef.assetLocalIdentifier,
                targetSize: CGSize(width: 200, height: 200),
                contentMode: .fill
            ) { missing in
                handleResolutionResult(isMissing: missing)
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(photoRef.memo.isEmpty ? "メモなし" : photoRef.memo)
                    .lineLimit(1)
                if isMissing {
                    Text("写真が見つかりません")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                Text(photoRef.createdAt, format: Date.FormatStyle(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func handleResolutionResult(isMissing: Bool) {
        self.isMissing = isMissing
        guard !isMissing else {
            return
        }
        photoRef.lastResolvedAt = .now
    }
}
