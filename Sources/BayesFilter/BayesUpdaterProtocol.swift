import StateSpace

public protocol BayesUpdaterProtocol: Estimatable, Observable {
    func updated(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate

    func batchUpdated<S>(
        prediction: Estimate,
        observations: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == Observation
}

extension BayesUpdaterProtocol {
    public func batchUpdated<S>(
        prediction: Estimate,
        observations: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == Observation
    {
        return observations.reduce(prediction) { estimate, observation in
            return self.updated(
                prediction: estimate,
                observation: observation
            )
        }
    }
}

extension BayesUpdaterProtocol
where
    Self: EstimateReadWritable
{
    public mutating func update(
        observation: Observation
    ) {
        self.estimate = self.updated(
            prediction: self.estimate,
            observation: observation
        )
    }

    public mutating func batchUpdate<S>(
        observations: S
    )
    where
        S: Sequence,
        S.Element == Observation
    {
        self.estimate = self.batchUpdated(
            prediction: self.estimate,
            observations: observations
        )
    }
}
