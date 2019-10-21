import StateSpace

public class MultiModalBayesPredictor<Model, Predictor>
    where Model: Hashable
{
    public var predictors: [Model: Predictor] = [:]
    public var closure: (Model) -> Predictor

    public init(
        closure: @escaping (Model) -> Predictor
    ) {
        self.closure = closure
    }

    private func withPredictor<T>(
        for model: Model,
        _ closure: (Predictor) -> T
    ) -> T {
        let predictor = self.predictors[model] ?? self.closure(model)
        let result = closure(predictor)
        self.predictors[model] = predictor
        return result
    }
}

extension MultiModalBayesPredictor: Statable
    where Predictor: Statable
{
    public typealias State = Predictor.State
}

extension MultiModalBayesPredictor: Controllable
    where Predictor: Controllable
{
    public typealias Control = MultiModal<Model, Predictor.Control>
}

extension MultiModalBayesPredictor: Estimatable
    where Predictor: Estimatable
{
    public typealias Estimate = Predictor.Estimate
}

extension MultiModalBayesPredictor: ControllableBayesPredictor
    where Predictor: ControllableBayesPredictor
{
    public func predicted(estimate: Estimate, control: Control) -> Estimate {
        return self.withPredictor(for: control.model) { predictor in
            return predictor.predicted(estimate: estimate, control: control.value)
        }
    }
}
