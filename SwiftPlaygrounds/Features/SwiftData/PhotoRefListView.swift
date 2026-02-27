import Combine
import Photos
import PhotosUI
import SwiftData
import SwiftUI
import UIKit

@MainActor
final class PhotoLibraryAuthorizationViewModel: ObservableObject {
    @Published private(set) var status: PHAuthorizationStatus = .notDetermined

    var canReadAssets: Bool {
        status == .authorized || status == .limited
    }

    func refresh() {
        status = PhotoAssetService.shared.authorizationStatus()
    }

    func requestAccess() async {
        status = await PhotoAssetService.shared.requestAuthorization()
    }
}

struct PhotoRefListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \PhotoRef.createdAt, order: .reverse) private var photoRefs: [PhotoRef]

    @StateObject private var authorizationViewModel = PhotoLibraryAuthorizationViewModel()
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var isPresentingErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Group {
                if authorizationViewModel.canReadAssets {
                    photoRefList
                } else {
                    permissionGuide
                }
            }
            .navigationTitle("Photo Refs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if authorizationViewModel.canReadAssets {
                        PhotosPicker(selection: $selectedPickerItem, matching: .images, photoLibrary: .shared()) {
                            Label("Add", systemImage: "plus")
                        }
                    } else if authorizationViewModel.status == .notDetermined {
                        Button("許可") {
                            Task {
                                await authorizationViewModel.requestAccess()
                            }
                        }
                    }
                }
            }
            .onAppear {
                authorizationViewModel.refresh()
            }
            .onChange(of: selectedPickerItem) { _, newItem in
                guard let newItem else {
                    return
                }
                insertPhotoRef(from: newItem)
            }
            .alert("追加できません", isPresented: $isPresentingErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var photoRefList: some View {
        List {
            if photoRefs.isEmpty {
                Text("右上の＋ボタンから写真参照を追加してください。")
                    .foregroundStyle(.secondary)
            }

            ForEach(photoRefs) { photoRef in
                NavigationLink {
                    PhotoRefDetailView(photoRef: photoRef)
                } label: {
                    PhotoRefRowView(photoRef: photoRef)
                }
            }
            .onDelete(perform: deletePhotoRefs)
        }
    }

    private var permissionGuide: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            switch authorizationViewModel.status {
            case .notDetermined:
                Text("写真ライブラリへのアクセス許可が必要です。")
                    .multilineTextAlignment(.center)
                Button("アクセスを許可") {
                    Task {
                        await authorizationViewModel.requestAccess()
                    }
                }
                .buttonStyle(.borderedProminent)
            case .limited:
                Text("選択済みの写真にアクセスできます。必要に応じて対象写真を追加してください。")
                    .multilineTextAlignment(.center)
            case .denied, .restricted:
                Text("写真ライブラリへのアクセスが許可されていません。設定アプリから変更してください。")
                    .multilineTextAlignment(.center)
                Button("設定を開く") {
                    openSettings()
                }
                .buttonStyle(.bordered)
            case .authorized:
                Text("アクセス可能です。")
                    .multilineTextAlignment(.center)
            @unknown default:
                Text("写真ライブラリの状態を確認できません。")
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    private func insertPhotoRef(from pickerItem: PhotosPickerItem) {
        defer {
            selectedPickerItem = nil
        }

        guard let localIdentifier = pickerItem.itemIdentifier else {
            presentError(message: "選択した写真の識別子を取得できませんでした。")
            return
        }

        guard !hasExistingPhotoRef(localIdentifier: localIdentifier) else {
            presentError(message: "同じ写真はすでに追加されています。")
            return
        }

        let photoRef = PhotoRef(
            assetLocalIdentifier: localIdentifier,
            createdAt: .now,
            memo: ""
        )
        modelContext.insert(photoRef)

        do {
            try modelContext.save()
        } catch {
            presentError(message: "保存に失敗しました: \(error.localizedDescription)")
        }
    }

    private func hasExistingPhotoRef(localIdentifier: String) -> Bool {
        let predicate = #Predicate<PhotoRef> {
            $0.assetLocalIdentifier == localIdentifier
        }
        var descriptor = FetchDescriptor<PhotoRef>(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            let existingPhotoRefs = try modelContext.fetch(descriptor)
            return !existingPhotoRefs.isEmpty
        } catch {
            return false
        }
    }

    private func deletePhotoRefs(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(photoRefs[index])
        }
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL)
    }

    private func presentError(message: String) {
        errorMessage = message
        isPresentingErrorAlert = true
    }
}

#Preview {
    PhotoRefListView()
        .modelContainer(for: PhotoRef.self, inMemory: true)
}
