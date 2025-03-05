import SwiftUI

struct RandomView: View {
    @State private var randomLength: String?
    @State private var random0: String?
    @State private var random1: String?
    @State private var random2: String?
    @State private var random3: String?
    @State private var random4: String?
    @State private var random5: String?
    
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
            Button("Generate") {
                let length = Int.random(in: 10...20)
                randomLength = length.description
                random0 = try? generateRandomString(length: length, options: .lowercase, .uppercase, .numbers, .custom(.init("+-=.")))
                random1 = try? generateRandomString(length: length, options: .lowercase, .uppercase, .numbers)
                random2 = try? generateRandomString(length: length, options: .lowercase, .uppercase)
                random3 = try? generateRandomString(length: length, options: .lowercase)
                do {
                    random4 = try generateRandomString(length: length)
                } catch {
                    random4 = error.localizedDescription
                }
                do {
                    random5 = try generateRandomString(length: 0, options: .lowercase, .uppercase, .numbers)
                } catch {
                    random5 = error.localizedDescription
                }
            }
        }
    }
    
    func generateRandomString(length: Int, options: CharacterSetOption...) throws -> String {
        guard length > .zero else {
            throw PlaygroundsError(with: "length is \(length)")
        }
        let characters = options.reduce(Set<Character>()) {
            $0.union($1.characters)
        }
        return try (0..<length).reduce("") { current, _ in
            guard let character = characters.randomElement() else {
                throw PlaygroundsError(with: "options is empty")
            }
            return current + character.description
        }
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
