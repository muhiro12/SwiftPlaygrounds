import SwiftUI
import Combine

struct StateComparisonView: View {
    @State private var mode: StateComparisonMode = .observable
    @State private var localStore = LocalStateComparisonStore()
    @State private var observableStore = ObservableStateComparisonStore()
    @StateObject private var observableObjectStore = ObservableObjectStateComparisonStore()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Mode", selection: $mode) {
                ForEach(StateComparisonMode.allCases) { mode in
                    Text(mode.title)
                        .tag(mode)
                }
            }
            .pickerStyle(.segmented)

            switch mode {
            case .localState:
                StateComparisonContent(
                    mode: mode,
                    users: localStore.users,
                    currentUserID: localStore.currentUserID,
                    selectedUserID: Binding(
                        get: { localStore.selectedUserID },
                        set: { localStore.selectedUserID = $0 }
                    ),
                    onShowCurrentUser: {
                        localStore.showCurrentUser()
                    },
                    onReset: {
                        localStore.reset()
                    },
                    onLike: { userID in
                        localStore.like(userID: userID)
                    },
                    onDislike: { userID in
                        localStore.dislike(userID: userID)
                    }
                )
            case .observable:
                StateComparisonContent(
                    mode: mode,
                    users: observableStore.users,
                    currentUserID: observableStore.currentUserID,
                    selectedUserID: Binding(
                        get: { observableStore.selectedUserID },
                        set: { observableStore.selectedUserID = $0 }
                    ),
                    onShowCurrentUser: {
                        observableStore.showCurrentUser()
                    },
                    onReset: {
                        observableStore.reset()
                    },
                    onLike: { userID in
                        observableStore.like(userID: userID)
                    },
                    onDislike: { userID in
                        observableStore.dislike(userID: userID)
                    }
                )
            case .observableObject:
                StateComparisonContent(
                    mode: mode,
                    users: observableObjectStore.users,
                    currentUserID: observableObjectStore.currentUserID,
                    selectedUserID: Binding(
                        get: { observableObjectStore.selectedUserID },
                        set: { observableObjectStore.selectedUserID = $0 }
                    ),
                    onShowCurrentUser: {
                        observableObjectStore.showCurrentUser()
                    },
                    onReset: {
                        observableObjectStore.reset()
                    },
                    onLike: { userID in
                        observableObjectStore.like(userID: userID)
                    },
                    onDislike: { userID in
                        observableObjectStore.dislike(userID: userID)
                    }
                )
            }
        }
        .padding()
        .navigationTitle("State Comparison")
    }
}

private struct StateComparisonContent: View {
    let mode: StateComparisonMode
    let users: [StateComparisonUser]
    let currentUserID: StateComparisonUser.ID?
    @Binding var selectedUserID: StateComparisonUser.ID?
    let onShowCurrentUser: () -> Void
    let onReset: () -> Void
    let onLike: (StateComparisonUser.ID) -> Void
    let onDislike: (StateComparisonUser.ID) -> Void

    private var selectedUser: StateComparisonUser? {
        users.first { $0.id == selectedUserID }
    }

    private var isDetailPresented: Binding<Bool> {
        Binding(
            get: { selectedUser != nil },
            set: { isPresented in
                if !isPresented {
                    selectedUserID = nil
                }
            }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(mode.summary)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Button("Show Current User") {
                        onShowCurrentUser()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset Fixture") {
                        onReset()
                    }
                    .buttonStyle(.bordered)
                }

                Text("Tap a row to open the detail view and compare updates.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            List(users) { user in
                Button {
                    selectedUserID = user.id
                } label: {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(user.role.color)
                            .frame(width: 10, height: 10)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text(user.name)
                                    .fontWeight(user.id == currentUserID ? .semibold : .regular)
                                if user.id == currentUserID {
                                    Text("Current")
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(.secondary.opacity(0.2), in: Capsule())
                                }
                            }
                            Text(user.role.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("+\(user.likeCount)")
                                .monospacedDigit()
                            Text("-\(user.dislikeCount)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: isDetailPresented) {
            NavigationStack {
                if let selectedUser {
                    StateComparisonDetailView(
                        user: selectedUser,
                        isCurrentUser: selectedUser.id == currentUserID,
                        onLike: {
                            onLike(selectedUser.id)
                        },
                        onDislike: {
                            onDislike(selectedUser.id)
                        }
                    )
                } else {
                    ContentUnavailableView(
                        "No User Selected",
                        systemImage: "person.crop.circle.badge.questionmark",
                        description: Text("Select a user from the list.")
                    )
                }
            }
        }
    }
}

private struct StateComparisonDetailView: View {
    let user: StateComparisonUser
    let isCurrentUser: Bool
    let onLike: () -> Void
    let onDislike: () -> Void

    var body: some View {
        Form {
            Section("Identity") {
                LabeledContent("Name", value: user.name)
                LabeledContent("Role", value: user.role.title)
                LabeledContent("ID", value: user.id)
                LabeledContent("Current User", value: isCurrentUser ? "Yes" : "No")
            }

            Section("Counters") {
                LabeledContent("Likes", value: user.likeCount.description)
                LabeledContent("Dislikes", value: user.dislikeCount.description)
            }

            Section("Actions") {
                Button("Like +1") {
                    onLike()
                }

                Button("Dislike +1") {
                    onDislike()
                }
            }
        }
        .navigationTitle(user.name)
    }
}

private enum StateComparisonMode: String, CaseIterable, Identifiable {
    case localState
    case observable
    case observableObject

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .localState:
            return "Local State"
        case .observable:
            return "@Observable"
        case .observableObject:
            return "ObservableObject"
        }
    }

