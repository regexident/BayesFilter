import StateSpace

public class Estimateful<Wrapped>: EstimateReadWritable
where
    Wrapped: Estimatable
{
    public var estimate: Wrapped.Estimate
    public private(set) var wrapped: Wrapped

    public init(
        estimate: Wrapped.Estimate,
        wrapping wrapped: Wrapped
    ) {
        self.estimate = estimate
        self.wrapped = wrapped
    }
}

extension Estimateful: DimensionsValidatable {
    public func validate(for dimensions: DimensionsProtocol) throws {
        if let estimate = self.estimate as? DimensionsValidatable {
            try estimate.validate(for: dimensions)
        }
        if let filter = self.wrapped as? DimensionsValidatable {
            try filter.validate(for: dimensions)
        }
    }
}

extension Estimateful: Controllable
where
    Wrapped: Controllable
{
    public typealias Control = Wrapped.Control
}

extension Estimateful: Observable
where
    Wrapped: Observable
{
    public typealias Observation = Wrapped.Observation
}

extension Estimateful: Estimatable
where
    Wrapped: Estimatable
{
    public typealias Estimate = Wrapped.Estimate
}

extension Estimateful: BayesPredictorProtocol
where
    Wrapped: BayesPredictorProtocol
{
    public func predicted(
        estimate: Estimate
    ) -> Estimate {
        return self.wrapped.predicted(
            estimate: estimate
        )
    }
}

extension Estimateful: ControllableBayesPredictorProtocol
where
    Wrapped: ControllableBayesPredictorProtocol
{
    public func predicted(
        estimate: Estimate,
        control: Control
    ) -> Estimate {
        return self.wrapped.predicted(
            estimate: estimate,
            control: control
        )
    }
}

extension Estimateful: BayesUpdaterProtocol
where
    Wrapped: BayesUpdaterProtocol
{
    public func updated(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate {
        return self.wrapped.updated(
            prediction: prediction,
            observation: observation
        )
    }
}

extension Estimateful: BayesFilterProtocol
where
    Wrapped: BayesFilterProtocol
{
    public func filtered(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate {
        return self.wrapped.filtered(
            estimate: estimate,
            observation: observation
        )
    }

    public func batchFiltered<S>(
        estimate: Wrapped.Estimate,
        observations: S
    ) -> Wrapped.Estimate
    where
        S: Sequence,
        Observation == S.Element
    {
        return self.wrapped.batchFiltered(
            estimate: estimate,
            observations: observations
        )
    }
}

extension Estimateful: ControllableBayesFilterProtocol
where
    Wrapped: ControllableBayesFilterProtocol
{
    public func filtered(
        estimate: Estimate,
        control: Control,
        observation: Observation
    ) -> Estimate {
        return self.wrapped.filtered(
            estimate: estimate,
            control: control,
            observation: observation
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
        return self.wrapped.batchFiltered(
            estimate: estimate,
            controlsAndObservations: controlsAndObservations
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
        return self.wrapped.batchFiltered(
            estimate: estimate,
            control: control,
            observations: observations
        )
    }
}
