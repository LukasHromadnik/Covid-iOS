//
//  Publisher.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Combine

public extension Publisher {
    func sink(receiveValue: @escaping (Output) -> Void) {
        var cancellable: AnyCancellable?
        cancellable = sink(
            receiveCompletion: { _ in
                _ = cancellable
            },
            receiveValue: receiveValue
        )
    }
}
