//
//  File.swift
//  
//
//  Created by henry on 8/18/24.
//

import Foundation

public struct LiveMotion : Codable {
    public var x: Double
    public var y: Double
    public var z: Double
    public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public struct CachedMotion {
    public var PastMotions: CircularBufferQueue<LiveMotion>

    // Provide an initial capacity for the CircularBufferQueue
    public init(capacity: Int) {
        self.PastMotions = CircularBufferQueue(capacity)
    }
}
