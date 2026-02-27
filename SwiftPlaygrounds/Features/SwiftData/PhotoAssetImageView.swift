import Photos
import SwiftUI
import UIKit

struct PhotoAssetImageView: View {
    let localIdentifier: String
    let targetSize: CGSize
    let contentMode: ContentMode
    var onResolution: ((Bool) -> Void)?

    @State private var image: UIImage?
    @State private var isMissing = false
    @State private var requestID: PHImageRequestID = PHInvalidImageRequestID

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isMissing {
                missingPlaceholder
            } else {
                loadingPlaceholder
            }
        }
        .background(.gray.opacity(0.2))
        .onAppear {
            loadImage()
        }
        .onChange(of: localIdentifier) { _, _ in
            loadImage()
        }
        .onDisappear {
            PhotoAssetService.shared.cancelRequest(requestID)
        }
    }

    private var missingPlaceholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo.badge.exclamationmark")
                .font(.title3)
            Text("写真が見つかりません")
                .font(.caption2)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.secondary)
        .padding(8)
    }

    private var loadingPlaceholder: some View {
        ProgressView()
            .controlSize(.small)
    }

    private func loadImage() {
        PhotoAssetService.shared.cancelRequest(requestID)
        image = nil
        isMissing = false

        let scale = UIScreen.main.scale
        let pixelSize = CGSize(width: targetSize.width * scale, height: targetSize.height * scale)
        let photoContentMode: PHImageContentMode = contentMode == .fill ? .aspectFill : .aspectFit

        requestID = PhotoAssetService.shared.requestImage(
            localIdentifier: localIdentifier,
            targetSize: pixelSize,
            contentMode: photoContentMode
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .image(let resolvedImage):
                    image = resolvedImage
                    isMissing = false
                    onResolution?(false)
                case .missingAsset:
                    image = nil
                    isMissing = true
                    onResolution?(true)
                case .unavailable:
                    image = nil
                    isMissing = false
                }
            }
        }
    }
}
