public protocol BayesFilter {
    associatedtype Observation
    associatedtype Estimate

    func predict() -> Estimate

    mutating func update(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate
}

extension BayesFilter {
    public mutating func filter(
        observation: Observation
    ) -> Estimate {
        let prediction = self.predict()
        return self.update(
            prediction: prediction,
            observation: observation
        )
    }
}

