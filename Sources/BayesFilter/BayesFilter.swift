import StateSpace

public protocol BayesFilter: Estimatable, Observable {
    func filtered(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate
}

extension BayesFilter
    where Self: BayesPredictor & BayesUpdater
{
    public func filtered(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate {
        let prediction = self.predicted(
            estimate: estimate
        )
        return self.updated(
            prediction: prediction,
            observation: observation
        )
    }
}

extension BayesFilter
    where Self: EstimateReadWritable
{
    public mutating func filter(observation: Observation) {
        self.estimate = self.filtered(
            estimate: self.estimate,
            observation: observation
        )
    }
}

public protocol ControllableBayesFilter: Estimatable, Controllable, Observable {
    func filtered(
        estimate: Estimate,
        control: Control,
        observation: Observation
    ) -> Estimate
}

extension ControllableBayesFilter
    where Self: ControllableBayesPredictor & BayesUpdater
{
    public func filtered(
        estimate: Estimate,
        control: Control,
        observation: Observation
    ) -> Estimate {
        let prediction = self.predicted(
            estimate: estimate,
            control: control
        )
        return self.updated(
            prediction: prediction,
            observation: observation
        )
    }
}

extension ControllableBayesFilter
    where Self: EstimateReadWritable
{
    public mutating func filter(
        control: Control,
        observation: Observation
    ) {
        self.estimate = self.filtered(
            estimate: self.estimate,
            control: control,
            observation: observation
        )
    }
}
