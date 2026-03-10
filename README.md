# SwiftPlaygrounds

An iOS sandbox app with multiple UIKit and SwiftUI experiments, backed by a local Vapor server for web and deep-link testing.

## WKWebView Flash Test (iOS + Vapor)

### Start Vapor
- `cd VaporServer`
- `swift run`
- Default host: `http://127.0.0.1:8080`

### Start iOS app
- Open `SwiftPlaygrounds.xcodeproj` in Xcode
- Run the app and select `Flash Test` from the list
- Select `Web Integration` to compare deep-link handling in `WKWebView`, Safari, and `ASWebAuthenticationSession`
- In `Flash Test`, compare conditions using the controls at the bottom
  - Navigation Trigger: `didFinish` / `didCommit` / `DOMContentLoaded`
  - Cache Mode: `max-age` / `no-store`
  - Old Image Delay: old image response delay (0–300ms)
  - DOM Insert Delay: delayed image DOM insert (optional)
  - Hide Mode: `visibility` / `display`

### Local URLs
- `http://127.0.0.1:8080/` lists the flash test, auth demo, and sample deep links
- `http://127.0.0.1:8080/flash-test`
- `http://127.0.0.1:8080/auth` is the default `Auth URL` for `Web Integration`
- `Flash Test` query toggles:
  - `cache=nostore` or `cache=maxage`
  - `oldDelayMs=150` (old image response delay)
  - `domDelayMs=150` (image DOM insert delay)

### URL notes (device vs simulator)
- Simulator: `http://127.0.0.1:8080` is OK
- Device: replace with your Mac IP (e.g. `http://192.168.0.10:8080`)

### What to observe
- `didFinish` tends to show the old image flash more often
- Compare with `didCommit` (often improves, but may still flash)
- Toggle `cache` and `oldDelayMs` to see how reproducibility changes
- Xcode logs include:
  - iOS: didCommit/didFinish timestamps, evaluateJavaScript call/completion timestamps
  - Web: script start / DOMContentLoaded / load / img load/error / src change / raf #1/#2

### Safari Web Inspector
- `WKWebView.isInspectable = true` is enabled for iOS 16.4+
- Use Safari > Develop to inspect the device and console logs
