import Dispatch

struct Subscription<State> {
    let id: String

    private weak var subscriber: AnySubscriber<State>?

    private let dispatchQueue: DispatchQueue

    init<Subscriber: Whitebox.Subscriber>(
        id: String,
        subscriber: Subscriber,
        dispatchQueue: DispatchQueue
    ) where Subscriber.State == State {
        self.id = id
        self.subscriber = any(subscriber)
        self.dispatchQueue = dispatchQueue
    }
}

extension Subscription: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

func == <State>(_ x: Subscription<State>, _ y: Subscription<State>) -> Bool {
    return x.id == y.id
}
