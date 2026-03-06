import SwiftUI

struct InfiniteScrollingLabView: View {
    @State private var selection: InfiniteScrollingLabSection = .carousel

    var body: some View {
        selectedView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Picker("Section", selection: $selection) {
                        ForEach(InfiniteScrollingLabSection.allCases) { section in
                            Text(section.title)
                                .tag(section)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(selection.description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.bar)
            }
            .navigationTitle("Infinite Scrolling Lab")
    }

    @ViewBuilder
    private var selectedView: some View {
        switch selection {
        case .carousel:
            InfiniteCarouselView()
        case .compositional:
            InfiniteCompositionalView()
        case .paging:
            InfinitePagingView()
        }
    }
}

private enum InfiniteScrollingLabSection: String, CaseIterable, Identifiable {
    case carousel
    case compositional
    case paging

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .carousel:
            return "Carousel"
        case .compositional:
            return "Compositional"
        case .paging:
            return "Paging"
        }
    }

    var description: String {
        switch self {
        case .carousel:
            return "Keep the SwiftUI carousel demo with the infinite paging experiments in one place."
        case .compositional:
            return "View the infinite compositional layout sample without a dedicated route."
        case .paging:
            return "View the page-view-controller based infinite paging sample from the same lab."
        }
    }
}

#Preview {
    NavigationStack {
        InfiniteScrollingLabView()
    }
}
