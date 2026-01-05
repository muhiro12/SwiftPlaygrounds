import Vapor

func routes(_ app: Application) throws {
    app.get { _ -> Response in
        let html = """
        <html><body>
        <h2>Playgrounds Deep Link Demo</h2>
        <ul>
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
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

app.http.server.configuration.port = Environment.get("PORT").flatMap(Int.init) ?? 8080
app.http.server.configuration.hostname = Environment.get("HOST") ?? "127.0.0.1"

try routes(app)
try app.run()
