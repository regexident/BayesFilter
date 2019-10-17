import StateSpace

public protocol BayesPredictor: Estimatable {
    func predict() -> Estimate
}

public protocol ControllableBayesPredictor: Estimatable, Controllable {
    func predict(control: Control) -> Estimate
}
