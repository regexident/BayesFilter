public protocol BayesFilter: BayesPredictor, BayesUpdater {
    mutating func filter(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate
}

extension BayesFilter {
    public mutating func filter(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate {
        let prediction = self.predict(
            estimate: estimate
        )
        return self.update(
            prediction: prediction,
            observation: observation
        )
    }
}

extension BayesFilter
    where Self: EstimateReadWritable
{
    mutating func filter(observation: Observation) -> Estimate {
        return self.filter(
            estimate: self.estimate,
            observation: observation
        )
    }
}

public protocol ControllableBayesFilter: ControllableBayesPredictor, BayesUpdater {
    mutating func filter(
        estimate: Estimate,
        observation: Observation,
        control: Control
    ) -> Estimate
}

extension ControllableBayesFilter {
    public mutating func filter(
        estimate: Estimate,
        observation: Observation,
        control: Control
    ) -> Estimate {
        let prediction = self.predict(
            estimate: estimate,
            control: control
        )
        return self.update(
            prediction: prediction,
            observation: observation
        )
    }
}

extension ControllableBayesFilter
    where Self: EstimateReadWritable
{
    mutating func filter(
        observation: Observation,
        control: Control
    ) -> Estimate {
        return self.filter(
            estimate: self.estimate,
            observation: observation,
            control: control
        )
    }
}
