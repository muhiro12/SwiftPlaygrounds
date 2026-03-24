import SwiftUI
import UIKit

struct TicketSlideLabView: View {
    private let knobDiameter: CGFloat = 60
    private let sliderHeight: CGFloat = 72

    @State private var gesturePattern: GesturePattern = .strictTwoFinger
    @State private var completionRule: CompletionRule = .threshold80
    @State private var progress: CGFloat = .zero
    @State private var travelDistance: CGFloat = 1
    @State private var isCompleted = false
    @State private var activeTouchCount = 0
    @State private var lastVelocityX: CGFloat = .zero
    @State private var lastResult: SlideResult = .idle
    @State private var dragStartProgress: CGFloat = .zero
    @State private var isGestureInvalidated = false
    @State private var hasHorizontalMovement = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                patternSection
                sliderSection
                debugSection
            }
            .padding()
        }
        .navigationTitle("Ticket Slide Lab")
    }

    private var patternSection: some View {
        GroupBox("Pattern Selection") {
            VStack(alignment: .leading, spacing: 12) {
                Picker("Gesture Pattern", selection: $gesturePattern) {
                    ForEach(GesturePattern.allCases) { pattern in
                        Text(pattern.title)
                            .tag(pattern)
                    }
                }
                .pickerStyle(.menu)

                Text(gesturePattern.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Picker("Completion Rule", selection: $completionRule) {
                    ForEach(CompletionRule.allCases) { rule in
                        Text(rule.shortTitle)
                            .tag(rule)
                    }
                }
                .pickerStyle(.segmented)

                Text(completionRule.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var sliderSection: some View {
        GroupBox("Slide Control") {
            VStack(alignment: .leading, spacing: 16) {
                GeometryReader { geometry in
                    let computedTravelDistance = max(geometry.size.width - knobDiameter, 1)

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(sliderTrackColor)

                        HStack {
                            Text(isCompleted ? "Completed" : "Slide to Complete")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)

                        Circle()
                            .fill(sliderKnobColor)
                            .overlay {
                                Image(systemName: isCompleted ? "checkmark" : "chevron.right")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.white)
                            }
                            .frame(width: knobDiameter, height: knobDiameter)
                            .offset(x: progress * computedTravelDistance)
                    }
                    .frame(height: sliderHeight)
                    .overlay {
                        TicketSlidePanCaptureView(
                            gesturePattern: gesturePattern,
                            isEnabled: !isCompleted,
                            onEvent: handlePanEvent
                        )
                    }
                    .onAppear {
                        travelDistance = computedTravelDistance
                    }
                    .onChange(of: geometry.size.width) { _, newWidth in
                        travelDistance = max(newWidth - knobDiameter, 1)
                    }
                }
                .frame(height: sliderHeight)

                HStack {
                    Text("Progress")
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .monospacedDigit()
                }
                .font(.subheadline)

                HStack(spacing: 12) {
                    Button("Reset") {
                        resetLabState()
                    }
                    .buttonStyle(.bordered)
                    .disabled(shouldDisableResetButton)

                    if isCompleted {
                        Label("Operation Completed", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }

    private var debugSection: some View {
        GroupBox("Debug") {
            VStack(alignment: .leading, spacing: 8) {
                debugLine(title: "Touch count", value: "\(activeTouchCount)")
                debugLine(title: "Velocity X", value: String(format: "%.1f", lastVelocityX))
                debugLine(title: "Gesture", value: gesturePattern.title)
                debugLine(title: "Rule", value: completionRule.title)

                Divider()

                Text("Last result")
                    .font(.subheadline.weight(.semibold))
                Text(lastResult.message)
                    .font(.footnote)
                    .foregroundStyle(lastResult.tintColor)
            }
        }
    }

    private var sliderTrackColor: Color {
        if isCompleted {
            return .green.opacity(0.2)
        }

        return .secondary.opacity(0.15)
    }

    private var sliderKnobColor: Color {
        if isCompleted {
            return .green
        }

        return .blue
    }

    private var shouldDisableResetButton: Bool {
        if isCompleted {
            return false
        }

        if progress > .zero {
            return false
        }

        if lastResult != .idle {
            return false
        }

        return true
    }

    @ViewBuilder
    private func debugLine(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.footnote.monospaced())
        }
    }

    private func handlePanEvent(_ event: PanGestureEvent) {
        if isCompleted {
            return
        }

        activeTouchCount = event.touchCount
        lastVelocityX = event.velocity.x

        switch event.phase {
        case .began:
            handleGestureBegan(with: event)
        case .changed:
            handleGestureChanged(with: event)
        case .ended:
            handleGestureEnded(with: event)
        case .cancelled:
            handleGestureCancelled()
        case .failed:
            handleGestureCancelled()
        }
    }

    private func handleGestureBegan(with event: PanGestureEvent) {
        dragStartProgress = progress
        isGestureInvalidated = false
        hasHorizontalMovement = false

        if shouldInvalidateStrictTouchCount(for: event.touchCount) {
            invalidateGestureForTouchCountLoss()
        }
    }

    private func handleGestureChanged(with event: PanGestureEvent) {
        if isGestureInvalidated {
            return
        }

        if shouldInvalidateStrictTouchCount(for: event.touchCount) {
            invalidateGestureForTouchCountLoss()
            return
        }

        guard event.isHorizontalDominant else {
            return
        }

        hasHorizontalMovement = true

        let deltaProgress = event.translation.x / travelDistance
        let nextProgress = max(0, min(1, dragStartProgress + deltaProgress))
        progress = nextProgress
    }

    private func handleGestureEnded(with event: PanGestureEvent) {
        if isGestureInvalidated {
            resetGestureTracking()
            return
        }

        if !hasHorizontalMovement {
            failAndReset(message: "Slide must move horizontally.")
            resetGestureTracking()
            return
        }

        if completionRule.isSatisfied(progress: progress, velocityX: event.velocity.x) {
            completeSlide()
        } else {
            failAndReset(message: "Did not satisfy \(completionRule.title).")
        }

        resetGestureTracking()
    }

    private func handleGestureCancelled() {
        if isGestureInvalidated {
            resetGestureTracking()
            return
        }

        failAndReset(message: "Gesture cancelled.")
        resetGestureTracking()
    }

    private func shouldInvalidateStrictTouchCount(for touchCount: Int) -> Bool {
        if gesturePattern != .strictTwoFinger {
            return false
        }

        if touchCount < 2 {
            return true
        }

        return false
    }

    private func invalidateGestureForTouchCountLoss() {
        guard !isGestureInvalidated else {
            return
        }

        isGestureInvalidated = true
        failAndReset(message: "Strict 2-Finger requires two touches throughout the gesture.")
    }

    private func completeSlide() {
        withAnimation(.easeOut(duration: 0.2)) {
            progress = 1
        }

        isCompleted = true
        lastResult = .success("Completed with \(gesturePattern.title) + \(completionRule.title).")
    }

    private func failAndReset(message: String) {
        withAnimation(.easeOut(duration: 0.2)) {
            progress = .zero
        }

        lastResult = .failure(message)
    }

    private func resetGestureTracking() {
        dragStartProgress = progress
        isGestureInvalidated = false
        hasHorizontalMovement = false
    }

    private func resetLabState() {
        withAnimation(.easeOut(duration: 0.2)) {
            progress = .zero
        }

        isCompleted = false
        activeTouchCount = 0
        lastVelocityX = .zero
        lastResult = .idle
        dragStartProgress = .zero
        isGestureInvalidated = false
        hasHorizontalMovement = false
    }
}

private enum GesturePattern: String, CaseIterable, Identifiable {
    case strictTwoFinger = "Strict 2-Finger"
    case twoOrMoreFingers = "2+ Fingers"
    case oneFingerDrag = "1-Finger Drag"

    var id: String {
        rawValue
    }

    var title: String {
        rawValue
    }

    var description: String {
        switch self {
        case .strictTwoFinger:
            return "Requires exactly two touches during the full gesture."
        case .twoOrMoreFingers:
            return "Requires at least two touches and also allows three or more touches."
        case .oneFingerDrag:
            return "Allows only one-finger drag for comparison."
        }
    }

    var minimumNumberOfTouches: Int {
        switch self {
        case .strictTwoFinger:
            return 2
        case .twoOrMoreFingers:
            return 2
        case .oneFingerDrag:
            return 1
        }
    }

    var maximumNumberOfTouches: Int {
        switch self {
        case .strictTwoFinger:
            return 2
        case .twoOrMoreFingers:
            return Int.max
        case .oneFingerDrag:
            return 1
        }
    }
}

private enum CompletionRule: String, CaseIterable, Identifiable {
    case threshold80 = "80%"
    case threshold100 = "100%"
    case distanceAndVelocity = "Distance+Velocity"

    private var epsilon: CGFloat {
        0.001
    }

    var id: String {
        rawValue
    }

    var title: String {
        rawValue
    }

    var shortTitle: String {
        switch self {
        case .threshold80:
            return "80%"
        case .threshold100:
            return "100%"
        case .distanceAndVelocity:
            return "Dist+Vel"
        }
    }

    var description: String {
        switch self {
        case .threshold80:
            return "Complete when progress reaches 80%."
        case .threshold100:
            return "Complete only near the end position (100% - epsilon)."
        case .distanceAndVelocity:
            return "Complete at 65% distance, or at 45% if horizontal velocity is at least 850."
        }
    }

    func isSatisfied(progress: CGFloat, velocityX: CGFloat) -> Bool {
        switch self {
        case .threshold80:
            return progress >= 0.8
        case .threshold100:
            return progress >= 1 - epsilon
        case .distanceAndVelocity:
            if progress >= 0.65 {
                return true
            }

            if progress >= 0.45 && velocityX >= 850 {
                return true
            }

            return false
        }
    }
}

private struct SlideResult: Equatable {
    enum Kind {
        case idle
        case success
        case failure
    }

    let kind: Kind
    let message: String

    static var idle: Self {
        .init(kind: .idle, message: "Waiting for gesture input.")
    }

    static func success(_ message: String) -> Self {
        .init(kind: .success, message: message)
    }

    static func failure(_ message: String) -> Self {
        .init(kind: .failure, message: message)
    }

    var tintColor: Color {
        switch kind {
        case .idle:
            return .secondary
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
}

private struct PanGestureEvent {
    let phase: PanGesturePhase
    let translation: CGPoint
    let velocity: CGPoint
    let touchCount: Int

    var isHorizontalDominant: Bool {
        abs(translation.x) > abs(translation.y)
    }
}

private enum PanGesturePhase {
    case began
    case changed
    case ended
    case cancelled
    case failed

    init?(state: UIGestureRecognizer.State) {
        switch state {
        case .began:
            self = .began
        case .changed:
            self = .changed
        case .ended:
            self = .ended
        case .cancelled:
            self = .cancelled
        case .failed:
            self = .failed
        default:
            return nil
        }
    }
}

private struct TicketSlidePanCaptureView: UIViewRepresentable {
    let gesturePattern: GesturePattern
    let isEnabled: Bool
    let onEvent: (PanGestureEvent) -> Void

    func makeCoordinator() -> Coordinator {
        .init(onEvent: onEvent)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let panGestureRecognizer = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePanGesture(_:))
        )
        panGestureRecognizer.cancelsTouchesInView = true

        context.coordinator.panGestureRecognizer = panGestureRecognizer
        context.coordinator.apply(gesturePattern: gesturePattern)
        panGestureRecognizer.isEnabled = isEnabled

        view.addGestureRecognizer(panGestureRecognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.onEvent = onEvent
        context.coordinator.apply(gesturePattern: gesturePattern)

        guard let panGestureRecognizer = context.coordinator.panGestureRecognizer else {
            return
        }

        if panGestureRecognizer.isEnabled != isEnabled {
            panGestureRecognizer.isEnabled = isEnabled
        }
    }

    final class Coordinator: NSObject {
        var onEvent: (PanGestureEvent) -> Void
        weak var panGestureRecognizer: UIPanGestureRecognizer?

        init(onEvent: @escaping (PanGestureEvent) -> Void) {
            self.onEvent = onEvent
        }

        func apply(gesturePattern: GesturePattern) {
            guard let panGestureRecognizer else {
                return
            }

            panGestureRecognizer.minimumNumberOfTouches = gesturePattern.minimumNumberOfTouches
            panGestureRecognizer.maximumNumberOfTouches = gesturePattern.maximumNumberOfTouches
        }

        @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
            guard let phase = PanGesturePhase(state: recognizer.state) else {
                return
            }

            let event = PanGestureEvent(
                phase: phase,
                translation: recognizer.translation(in: recognizer.view),
                velocity: recognizer.velocity(in: recognizer.view),
                touchCount: recognizer.numberOfTouches
            )
            onEvent(event)
        }
    }
}

#Preview {
    NavigationStack {
        TicketSlideLabView()
    }
}
