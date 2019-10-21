import StateSpace

public protocol BayesFilterProtocol: Estimatable, Observable {
    func filtered(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate
}

extension BayesFilterProtocol
    where Self: BayesPredictorProtocol & BayesUpdaterProtocol
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

extension BayesFilterProtocol
    where Self: EstimateReadWritable
{
    public mutating func filter(observation: Observation) {
        self.estimate = self.filtered(
            estimate: self.estimate,
            observation: observation
        )
    }
}

public protocol ControllableBayesFilterProtocol: Estimatable, Controllable, Observable {
    func filtered(
        estimate: Estimate,
        control: Control,
        observation: Observation
    ) -> Estimate
}

extension ControllableBayesFilterProtocol
    where Self: ControllableBayesPredictorProtocol & BayesUpdaterProtocol
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

extension ControllableBayesFilterProtocol
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