    var summary: String {
        switch self {
        case .localState:
            return "The list, selection, and counters live directly inside the view as plain value state."
        case .observable:
            return "The view owns an @Observable store and reads its fields directly without Combine publishers."
        case .observableObject:
            return "The view observes an ObservableObject store with @Published fields and reference semantics."
        }
    }
}

private struct LocalStateComparisonStore {
    var users = StateComparisonFixtures.users
    var currentUserID = StateComparisonFixtures.currentUserID
    var selectedUserID: StateComparisonUser.ID?

    mutating func showCurrentUser() {
        selectedUserID = currentUserID
    }

    mutating func reset() {
        self = .init()
    }

    mutating func like(userID: StateComparisonUser.ID) {
        updateUser(userID: userID) { user in
            user.likeCount += 1
        }
    }

    mutating func dislike(userID: StateComparisonUser.ID) {
        updateUser(userID: userID) { user in
            user.dislikeCount += 1
        }
    }

    private mutating func updateUser(
        userID: StateComparisonUser.ID,
        update: (inout StateComparisonUser) -> Void
    ) {
        guard let index = users.firstIndex(where: { $0.id == userID }) else {
            return
        }
        update(&users[index])
    }
}

@Observable
private final class ObservableStateComparisonStore {
    var users = StateComparisonFixtures.users
    var currentUserID = StateComparisonFixtures.currentUserID
    var selectedUserID: StateComparisonUser.ID?

    func showCurrentUser() {
        selectedUserID = currentUserID
    }

    func reset() {
        users = StateComparisonFixtures.users
        currentUserID = StateComparisonFixtures.currentUserID
        selectedUserID = nil
    }

    func like(userID: StateComparisonUser.ID) {
        updateUser(userID: userID) { user in
            user.likeCount += 1
        }
    }

    func dislike(userID: StateComparisonUser.ID) {
        updateUser(userID: userID) { user in
            user.dislikeCount += 1
        }
    }

    private func updateUser(
        userID: StateComparisonUser.ID,
        update: (inout StateComparisonUser) -> Void
    ) {
        guard let index = users.firstIndex(where: { $0.id == userID }) else {
            return
        }
        update(&users[index])
    }
}

private final class ObservableObjectStateComparisonStore: ObservableObject {
    @Published private(set) var users = StateComparisonFixtures.users
    @Published private(set) var currentUserID = StateComparisonFixtures.currentUserID
    @Published var selectedUserID: StateComparisonUser.ID?

    func showCurrentUser() {
        selectedUserID = currentUserID
    }

    func reset() {
        users = StateComparisonFixtures.users
        currentUserID = StateComparisonFixtures.currentUserID
        selectedUserID = nil
    }

    func like(userID: StateComparisonUser.ID) {
        updateUser(userID: userID) { user in
            user.likeCount += 1
        }
    }

    func dislike(userID: StateComparisonUser.ID) {
        updateUser(userID: userID) { user in
            user.dislikeCount += 1
        }
    }

    private func updateUser(
        userID: StateComparisonUser.ID,
        update: (inout StateComparisonUser) -> Void
    ) {
        guard let index = users.firstIndex(where: { $0.id == userID }) else {
            return
        }
        update(&users[index])
    }
}

private struct StateComparisonUser: Identifiable, Equatable {
    let id: String
    let name: String
    let role: StateComparisonRole
    var likeCount: Int
    var dislikeCount: Int
}

private enum StateComparisonRole: String {
    case ios = "iOS"
    case backend = "Backend"
    case design = "Design"
    case qa = "QA"
    case product = "Product"

    var title: String {
        rawValue
    }

    var color: Color {
        switch self {
        case .ios:
            return .blue
        case .backend:
            return .green
        case .design:
            return .orange
        case .qa:
            return .pink
        case .product:
            return .purple
        }
    }
}

private enum StateComparisonFixtures {
    static let currentUserID = "riley"

    static let users: [StateComparisonUser] = [
        .init(id: "riley", name: "Riley", role: .product, likeCount: 48, dislikeCount: 2),
        .init(id: "morgan", name: "Morgan", role: .ios, likeCount: 33, dislikeCount: 4),
        .init(id: "avery", name: "Avery", role: .backend, likeCount: 27, dislikeCount: 1),
        .init(id: "sam", name: "Sam", role: .design, likeCount: 41, dislikeCount: 3),
        .init(id: "jordan", name: "Jordan", role: .qa, likeCount: 22, dislikeCount: 5)
    ]
}

#Preview {
    NavigationStack {
        StateComparisonView()
    }
}
