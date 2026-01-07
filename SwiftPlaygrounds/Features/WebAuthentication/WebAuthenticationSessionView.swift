import SwiftUI
import AuthenticationServices

struct WebAuthenticationSessionView: View {
    private let defaultURLString = "http://127.0.0.1:8080/auth"
    private let defaultCallbackScheme = DeepLink.scheme

    @EnvironmentObject private var deepLinkNavigator: DeepLinkNavigator
    @State private var urlString = "http://127.0.0.1:8080/auth"
    @State private var callbackScheme = DeepLink.scheme
    @State private var prefersEphemeral = false
    @State private var forwardCallbackToDeepLink = false
    @State private var statusMessage = "Not started"
    @State private var webAuthSession: ASWebAuthenticationSession?
    @State private var presentationContextProvider = PresentationContextProvider()

    var body: some View {
        Form {
            Section("概要") {
                Text("ASWebAuthenticationSession の一般的な使い方を試す画面です。認証URLはコールバックURLへリダイレクトする必要があります。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("設定") {
                TextField("認証URL", text: $urlString, prompt: Text(defaultURLString))
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                TextField("Callback Scheme", text: $callbackScheme, prompt: Text(defaultCallbackScheme))
                    .textInputAutocapitalization(.never)
                Toggle("Ephemeral Session", isOn: $prefersEphemeral)
                Toggle("Forward callback to deep link", isOn: $forwardCallbackToDeepLink)
            }

            Section("一般的なパターン") {
                Button("Standard (custom scheme, persistent)") {
                    prefersEphemeral = false
                    if callbackScheme.isEmpty {
                        callbackScheme = defaultCallbackScheme
                    }
                    startWebAuthSession()
                }
                Button("Ephemeral (no cookie)") {
                    prefersEphemeral = true
                    if callbackScheme.isEmpty {
                        callbackScheme = defaultCallbackScheme
                    }
                    startWebAuthSession()
                }
                Button("No callback (manual)") {
                    callbackScheme = ""
                    prefersEphemeral = false
                    startWebAuthSession()
                }
                Text("No callback は検証用のみにしてください。通常はコールバックスキームを指定します。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("起動") {
                Button("Start Session", systemImage: "lock.shield") {
                    startWebAuthSession()
                }
                .buttonStyle(.borderedProminent)
            }

            Section("結果") {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Web Auth Session")
    }
}

#if os(iOS)
private final class PresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow ?? ASPresentationAnchor()
    }
}
#endif

private extension WebAuthenticationSessionView {
    func startWebAuthSession() {
        guard let url = URL(string: urlString) else {
            statusMessage = "Invalid URL"
            return
        }

        let scheme = callbackScheme.isEmpty ? nil : callbackScheme
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
            if let callbackURL {
                statusMessage = "Callback: \(callbackURL.absoluteString)"
                if forwardCallbackToDeepLink {
                    DispatchQueue.main.async {
                        _ = deepLinkNavigator.handle(url: callbackURL)
                    }
                }
                return
            }
            if let error {
                statusMessage = "Error: \(error.localizedDescription)"
                return
            }
            statusMessage = "Cancelled"
        }
        session.prefersEphemeralWebBrowserSession = prefersEphemeral
        session.presentationContextProvider = presentationContextProvider
        session.start()
        webAuthSession = session
        statusMessage = "Started"
    }
}

#Preview {
    NavigationStack {
        WebAuthenticationSessionView()
    }
}
