import PromiseKit

public final class Application<State> {
    public typealias Action = (State) -> Promise<State>

    private let dispatchQueue = DispatchQueue(label: "jp.mitsuse.Whitebox.Application")
    private let actionQeueu = Queue<Action>()
    private var subscriptions = Set<Subscription<State>>()

    private let persistence: AnyPersistence<State>

    public init<Persistence: Whitebox.Persistence>(persistence: Persistence) where Persistence.State == State {
        self.persistence = any(persistence)
    }

    public func receive(_ action: @escaping (State) -> Promise<State>) {
        return notImplemented()
    }

    public func register<Subscriber: Whitebox.Subscriber>(_ subscriber: Subscriber) where Subscriber.State == State {
        return register(subscriber, on: dispatchQueue)
    }

    public func register<Subscriber: Whitebox.Subscriber>(
        _ subscriber: Subscriber,
        on dispatchQueue: DispatchQueue
    ) where Subscriber.State == State {
        return notImplemented()
    }
}
