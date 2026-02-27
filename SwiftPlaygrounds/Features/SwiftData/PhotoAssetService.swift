import CoreGraphics
import Photos
import UIKit

enum PhotoAssetImageResult {
    case image(UIImage)
    case missingAsset
    case unavailable
}

final class PhotoAssetService {
    static let shared = PhotoAssetService()

    private let imageManager = PHCachingImageManager()

    private init() {}

    func authorizationStatus() -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    func requestAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                continuation.resume(returning: status)
            }
        }
    }

    @discardableResult
    func requestImage(
        localIdentifier: String,
        targetSize: CGSize,
        contentMode: PHImageContentMode,
        deliveryMode: PHImageRequestOptionsDeliveryMode = .opportunistic,
        completion: @escaping (PhotoAssetImageResult) -> Void
    ) -> PHImageRequestID {
        guard let asset = fetchAsset(localIdentifier: localIdentifier) else {
            completion(.missingAsset)
            return PHInvalidImageRequestID
        }

        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.deliveryMode = deliveryMode
        imageRequestOptions.resizeMode = .fast
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.isSynchronous = false

        return imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: contentMode,
            options: imageRequestOptions
        ) { image, _ in
            guard let image else {
                completion(.unavailable)
                return
            }
            completion(.image(image))
        }
    }

    func cancelRequest(_ requestID: PHImageRequestID) {
        guard requestID != PHInvalidImageRequestID else {
            return
        }
        imageManager.cancelImageRequest(requestID)
    }

    private func fetchAsset(localIdentifier: String) -> PHAsset? {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        return fetchResult.firstObject
    }
}
