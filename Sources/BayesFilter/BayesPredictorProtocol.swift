import StateSpace

public protocol BayesPredictorProtocol: Estimatable {
    func predicted(estimate: Estimate) -> Estimate

    func batchPredicted(
        estimate: Estimate,
        iterations: Int
    ) -> Estimate
}

extension BayesPredictorProtocol {
    public func batchPredicted(
        estimate: Estimate,
        iterations: Int
    ) -> Estimate {
        return (0..<iterations).reduce(estimate) { estimate, _ in
            return self.predicted(
                estimate: estimate
            )
        }
    }
}

extension BayesPredictorProtocol
where
    Self: EstimateReadWritable
{
    public mutating func predict() {
        self.estimate = self.predicted(
            estimate: self.estimate
        )
    }
}

public protocol ControllableBayesPredictorProtocol: Estimatable, Controllable {
    func predicted(
        estimate: Estimate,
        control: Control
    ) -> Estimate

    func batchPredicted<S>(
        estimate: Estimate,
        controls: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == Control
}

extension ControllableBayesPredictorProtocol {
    public func batchPredicted<S>(
        estimate: Estimate,
        controls: S
    ) -> Estimate
    where
        S: Sequence,
        S.Element == Control
    {
        return controls.reduce(estimate) { estimate, control in
            return self.predicted(
                estimate: estimate,
                control: control
            )
        }
    }
}

extension ControllableBayesPredictorProtocol
where
    Self: EstimateReadWritable
{
    public mutating func predict(
        control: Control
    ) {
        self.estimate = self.predicted(
            estimate: self.estimate,
            control: control
        )
    }

    public mutating func batchPredict<S>(
        controls: S
    )
    where
        S: Sequence,
        S.Element == Control
    {
        self.estimate = self.batchPredicted(
            estimate: self.estimate,
            controls: controls
        )
    }
}
