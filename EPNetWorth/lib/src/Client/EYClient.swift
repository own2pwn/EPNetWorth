//
//  EYClient.swift
//  BraveNeuron
//
//  Created by Evgeniy on 10/02/2019.
//  Copyright © 2019 Evgeniy. (BraveNeuron) All rights reserved.
//

import Foundation
import Promise

public protocol EYClient: class {
    // func get<A: Resource, M>(resource: A) -> Promise<M>
    // func get<A: Resource, B: QueryElement, M>(resource: A, with query: [B]) -> Promise<M>

    // func post<M>(to resource: R, with query: [Q], body: [B]) -> Promise<M>

    // func `as`<A: Resource, B: QueryElement, C: BodyElement>(_ r: A.Type, _ q: B.Type, _ b: C.Type) -> EYClient
}
