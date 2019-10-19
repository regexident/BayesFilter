import StateSpace

public protocol BayesUpdater: Estimatable, Observable {
    func updated(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate
}

extension BayesUpdater
    where Self: EstimateReadWritable
{
    public mutating func update(observation: Observation) {
        self.estimate = self.updated(
            prediction: self.estimate,
            observation: observation
        )
    }
}
