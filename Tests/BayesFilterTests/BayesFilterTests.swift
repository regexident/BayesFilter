import XCTest

@testable import BayesFilter

final class BayesFilterTests: XCTestCase {
    struct DummyFilter: BayesFilter, EstimateReadWritable {
        typealias Observation = Int
        typealias Estimate = Int
        
        var estimate: Estimate
        
        init(initial estimate: Estimate) {
            self.estimate = estimate
        }
        
        func predict(estimate: Estimate) -> Estimate {
            return estimate + 2
        }
        
        mutating func update(
            prediction: Estimate,
            observation: Observation
        ) -> Estimate {
            self.estimate = (prediction + observation) / 2
            return self.estimate
        }
    }
    
    func testPredict() {
        let filter = DummyFilter(initial: 40)
        
        XCTAssertEqual(filter.predict(), 42)
    }
    
    func testUpdate() {
        let initial = 32
        
        let observation = 50
        
        var filter = DummyFilter(initial: initial)
        
        let prediction = filter.predict() // 42
        let estimate = filter.update(
            prediction: prediction,
            observation: observation
        )
        
        // Expect average of prediction and observation:
        XCTAssertEqual(estimate, 42)
    }
    
    func testFilter() {
        let initial = 32
        
        let observation = 50
        
        var filter = DummyFilter(initial: initial)
        
        let estimate = filter.filter(
            observation: observation
        )
        
        // Expect average of prediction and observation:
        XCTAssertEqual(estimate, 42)
    }

    static var allTests = [
        ("testPredict", testPredict),
        ("testUpdate", testUpdate),
        ("testFilter", testFilter),
    ]
}
