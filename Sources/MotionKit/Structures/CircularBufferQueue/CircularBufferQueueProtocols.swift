//
//  File.swift
//  
//
//  Created by henry on 8/19/24.
//

import Foundation

public protocol Queue {
    associatedtype Element

    var capacity: Int { get }
    func isEmpty() -> Bool
    func isFull() -> Bool
    func count() -> Int
    func peek() -> Element?
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
}

public protocol UpdatableQueue: Queue {
    mutating func update(at index: Int, with element: Element)
}

public protocol ConvertibleToArray {
    associatedtype Element
    mutating func toArray() -> [Element]
}
