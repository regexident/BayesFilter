public protocol BayesPredictor {
    associatedtype Estimate

    func predict() -> Estimate
}

public protocol ControllableBayesPredictor {
    associatedtype Estimate
    associatedtype Control

    func predict(control: Control) -> Estimate
}
