import StateSpace

public protocol BayesPredictor: Estimatable {
    func predicted(estimate: Estimate) -> Estimate
}

extension BayesPredictor
    where Self: EstimateReadWritable
{
    public mutating func predict() {
        self.estimate = self.predicted(
            estimate: self.estimate
        )
    }
}

public protocol ControllableBayesPredictor: Estimatable, Controllable {
    func predicted(
        estimate: Estimate,
        control: Control
    ) -> Estimate
}

extension ControllableBayesPredictor
    where Self: EstimateReadWritable
{
    public mutating func predict(control: Control) {
        self.estimate = self.predicted(
            estimate: self.estimate,
            control: control
        )
    }
}
