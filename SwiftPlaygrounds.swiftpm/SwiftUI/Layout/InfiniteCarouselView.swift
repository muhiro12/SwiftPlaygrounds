import SwiftUI

struct InfiniteCarouselView: View {
    @State private var imageURLs = [URL]()
    @State private var isLoading = false
    
    var body: some View {
        TabView {
            ForEach(imageURLs, id: \.self) { imageURL in
                AsyncImage(url: imageURL)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: 300, height: 100)
        .progress(isLoading: $isLoading)
        .task {
            isLoading = true
            try! await Task.sleep(for: .seconds(2))
            imageURLs = [
                .init(string: "https://via.placeholder.com/300x100/FF0000/FFFFFF?text=1")!,
                .init(string: "https://via.placeholder.com/300x100/00FF00/FFFFFF?text=2")!,
                .init(string: "https://via.placeholder.com/300x100/0000FF/FFFFFF?text=3")!,
                .init(string: "https://via.placeholder.com/300x100/FFFF00/FFFFFF?text=4")!,
                .init(string: "https://via.placeholder.com/300x100/FF00FF/FFFFFF?text=5")!
            ]
            isLoading = false
        }
    }
}

#Preview {
    InfiniteCarouselView()
}
