import Dispatch
import PromiseKit

public final class Application<State> {
    public typealias Action = (State) -> Promise<State>

    private let dispatchQueue = DispatchQueue(label: "jp.mitsuse.Whitebox.Application")
    private var subscriptions = Set<Subscription<State>>()

    private let persistence: AnyPersistence<State>
    private var actionQueue: Promise<State>

    private var state: State? {
        didSet {
            guard let state = state else { return }
            subscriptions.forEach { subscription in
                subscription.dispatchQueue.async { subscription.subscribe(state) }
            }
        }
    }

    public init<Persistence: Whitebox.Persistence>(initial: State, persistence: Persistence) where Persistence.State == State {
        self.persistence = any(persistence)
        self.actionQueue =
            persistence.restore()
                .recover { _ in initial }
                .then { $0 ?? initial }

        self.actionQueue = actionQueue.then { [weak self] state -> State in self?.state = state; return state }
    }

    public func receive(_ action: @escaping (State) -> Promise<State>) {
        dispatchQueue.async {
            self.actionQueue =
                self.actionQueue
                    .then(execute: action)
                    .then(execute: self.persistence.store)
                    .then { state -> State in self.state = state; return state }
        }
    }

    public func register(subscribe: @escaping (State) -> Void) -> Subscription<State> {
        return register(on: .main, subscribe: subscribe)
    }

    public func register(on context: Context, subscribe: @escaping (State) -> Void) -> Subscription<State> {
        let subscription = Subscription(id: UUID().uuidString, subscribe: subscribe, dispatchQueue: context.dispatchQueue)
        dispatchQueue.async {
            if let state = self.state {
                subscription.dispatchQueue.async { subscription.subscribe(state) }
            }
            self.subscriptions.insert(subscription)
        }
        return subscription
    }

    public func unregister(_ subscription: Subscription<State>?) {
        guard let subscription = subscription else { return }
        dispatchQueue.async {
            self.subscriptions.remove(subscription)
        }
    }
}
