import Dispatch

public struct Subscription<State> {
    public let id: String
    let subscribe: (State) -> Void
    let dispatchQueue: DispatchQueue

    init(id: String, subscribe: @escaping (State) -> Void, dispatchQueue: DispatchQueue) {
        self.id = id
        self.subscribe = subscribe
        self.dispatchQueue = dispatchQueue
    }
}

extension Subscription: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
}

public func == <State>(_ x: Subscription<State>, _ y: Subscription<State>) -> Bool {
    return x.id == y.id
}
