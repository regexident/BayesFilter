import StateSpace

public protocol BayesFilterProtocol: Estimatable, Observable {
    func filtered(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate

    func batchFiltered<S>(
        estimate: Estimate,
        observations: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == Observation
}

extension BayesFilterProtocol
where
    Self: BayesPredictorProtocol & BayesUpdaterProtocol
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
    where
        S: Sequence,
        S.Element == Observation
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
where
    Self: EstimateReadWritable
{
    public mutating func filter(
        observation: Observation
    ) {
        self.estimate = self.filtered(
            estimate: self.estimate,
            observation: observation
        )
    }

    public mutating func batchFilter<S>(
        observations: S
    )
    where
        S: Sequence,
        S.Element == Observation
    {
        self.estimate = self.batchFiltered(
            estimate: self.estimate,
            observations: observations
        )
    }
}

public protocol ControllableBayesFilterProtocol: Estimatable, Controllable, Observable {
    func filtered(
        estimate: Estimate,
        control: Control,
        observation: Observation
    ) -> Estimate

    func batchFiltered<S>(
        estimate: Estimate,
        control: Control,
        observations: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == Observation

    func batchFiltered<S>(
        estimate: Estimate,
        controlsAndObservations: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == (Control, Observation)
}

extension ControllableBayesFilterProtocol
where
    Self: ControllableBayesPredictorProtocol & BayesUpdaterProtocol
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

    public func batchFiltered<S>(
        estimate: Estimate,
        control: Control,
        observations: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == Observation
    {
        let prediction = self.predicted(
            estimate: estimate,
            control: control
        )
        return self.batchUpdated(
            prediction: prediction,
            observations: observations
        )
    }

    public func batchFiltered<S>(
        estimate: Estimate,
        controlsAndObservations: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == (Control, Observation)
    {
        return controlsAndObservations.reduce(estimate) { estimate, controlAndObservation in
            let (control, observation) = controlAndObservation
            return self.filtered(
                estimate: estimate,
                control: control,
                observation: observation
            )
        }
    }
}

extension ControllableBayesFilterProtocol
where
    Self: EstimateReadWritable
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

    public mutating func batchFilter<S>(
        control: Control,
        observations: S
    )
    where
        S: Sequence,
        S.Element == Observation
    {
        self.estimate = self.batchFiltered(
            estimate: self.estimate,
            control: control,
            observations: observations
        )
    }

    public mutating func batchFilter<S>(
        controlsAndObservations: S
    )
    where
        S: Sequence,
        S.Element == (Control, Observation)
    {
        self.estimate = self.batchFiltered(
            estimate: self.estimate,
            controlsAndObservations: controlsAndObservations
        )
    }
}
