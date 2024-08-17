import SwiftUI

private struct ColorBackgroundView: UIViewRepresentable {
    let color: Color
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        Task { @MainActor in
            view.superview?.superview?.backgroundColor = .init(color)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension View {
    func presentationColorBackground(_ color: Color) -> some View {
        background(ColorBackgroundView(color: color))
    }
}
