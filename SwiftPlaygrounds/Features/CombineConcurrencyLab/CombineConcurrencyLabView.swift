import SwiftUI

struct CombineConcurrencyLabView: View {
    @State private var selection: CombineConcurrencyLabSection = .combine

    var body: some View {
        selectedView
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Picker("Section", selection: $selection) {
                        ForEach(CombineConcurrencyLabSection.allCases) { section in
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
            .navigationTitle("Combine / Concurrency Lab")
    }

    @ViewBuilder
    private var selectedView: some View {
        switch selection {
        case .combine:
            ScrollView {
                CombineView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        case .actor:
            ActorView()
        case .asyncStream:
            AsyncStreamView()
        }
    }
}

private enum CombineConcurrencyLabSection: String, CaseIterable, Identifiable {
    case combine
    case actor
    case asyncStream

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .combine:
            return "Combine"
        case .actor:
            return "Actor"
        case .asyncStream:
            return "AsyncStream"
        }
    }

    var description: String {
        switch self {
        case .combine:
            return "Inspect Combine operators and the existing detail sheet from one route."
        case .actor:
            return "Compare shared mutable state against actor isolation with the existing tap demo."
        case .asyncStream:
            return "Exercise the simple AsyncStream counter without keeping a dedicated route."
        }
    }
}

#Preview {
    NavigationStack {
        CombineConcurrencyLabView()
    }
}
