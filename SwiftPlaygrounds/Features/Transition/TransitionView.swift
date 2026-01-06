import SwiftUI

struct TransitionView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isNavigationPresented = false
    @State private var isSheetPresented = false
    @State private var isPopoverPresented = false
    @State private var isFullScreenCoverPresented = false
    @State private var isFullScreenCoverWithOpacityPresented = false
    @State private var isFullScreenCoverWithUIKitPresented = false

    var body: some View {
        VStack(spacing: 40) {
            Button("Navigation") {
                isNavigationPresented = true
            }
            Button("Sheet") {
                isSheetPresented = true
            }
            Button("Popover") {
                isPopoverPresented = true
            }
            Button("FullScreenCover") {
                isFullScreenCoverPresented = true
            }
            Button("FullScreenCoverWithOpacity") {
                isFullScreenCoverWithOpacityPresented = true
            }
            Button("FullScreenCoverWithUIKit") {
                isFullScreenCoverWithUIKitPresented = true
            }
            Button("Dismiss") {
                dismiss()
            }
        }
        .navigationDestination(isPresented: $isNavigationPresented) {
            TransitionView()
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                TransitionView()
            }
        }
        .popover(isPresented: $isPopoverPresented) {
            NavigationStack {
                TransitionView()
            }
        }
        .fullScreenCover(isPresented: $isFullScreenCoverPresented) {
            NavigationStack {
                TransitionView()
            }
        }
        .fullScreenCover(isPresented: $isFullScreenCoverWithOpacityPresented) {
            NavigationStack {
                TransitionView()
            }
            .presentationBackground(.opacity(0.5))
        }
        .fullScreenCover(isPresented: $isFullScreenCoverWithUIKitPresented) {
            TransitionView()
                .presentationColorBackground(.black.opacity(0.5))
        }
    }
}

#Preview {
    NavigationStack {
        TransitionView()
    }
}
