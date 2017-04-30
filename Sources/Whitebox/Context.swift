import Dispatch

public struct Context {
    public static let main = Context(dispatchQueue: .main)

    let dispatchQueue: DispatchQueue

    public init(label: String) {
        self.init(dispatchQueue: DispatchQueue(label: label))
    }

    private init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
    }
}
