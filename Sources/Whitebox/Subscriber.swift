import Dispatch

public protocol Subscriber: class {
    associatedtype State

    func subscribe(_ application: Application<State>)
    func subscribe(_ application: Application<State>, on dispatchQeueu: DispatchQueue)
    func receive(_ state: State)
}

extension Subscriber {
    public func subscribe(_ application: Application<State>) {
        application.register(self)
    }

    public func subscribe(_ application: Application<State>, on dispatchQueue: DispatchQueue) {
        application.register(self, on: dispatchQueue)
    }
}

final class AnySubscriber<State>: Subscriber {
    private let _subscribe: (Application<State>) -> Void
    private let _subscribeOn: (Application<State>, DispatchQueue) -> Void
    private let _receive: (State) -> Void

    fileprivate init<Subscriber: Whitebox.Subscriber>(_ base: Subscriber) where Subscriber.State == State {
        self._subscribe = base.subscribe
        self._subscribeOn = base.subscribe
        self._receive = base.receive
    }

    func subscribe(_ application: Application<State>) { _subscribe(application) }
    func subscribe(_ application: Application<State>, on dispatchQueue: DispatchQueue) { _subscribeOn(application, dispatchQueue) }
    func receive(_ state: State) { _receive(state) }
}

func any<Subscriber: Whitebox.Subscriber>(_ base: Subscriber) -> AnySubscriber<Subscriber.State> {
    return AnySubscriber(base)
}
