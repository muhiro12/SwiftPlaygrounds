import SwiftUI
import SwiftUtilities

struct RandomView: View {
    @State private var randomLength: String?
    @State private var random0: String?
    @State private var random1: String?
    @State private var random2: String?
    @State private var random3: String?
    @State private var random4: String?
    @State private var random5: String?
    @State private var random6: String?
    @State private var random7: String?

    var body: some View {
        VStack(spacing: 32) {
            Text(randomLength ?? "nil")
                .font(.title)
                .fontDesign(.monospaced)
            Text(random0 ?? "nil")
                .fontDesign(.monospaced)
            Text(random1 ?? "nil")
                .fontDesign(.monospaced)
            Text(random2 ?? "nil")
                .fontDesign(.monospaced)
            Text(random3 ?? "nil")
                .fontDesign(.monospaced)
            Text(random4 ?? "nil")
                .fontDesign(.monospaced)
            Text(random5 ?? "nil")
                .fontDesign(.monospaced)
            Text(random6 ?? "nil")
                .fontDesign(.monospaced)
            Text(random7 ?? "nil")
                .fontDesign(.monospaced)
            Button("Generate") {
                let length = Int.random(in: 10...20)
                randomLength = length.description
                random0 = try? generateRandomString(length: length, options: [.lowercase, .uppercase, .numbers, .custom(.init("+-=."))])
                random1 = try? generateRandomString(length: length, options: [.lowercase, .uppercase, .numbers])
                random2 = try? generateRandomString(length: length, options: [.lowercase, .uppercase])
                random3 = try? generateRandomString(length: length, options: [.lowercase])
                random4 = generateRandomString(length: length, options: [])
                random5 = generateRandomString(length: 0, options: [.lowercase, .uppercase, .numbers])
                random6 = generateRandomString(range: 1..<2, options: [.lowercase, .uppercase, .numbers])
                random7 = generateRandomString(range: 1...2, options: [.lowercase, .uppercase, .numbers])
            }
        }
    }

    func generateRandomString(range: Range<Int>, options: [CharacterSetOption]) -> String? {
        generateRandomString(length: .random(in: range), options: options)
    }

    func generateRandomString(range: ClosedRange<Int>, options: [CharacterSetOption]) -> String? {
        generateRandomString(length: .random(in: range), options: options)
    }

    func generateRandomString(length: Int, options: [CharacterSetOption]) -> String? {
        guard options.isNotEmpty else {
            return nil
        }
        let characters = options.reduce(Set<Character>()) {
            $0.union($1.characters)
        }
        return String(
            (0..<length).compactMap { _ in
                characters.randomElement()
            }
        )
    }

    enum CharacterSetOption {
        case lowercase
        case uppercase
        case numbers
        case custom(Set<Character>)

        var characters: Set<Character> {
            switch self {
            case .lowercase:
                .init("abcdefghijklmnopqrstuvwxy")
            case .uppercase:
                .init("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            case .numbers:
                .init("0123456789")
            case .custom(let characters):
                characters
            }
        }
    }
}

#Preview {
    RandomView()
}
