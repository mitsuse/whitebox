import PromiseKit

public final class Application<State> {
    public typealias Action = (State) -> Promise<State>

    private let dispatchQueue = DispatchQueue(label: "jp.mitsuse.Whitebox.Application")
    private var subscriptions = Set<Subscription<State>>()

    private let persistence: AnyPersistence<State>

    public init<Persistence: Whitebox.Persistence>(persistence: Persistence) where Persistence.State == State {
        self.persistence = any(persistence)
    }

    public func receive(_ action: @escaping (State) -> Promise<State>) {
        return notImplemented()
    }

    public func register(subscribe: @escaping (State) -> Void) -> Subscription<State> {
        return register(on: dispatchQueue, subscribe: subscribe)
    }

    public func register(on dispatchQueue: DispatchQueue, subscribe: @escaping (State) -> Void) -> Subscription<State> {
        return notImplemented()
    }

    public func unregister(_ subscription: Subscription<State>?) {
        return notImplemented()
    }
}
