import StateSpace

public protocol BayesPredictor: Estimatable {
    func predict(estimate: Estimate) -> Estimate
}

extension BayesPredictor
    where Self: EstimateReadable
{
    func predict() -> Estimate {
        return self.predict(
            estimate: self.estimate
        )
    }
}

public protocol ControllableBayesPredictor: Estimatable, Controllable {
    func predict(
        estimate: Estimate,
        control: Control
    ) -> Estimate
}

extension ControllableBayesPredictor
    where Self: EstimateReadable
{
    func predict(control: Control) -> Estimate {
        return self.predict(
            estimate: self.estimate,
            control: control
        )
    }
}
