import SwiftUI
import SwiftUtilities

struct InfiniteCarouselView: View {
    @State private var objects = [(index: Int, color: Color)]()
    @State private var selection = 0
    @State private var isLoading = false

    private let colors: [Color] = [
        .random(),
        .random(),
        .random(),
        .random(),
        .random()
    ]

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(-1..<objects.endIndex + 1, id: \.self) { index in
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
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
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
            try! await Task.sleep(for: .seconds(2))
            objects = colors.enumerated().map {
                ($0.offset, $0.element)
            }
            isLoading = false
        }
        .onChange(of: selection) {
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
}

#Preview {
    InfiniteCarouselView()
}
