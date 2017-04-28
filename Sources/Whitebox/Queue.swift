import Dispatch

struct Queue<Item> {
    private let semaphore = DispatchSemaphore(value: 1)

    private var items: [Item]

    init(items: Item...) {
        self.items = items
    }

    var count: Int {
        return items.count
    }

    mutating func push(_ item: Item) {
        semaphore.wait(); defer { semaphore.signal() }
        self.items.insert(item, at: 0)
    }

    mutating func pop() -> Item? {
        semaphore.wait(); defer { semaphore.signal() }
        return self.items.popLast()
    }
}
