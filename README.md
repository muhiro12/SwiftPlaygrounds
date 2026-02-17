# SwiftPlaygrounds

## WKWebView Flash Test (iOS + Vapor)

### Start Vapor
- `cd VaporServer`
- `swift run`
- Default host: `http://127.0.0.1:8080`

### Start iOS app
- Open `SwiftPlaygrounds.xcodeproj` in Xcode
- Run the app and select `flashTest` from the list
- Compare conditions using the controls at the bottom
  - Navigation Trigger: `didFinish` / `didCommit` / `DOMContentLoaded`
  - Cache Mode: `max-age` / `no-store`
  - Old Image Delay: old image response delay (0–300ms)
  - DOM Insert Delay: delayed image DOM insert (optional)
  - Hide Mode: `visibility` / `display`

### Added URL
- `http://127.0.0.1:8080/flash-test`
- Query toggles:
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
