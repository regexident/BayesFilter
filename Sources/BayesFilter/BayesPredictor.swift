import StateSpace

public protocol BayesPredictorProtocol: Estimatable {
    func predicted(estimate: Estimate) -> Estimate
}

extension BayesPredictorProtocol
    where Self: EstimateReadWritable
{
    public mutating func predict() {
        self.estimate = self.predicted(
            estimate: self.estimate
        )
    }
}

public protocol ControllableBayesPredictorProtocol: Estimatable, Controllable {
    func predicted(
        estimate: Estimate,
        control: Control
    ) -> Estimate
}

extension ControllableBayesPredictorProtocol
    where Self: EstimateReadWritable
{
    public mutating func predict(control: Control) {
        self.estimate = self.predicted(
            estimate: self.estimate,
            control: control
        )
    }
}
