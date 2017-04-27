import PromiseKit

public protocol Persistence {
    associatedtype State

    func store(_ state: State) -> Promise<State>
    func restore() -> Promise<State?>
}

final class AnyPersistence<State>: Persistence {
    private let _store: (State) -> Promise<State>
    private let _restore: () -> Promise<State?>

    fileprivate init<Persistence: Whitebox.Persistence>(_ base: Persistence) where Persistence.State == State {
        self._store = base.store
        self._restore = base.restore
    }

    func store(_ state: State) -> Promise<State> { return _store(state) }
    func restore() -> Promise<State?> { return _restore() }
}

func any<Persistence: Whitebox.Persistence>(_ base: Persistence) -> AnyPersistence<Persistence.State> {
    return AnyPersistence(base)
}
