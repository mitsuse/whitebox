import Dispatch

public struct Context {
    public static let main = Context(dispatchQueue: .main)

    private let dispatchQeueu: DispatchQueue

    public init(label: String) {
        self.init(dispatchQueue: DispatchQueue(label: label))
    }

    private init(dispatchQueue: DispatchQueue) {
        self.dispatchQeueu = dispatchQueue
    }
}
