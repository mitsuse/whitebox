import Dispatch
import Quick
import Nimble

@testable import Whitebox

class QueueSpec: QuickSpec {
    override func spec() {
        describe("Queue") {
            it("has the count of queued items") {
                let count = 100
                var queue = Queue<Int>()
                expect(queue.count).to(equal(0))
                (0..<count).forEach { queue.push($0) }
                expect(queue.count).to(equal(count))
            }

            it("should be thread-safe.") {
                let dispatchQueue = DispatchQueue(label: "jp.mitsuse.WhiteboxTestsQueue", attributes: .concurrent)
                let count = 100
                let reference = Reference(Queue<Int>())
                (0..<count).forEach { value in
                    dispatchQueue.async { [weak reference] in
                        reference?.base?.push(value)
                    }
                }
                expect(reference.base?.count).toEventually(equal(count))
            }

            it("should be FIFO.") {
                let first = 1
                let second = 2
                let third = 3
                var queue = Queue<Int>()
                queue.push(first)
                queue.push(second)
                queue.push(third)
                expect(queue.pop()).to(equal(first))
                expect(queue.pop()).to(equal(second))
                expect(queue.pop()).to(equal(third))
            }
        }
    }
}
