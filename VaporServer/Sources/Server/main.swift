import Vapor

private enum FlashCacheMode: String {
    case maxAge = "maxage"
    case noStore = "nostore"
}

private func cacheControlValue(from rawValue: String?) -> String {
    switch FlashCacheMode(rawValue: rawValue ?? "") {
    case .noStore:
        return "no-store"
    default:
        return "public, max-age=3600"
    }
}

private func applyCacheControl(_ headers: inout HTTPHeaders, rawValue: String?) {
    headers.replaceOrAdd(name: .cacheControl, value: cacheControlValue(from: rawValue))
}

private func clampDelay(_ delayMs: Int?) -> Int {
    guard let delayMs else { return 0 }
    return max(0, min(delayMs, 3000))
}

func routes(_ app: Application) throws {
    let publicDirectory = app.directory.publicDirectory

    app.get { _ -> Response in
        let html = """
        <html><body>
        <h2>Playgrounds Deep Link Demo</h2>
        <ul>
          <li><a href="/auth">ASWebAuthenticationSession demo</a></li>
          <li><a href="/flash-test">WKWebView flash test</a></li>
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

    app.get("flash-test") { req -> Response in
        let cacheMode = req.query[String.self, at: "cache"]
        let oldDelayMs = clampDelay(req.query[Int.self, at: "oldDelayMs"])
        let domDelayMs = clampDelay(req.query[Int.self, at: "domDelayMs"])
        let delayQuery = oldDelayMs > 0 ? "&delayMs=\(oldDelayMs)" : ""
        let cacheQuery = "cache=\(cacheMode ?? FlashCacheMode.maxAge.rawValue)"
        let oldImageURL = "/assets/old.jpg?\(cacheQuery)\(delayQuery)"
        let usesDomDelay = domDelayMs > 0

        let imageMarkup: String
        if usesDomDelay {
            imageMarkup = """
            <div id="imageHost" class="image-host"></div>
            """
        } else {
            imageMarkup = """
            <img id="target" src="\(oldImageURL)" width="280" height="180" />
            """
        }

        let html = """
        <!doctype html>
        <html lang="en">
        <head>
          <meta charset="utf-8" />
          <meta name="viewport" content="width=device-width,initial-scale=1" />
          <title>WKWebView Flash Test</title>
          <style>
            body { font-family: -apple-system, system-ui, sans-serif; padding: 20px; }
            .stage { display: grid; gap: 12px; }
            .image-host, #target { border: 2px solid #333; background: #f2f2f2; width: 280px; height: 180px; }
            code { background: #f5f5f5; padding: 2px 4px; }
          </style>
        </head>
        <body>
          <h3>WKWebView Flash Test</h3>
          <div class="stage">
            <div>cache=<code>\(cacheMode ?? FlashCacheMode.maxAge.rawValue)</code>, oldDelayMs=<code>\(oldDelayMs)</code>, domDelayMs=<code>\(domDelayMs)</code></div>
            \(imageMarkup)
          </div>
          <script>
            const t0 = performance.now();
            const log = (msg, extra) => {
              const t = (performance.now() - t0).toFixed(1);
              if (extra !== undefined) {
                console.log(`[flash-test +${t}ms] ${msg}`, extra);
              } else {
                console.log(`[flash-test +${t}ms] ${msg}`);
              }
            };

            log('script start');

            if (\(usesDomDelay ? "true" : "false")) {
              log('domDelay armed', { domDelayMs: \(domDelayMs) });
              setTimeout(() => {
                const img = document.createElement('img');
                img.id = 'target';
                img.width = 280;
                img.height = 180;
                img.src = '\(oldImageURL)';
                document.getElementById('imageHost').appendChild(img);
                log('img inserted after domDelay', { src: img.src });
                attachImageObservers(img);
              }, \(domDelayMs));
            }

            function attachImageObservers(target) {
              target.addEventListener('load', () => log('img load', { src: target.currentSrc || target.src }));
              target.addEventListener('error', () => log('img error', { src: target.currentSrc || target.src }));
              const observer = new MutationObserver((mutations) => {
                mutations.forEach((mutation) => {
                  if (mutation.attributeName === 'src') {
                    log('img src changed', { src: target.getAttribute('src') });
                  }
                });
              });
              observer.observe(target, { attributes: true });
            }

            if (!\(usesDomDelay ? "true" : "false")) {
              const target = document.getElementById('target');
              if (target) {
                attachImageObservers(target);
              }
            }

            document.addEventListener('DOMContentLoaded', () => log('DOMContentLoaded'));
            window.addEventListener('load', () => log('window load'));
            requestAnimationFrame(() => {
              log('raf #1');
              requestAnimationFrame(() => log('raf #2'));
            });
          </script>
        </body>
        </html>
        """

        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "text/html; charset=utf-8")
        applyCacheControl(&headers, rawValue: cacheMode)
        return Response(status: .ok, headers: headers, body: .init(string: html))
    }

    app.get("assets", "old.jpg") { req async throws -> Response in
        let delayMs = clampDelay(req.query[Int.self, at: "delayMs"])
        let path = publicDirectory + "assets/old.jpg"
        if delayMs > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
        }

        let response = try await req.fileio.asyncStreamFile(at: path)
        var headers = response.headers
        headers.replaceOrAdd(name: HTTPHeaders.Name.contentType, value: "image/jpeg")
        applyCacheControl(&headers, rawValue: req.query[String.self, at: "cache"])
        let updated = response
        updated.headers = headers
        return updated
    }

    app.get("assets", "new.jpg") { req async throws -> Response in
        let path = publicDirectory + "assets/new.jpg"
        let response = try await req.fileio.asyncStreamFile(at: path)
        var headers = response.headers
        headers.replaceOrAdd(name: HTTPHeaders.Name.contentType, value: "image/jpeg")
        applyCacheControl(&headers, rawValue: req.query[String.self, at: "cache"])
        let updated = response
        updated.headers = headers
        return updated
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
