import StateSpace

public class BayesFilter<Predictor, Updater, Estimate> {
    public var predictor: Predictor
    public var updater: Updater

    public init(
        predictor: Predictor,
        updater: Updater
    ) {
        self.predictor = predictor
        self.updater = updater
    }
}

extension BayesFilter: DimensionsValidatable {
    public func validate(for dimensions: DimensionsProtocol) throws {
        if let predictor = self.predictor as? DimensionsValidatable {
            try predictor.validate(for: dimensions)
        }
        if let updater = self.updater as? DimensionsValidatable {
            try updater.validate(for: dimensions)
        }
    }
}

extension BayesFilter: Controllable
where
    Predictor: Controllable
{
    public typealias Control = Predictor.Control
}

extension BayesFilter: Observable
where
    Updater: Observable
{
    public typealias Observation = Updater.Observation
}

extension BayesFilter: Estimatable {
    public typealias Estimate = Estimate
}

extension BayesFilter: BayesPredictorProtocol
where
    Predictor: BayesPredictorProtocol,
    Predictor.Estimate == Estimate
{
    public func predicted(
        estimate: Estimate
    ) -> Estimate {
        return self.predictor.predicted(
            estimate: estimate
        )
    }
}

extension BayesFilter: ControllableBayesPredictorProtocol
where
    Predictor: ControllableBayesPredictorProtocol,
    Predictor.Estimate == Estimate
{
    public func predicted(
        estimate: Estimate,
        control: Control
    ) -> Estimate {
        return self.predictor.predicted(
            estimate: estimate,
            control: control
        )
    }
}

extension BayesFilter: BayesUpdaterProtocol
where
    Updater: BayesUpdaterProtocol,
    Updater.Estimate == Estimate
{
    public func updated(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate {
        return self.updater.updated(
            prediction: prediction,
            observation: observation
        )
    }
}

extension BayesFilter: BayesFilterProtocol
where
    Predictor: BayesPredictorProtocol,
    Updater: BayesUpdaterProtocol,
    Predictor.Estimate == Estimate,
    Updater.Estimate == Estimate
{
    public func filtered(
        estimate: Estimate,
        observation: Observation
    ) -> Estimate {
        let prediction = self.predictor.predicted(
            estimate: estimate
        )
        let estimate = self.updater.updated(
            prediction: prediction,
            observation: observation
        )
        return estimate
    }
}

extension BayesFilter: ControllableBayesFilterProtocol
where
    Predictor: ControllableBayesPredictorProtocol,
    Updater: BayesUpdaterProtocol,
    Predictor.Estimate == Estimate,
    Updater.Estimate == Estimate
{
    public func filtered(
        estimate: Estimate,
        control: Control,
        observation: Observation
    ) -> Estimate {
        let prediction = self.predictor.predicted(
            estimate: estimate,
            control: control
        )
        let estimate = self.updater.updated(
            prediction: prediction,
            observation: observation
        )
        return estimate
    }
}
