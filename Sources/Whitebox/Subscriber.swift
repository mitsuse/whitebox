import Dispatch

public protocol Subscriber: class {
    associatedtype State

    func receive(_ state: State)
}

final class AnySubscriber<State>: Subscriber {
    private let _receive: (State) -> Void

    fileprivate init<Subscriber: Whitebox.Subscriber>(_ base: Subscriber) where Subscriber.State == State {
        self._receive = base.receive
    }

    func receive(_ state: State) { _receive(state) }
}

func any<Subscriber: Whitebox.Subscriber>(_ base: Subscriber) -> AnySubscriber<Subscriber.State> {
    return AnySubscriber(base)
}
