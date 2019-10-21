import StateSpace

public protocol BayesUpdaterProtocol: Estimatable, Observable {
    func updated(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate
}

extension BayesUpdaterProtocol
    where Self: EstimateReadWritable
{
    public mutating func update(observation: Observation) {
        self.estimate = self.updated(
            prediction: self.estimate,
            observation: observation
        )
    }
}
