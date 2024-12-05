import SwiftUI
import SwiftUtilities

struct InfiniteCarouselView: View {
    @State private var objects = [(index: Int, color: Color)]()
    @State private var selection = 0
    @State private var isLoading = false
    @State private var autoScrollTask: Task<Void, Never>?

    private let colors: [Color] = [
        .random(),
        .random(),
        .random(),
        .random(),
        .random()
    ]

    var body: some View {
        VStack {
            GeometryReader { parentGeometry in
                TabView(selection: $selection) {
                    ForEach(objects.startIndex - 1..<objects.endIndex + 1, id: \.self) { index in
                        ZStack {
                            if let object = {
                                switch index {
                                case ..<objects.startIndex:
                                    objects.last
                                case objects.startIndex..<objects.endIndex: 
                                    objects[index]
                                default:
                                    objects.first
                                }
                            }() {
                                object.color
                                Text(object.index.description)
                            }
                        }
                        .overlay {
                            if index == selection {
                                GeometryReader { childGeometry in
                                    EmptyView()
                                        .onChange(of: childGeometry.frame(in: .global)) {
                                            onPagingStarted()
                                            let childFrame = childGeometry.frame(in: .global)
                                            let parentFrame = parentGeometry.frame(in: .global)
                                            guard childFrame.midX - parentFrame.midX == .zero else {
                                                return
                                            }
                                            onPagingCompleted()
                                        }
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .frame(width: 300, height: 100)
            HStack {
                ForEach(objects, id: \.index) { object in
                    Circle()
                        .frame(width: 8)
                        .foregroundStyle(object.index == selection ? .primary : .secondary)
                }
            }
        }
        .progress(isLoading: $isLoading)
        .task {
            isLoading = true
            objects = colors.enumerated().map {
                ($0.offset, $0.element)
            }
            isLoading = false
        }
    }

    private func onPagingStarted() {
        autoScrollTask?.cancel()
    }

    private func onPagingCompleted() {
        autoScrollTask = Task {
            do {
                try await Task.sleep(for: .seconds(5))
                withAnimation {
                    selection += 1
                }
            } catch {}
        }

        switch selection {
        case ..<objects.startIndex:
            selection = objects.endIndex - 1
        case objects.startIndex..<objects.endIndex:
            break
        default:
            selection = objects.startIndex
        }
    }
}

#Preview {
    InfiniteCarouselView()
}
