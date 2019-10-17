public protocol BayesUpdater {
    associatedtype Estimate
    associatedtype Observation

    mutating func update(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate
}
