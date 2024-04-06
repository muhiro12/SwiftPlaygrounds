//
//  ActorViewState.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/04/04.
//

import Combine
import Foundation

class CounterClass {
    private(set) var count = 0

    func increment() async {
        try! await Task.sleep(for: .seconds(1))
        count += 1
    }
}

actor CounterActor {
    private(set) var count = 0

    func increment() async {
        try! await Task.sleep(for: .seconds(1))
        count += 1
    }
}

@Observable final class ActorViewState {
    private(set) var classText = ""
    private(set) var actorText = ""

    private let counterClass = CounterClass()
    private let actorClass = CounterActor()

    func onTap() async {
        async let c: () = counterClass.increment()
        async let a: () = actorClass.increment()
        _ = await (c, a)
        classText = counterClass.count.description
        actorText = await actorClass.count.description
    }
}
