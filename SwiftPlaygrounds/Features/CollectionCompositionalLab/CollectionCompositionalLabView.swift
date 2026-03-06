import SwiftUI

struct CollectionCompositionalLabView: View {
    @State private var selection: CollectionCompositionalLabSection = .collection

    var body: some View {
        selectedView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Picker("Section", selection: $selection) {
                        ForEach(CollectionCompositionalLabSection.allCases) { section in
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
            .navigationTitle("Collection / Compositional Lab")
    }

    @ViewBuilder
    private var selectedView: some View {
        switch selection {
        case .collection:
            CollectionView()
        case .compositional:
            CompositionalView()
        }
    }
}

private enum CollectionCompositionalLabSection: String, CaseIterable, Identifiable {
    case collection
    case compositional

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .collection:
            return "Collection"
        case .compositional:
            return "Compositional"
        }
    }

    var description: String {
        switch self {
        case .collection:
            return "Keep the flow-layout and nested collection samples together under one route."
        case .compositional:
            return "Open the diffable-data-source compositional layout sample from the same lab."
        }
    }
}

#Preview {
    NavigationStack {
        CollectionCompositionalLabView()
    }
}
