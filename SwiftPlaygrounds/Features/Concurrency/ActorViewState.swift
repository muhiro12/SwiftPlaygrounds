//
//  ActorViewState.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/04/04.
//

import Foundation
import Observation

final class CounterClass {
    private(set) var count = 0

    func increment() async {
        do {
            try await Task.sleep(for: .seconds(1))
            count += 1
        } catch {}
    }
}

actor CounterActor {
    private(set) var count = 0

    func increment() async {
        do {
            try await Task.sleep(for: .seconds(1))
            count += 1
        } catch {}
    }
}

@Observable
final class ActorViewState {
    private(set) var classText = ""
    private(set) var actorText = ""

    private let counterClass = CounterClass()
    private let counterActor = CounterActor()

    func onTap() async {
        async let classTask: Void = counterClass.increment()
        async let actorTask: Void = counterActor.increment()
        _ = await (classTask, actorTask)
        classText = counterClass.count.description
        actorText = await counterActor.count.description
    }
}
