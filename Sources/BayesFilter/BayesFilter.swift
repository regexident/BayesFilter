public protocol BayesFilter {
    associatedtype Observation
    associatedtype Control
    associatedtype Prediction
    associatedtype Estimate

    func predict(
        control: Control
    ) -> Prediction

    func update(
        prediction: Prediction,
        observation: Observation,
        control: Control
    ) -> Estimate
}

extension BayesFilter {
    public func filter(
        observation: Observation,
        control: Control
    ) -> Estimate {
        let prediction = self.predict(control: control)
        return self.update(
            prediction: prediction,
            observation: observation,
            control: control
        )
    }
}
