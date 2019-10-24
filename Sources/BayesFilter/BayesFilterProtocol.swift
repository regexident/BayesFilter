import StateSpace

public protocol BayesFilterProtocol: Estimatable, Observable {
    func filtered(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate

    func batchFiltered<S>(
        estimate: Estimate,
        observations: S
    ) -> Estimate where S: Sequence, S.Element == Observation
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

    public func batchFiltered<S>(
        estimate: Estimate,
        observations: S
    ) -> Estimate
        where S: Sequence, S.Element == Observation
    {
        return observations.reduce(estimate) { estimate, observation in
            let prediction = self.predicted(
                estimate: estimate
            )
            return self.updated(
                prediction: prediction,
                observation: observation
            )
        }
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

    func batchFiltered<C, O>(
        estimate: Estimate,
        controls: C,
        observations: O
    ) -> Estimate where C: Sequence, O: Sequence, C.Element == Control, O.Element == Observation
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

    public func batchFiltered<C, O>(
        estimate: Estimate,
        controls: C,
        observations: O
    ) -> Estimate
        where C: Sequence, O: Sequence, C.Element == Control, O.Element == Observation
    {
        let inputs = zip(controls, observations)
        return inputs.reduce(estimate) { estimate, input in
            let (control, observation) = input
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
