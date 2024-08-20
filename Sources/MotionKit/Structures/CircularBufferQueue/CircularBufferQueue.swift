import Foundation

public struct CircularBufferQueue<T>: UpdatableQueue, ConvertibleToArray {
    public typealias Element = T
    
    private var array: [T?]
    private var head: Int = 0
    private var tail: Int = 0
    private var size: Int = 0
    public let capacity: Int
    
    public init(_ capacity: Int) {
        self.capacity = capacity
        self.array = Array(repeating: nil, count: capacity)
    }
    
    public mutating func enqueue(_ element: T) {
        if isFull() {
            array[tail] = element
            tail = (tail + 1) % capacity
            head = (head + 1) % capacity
        } else {
            array[tail] = element
            tail = (tail + 1) % capacity
            size += 1
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
        return element
    }
    
    public func peek() -> T? {
        return array[head]
    }
    
    public func isFull() -> Bool {
        return size == capacity
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
