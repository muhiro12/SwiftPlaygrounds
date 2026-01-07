import Vapor

func routes(_ app: Application) throws {
    app.get { _ -> Response in
        let html = """
        <html><body>
        <h2>Playgrounds Deep Link Demo</h2>
        <ul>
          <li><a href="/auth">ASWebAuthenticationSession demo</a></li>
          <li><a href="playgrounds://route/keychain-biometry-debug">playgrounds://route/keychain-biometry-debug</a></li>
          <li><a href="playgrounds://keychainBiometryDebug">playgrounds://keychainBiometryDebug</a></li>
          <li><a href="playgrounds://route/hybrid-text-field">playgrounds://route/hybrid-text-field</a></li>
          <li><a href="playgrounds://webView">playgrounds://webView</a></li>
          <li><a href="playgrounds://alert">playgrounds://alert (show alert)</a></li>
          <li><a href="maps://?q=Tokyo+Station">maps://?q=Tokyo+Station</a></li>
        </ul>
        </body></html>
        """
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html; charset=utf-8")
        return Response(status: .ok, headers: headers, body: .init(string: html))
    }

    app.get("auth") { _ -> Response in
        let html = """
        <html><body>
        <h2>ASWebAuthenticationSession Demo</h2>
        <ul>
          <li><a href="/auth/redirect/basic">Server redirect (no path)</a></li>
          <li><a href="/auth/redirect/route">Server redirect (deep link route)</a></li>
          <li><a href="playgrounds://?code=demo">Direct link (no path)</a></li>
          <li><a href="playgrounds://route/webView?code=demo">Direct link (deep link route)</a></li>
        </ul>
        </body></html>
        """
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html; charset=utf-8")
        return Response(status: .ok, headers: headers, body: .init(string: html))
    }

    app.get("auth", "redirect", "basic") { _ -> Response in
        var headers = HTTPHeaders()
        headers.add(name: .location, value: "playgrounds://?code=demo")
        return Response(status: .found, headers: headers)
    }

    app.get("auth", "redirect", "route") { _ -> Response in
        var headers = HTTPHeaders()
        headers.add(name: .location, value: "playgrounds://route/webView?code=demo")
        return Response(status: .found, headers: headers)
    }
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = try await Application.make(env)
defer { Task { try? await app.asyncShutdown() } }

app.http.server.configuration.port = Environment.get("PORT").flatMap(Int.init) ?? 8080
app.http.server.configuration.hostname = Environment.get("HOST") ?? "127.0.0.1"

try routes(app)
try await app.execute()
