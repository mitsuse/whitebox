import Quick
import Nimble

import PromiseKit

@testable import Whitebox

class ApplicationSpec: QuickSpec {
    override func spec() {
        describe("Application") {
            it("should publish the current state the registered subscriber once.") {
                let initial = 0
                let application = Application(initial: initial, persistence: InMemoryPersistence())
                var received1: Int? = nil
                var received2: Int? = nil
                _ = application.register { received1 = $0 }
                expect(received1).toEventually(equal(initial))
                _ = application.register { received2 = $0 }
                expect(received2).toEventually(equal(initial))
            }

            it("should publish the state to all subscribers.") {
                let initial = 0
                let application = Application(initial: initial, persistence: InMemoryPersistence())
                var received1: Int? = nil
                var received2: Int? = nil
                _ = application.register { received1 = $0 }
                _ = application.register { received2 = $0 }
                application.receive { Promise(value: $0 + 1) }
                expect(received1).toEventually(equal(initial + 1))
                expect(received2).toEventually(equal(initial + 1))
            }

            it("should handle actions with thread safety.") {
                let dispatchQueue = DispatchQueue(label: "jp.mitsuse.Whitebox.AppplicationSpec", attributes: .concurrent)
                let initial = 0
                let application = Application(initial: initial, persistence: InMemoryPersistence())
                let expectation = 100
                var received: Int?
                _ = application.register { received = $0 }
                (0..<expectation).forEach { _ in
                    dispatchQueue.async {
                        application.receive { Promise(value: $0 + 1) }
                    }
                }
                expect(received).toEventually(equal(expectation))
            }

            it("should restore the state on instantiation.") {
                let initial = 0
                let last = 10
                let application = Application(initial: initial, persistence: InMemoryPersistence(state: last))
                var received: Int?
                _ = application.register { received = $0 }
                expect(received).toEventually(equal(last))
            }

            it("should persist the latest state on each transition.") {
                let initial = 0
                let persistence = InMemoryPersistence<Int>()
                let application = Application(initial: initial, persistence: persistence)
                var received = false
                _ = application.register { _ in received = true }
                application.receive { Promise(value: $0 + 1) }
                expect(received).toEventually(beTrue())
                var restored: Int?
                _ = persistence.restore().then { restored = $0 }
                expect(restored).toEventually(equal(initial + 1))
            }

            it("should register subscribers with thread safety.") {
                let dispatchQueue = DispatchQueue(label: "jp.mitsuse.Whitebox.RegistrySpec.registration", attributes: .concurrent)
                let context = Context(label: "jp.mitsuse.Whitebox.RegistrySpec.subscription")
                let initial = 0
                let application = Application(initial: initial, persistence: InMemoryPersistence())
                let registerCount = 100
                var received = 0
                (0..<registerCount).forEach { value in
                    dispatchQueue.async {
                        _ = application.register(on: context) { _ in received += 1 }
                    }
                }
                Thread.sleep(forTimeInterval: 1.0)
                expect(received).toEventually(equal(registerCount))
            }
        }
    }
}
