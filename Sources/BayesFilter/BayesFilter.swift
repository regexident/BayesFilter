public protocol BayesFilter: BayesPredictor, BayesUpdater {
    mutating func filter(observation: Observation) -> Estimate
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
