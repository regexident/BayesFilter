public protocol ControllableBayesFilter: ControllableBayesPredictor, BayesUpdater {
    mutating func filter(
        observation: Observation,
        control: Control
    ) -> Estimate
}

extension ControllableBayesFilter {
    public mutating func filter(
        observation: Observation,
        control: Control
    ) -> Estimate {
        let prediction = self.predict(control: control)
        return self.update(
            prediction: prediction,
            observation: observation
        )
    }
}
