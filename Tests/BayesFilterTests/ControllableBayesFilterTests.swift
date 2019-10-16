import XCTest

@testable import BayesFilter

final class ControllableBayesFilterTests: XCTestCase {
    struct DummyFilter: ControllableBayesFilter {
        typealias Observation = Int
        typealias Control = Int
        typealias Estimate = Int
        
        var estimate: Estimate
        
        init(initial estimate: Estimate) {
            self.estimate = estimate
        }
        
        func predict(
            control: Control
        ) -> Estimate {
            return self.estimate + control
        }
        
        mutating func update(
            prediction: Estimate,
            observation: Observation,
            control: Control
        ) -> Estimate {
            self.estimate = (prediction + observation) / 2
            return self.estimate
        }
    }
    
    func testPredict() {
        let filter = DummyFilter(initial: 42)
        
        XCTAssertEqual(filter.predict(control: 1), 43)
        XCTAssertEqual(filter.predict(control: 0), 42)
        XCTAssertEqual(filter.predict(control: -1), 41)
    }
    
    func testUpdate() {
        let initial = 42
        
        let control = 4
        let observation = 50
        
        var filter = DummyFilter(initial: initial)
        
        let prediction = filter.predict(control: control) // 46
        let estimate = filter.update(
            prediction: prediction,
            observation: observation,
            control: control
        )
        
        // Expect average of prediction and observation:
        XCTAssertEqual(estimate, 48)
    }
    
    func testFilter() {
        let initial = 42
        
        let control = 4
        let observation = 50
        
        var filter = DummyFilter(initial: initial)
        
        let estimate = filter.filter(
            observation: observation,
            control: control
        )
        
        // Expect average of prediction and observation:
        XCTAssertEqual(estimate, 48)
    }

    static var allTests = [
        ("testPredict", testPredict),
        ("testUpdate", testUpdate),
        ("testFilter", testFilter),
    ]
}
