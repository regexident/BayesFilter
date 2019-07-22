public protocol BayesFilter {
    associatedtype Observation
    associatedtype Control
    associatedtype Estimate

    func predict(
        control: Control
    ) -> Estimate

    mutating func update(
        prediction: Estimate,
        observation: Observation,
        control: Control
    ) -> Estimate
}

extension BayesFilter {
    public mutating func filter(
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
