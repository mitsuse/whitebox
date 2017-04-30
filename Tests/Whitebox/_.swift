import Dispatch
import Whitebox
import PromiseKit

final class InMemoryPersistence<State>: Persistence {
    private let dispatchQueue = DispatchQueue(label: "jp.mitsuse.WhiteboxTests.InMemoryPersistence")

    private var state: State?

    init(state: State? = nil) {
        self.state = state
    }

    func store(_ state: State) -> Promise<State> {
        return dispatchQueue.promise { [weak self] in
            self?.state = state
            return state
        }
    }

    func restore() -> Promise<State?> {
        return dispatchQueue.promise { [weak self] in
            return self?.state
        }
    }
}
