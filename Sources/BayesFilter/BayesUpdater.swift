import StateSpace

public protocol BayesUpdater: Estimatable, Observable {
    mutating func update(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate
}
