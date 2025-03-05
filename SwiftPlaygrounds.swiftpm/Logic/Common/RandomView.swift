import SwiftUI

struct RandomView: View {
    @State private var randomLength = ""
    @State private var random0 = ""
    @State private var random1 = ""
    @State private var random2 = ""
    @State private var random3 = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Text(randomLength)
                .font(.headline)
            Text(random0)
            Text(random1)
            Text(random2)
            Text(random3)
            Button("Generate") {
                let length = Int.random(in: 10...20)
                randomLength = length.description
                random0 = generateRandomString(length: length, options: .lowercase, .uppercase, .numbers, .custom(.init("+-=.")))
                random1 = generateRandomString(length: length, options: .lowercase, .uppercase, .numbers)
                random2 = generateRandomString(length: length, options: .lowercase, .uppercase)
                random3 = generateRandomString(length: length, options: .lowercase)
            }
        }
        .frame(maxWidth: .infinity)
//        .padding()
    }
    
    func generateRandomString(length: Int, options: CharacterSetOption...) -> String{
        let characters = options.reduce("") {
            $0 + $1.characters
        }
        return (0..<length).reduce("") { current, _ in
            current + characters.randomElement()!.description
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
