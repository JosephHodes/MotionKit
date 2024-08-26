import Foundation

@available(iOS 13.0, *)
public struct CircularBufferQueue<T>: UpdatableQueue, ConvertibleToArray {
    public typealias Element = T
    
    public var array: [T?]
    public var head: Int = 0
    public var tail: Int = 0
    public var size: Int = 0
    public let capacity: Int
    public var is_full: Bool
    
    public init(_ capacity: Int) {
        self.capacity = capacity
        self.is_full = false
        self.array = capacity > 0 ? Array(repeating: nil, count: capacity) : []
    }
    
    public mutating func enqueue(_ element: T) {
        if isFull() {
            array[tail] = element
            tail = (tail + 1) % capacity
            head = (head + 1) % capacity
            self.is_full = true
        } else {
            array[tail] = element
            tail = (tail + 1) % capacity
            size += 1
            if size == capacity {
                self.is_full = true
            }
        }
    }
    
    public mutating func dequeue() -> T? {
        guard !isEmpty() else {
            return nil
        }
        
        let element = array[head]
        array[head] = nil
        head = (head + 1) % capacity
        size -= 1
        if is_full {
            is_full = false
        }
        return element
    }
    
    public func peek() -> T? {
        return array[head]
    }
    
    public func isFull() -> Bool {
        return self.is_full
    }
    
    public func isEmpty() -> Bool {
        return size == 0
    }
    
    public func count() -> Int {
        return size
    }
    
    public mutating func toArray() -> [T] {
        var result: [T] = []
        
        while !isEmpty() {
            if let element = dequeue() {
                result.append(element)
            }
        }
        return result
    }
    
    public mutating func update(at index: Int, with element: T) {
        guard index >= 0 && index < size else {
            print("Index out of bounds")
            return
        }
        
        // Calculate the actual index in the circular buffer
        let actualIndex = (head + index) % capacity
        array[actualIndex] = element
    }
}
