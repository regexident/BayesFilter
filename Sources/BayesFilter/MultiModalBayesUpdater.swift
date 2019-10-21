import StateSpace

public class MultiModalBayesUpdater<Model, Updater>
    where Model: Hashable
{
    public var updaters: [Model: Updater] = [:]
    public var closure: (Model) -> Updater

    public init(
        closure: @escaping (Model) -> Updater
    ) {
        self.closure = closure
    }

    private func withUpdater<T>(
        for model: Model,
        _ closure: (Updater) -> T
    ) -> T {
        let updater = self.updaters[model] ?? self.closure(model)
        let result = closure(updater)
        self.updaters[model] = updater
        return result
    }
}

extension MultiModalBayesUpdater: Statable
    where Updater: Statable
{
    public typealias State = Updater.State
}

extension MultiModalBayesUpdater: Observable
    where Updater: Observable
{
    public typealias Observation = MultiModal<Model, Updater.Observation>
}

extension MultiModalBayesUpdater: Estimatable
    where Updater: Estimatable
{
    public typealias Estimate = Updater.Estimate
}

extension MultiModalBayesUpdater: BayesUpdater
    where Updater: BayesUpdater
{
    public func updated(
        prediction: Estimate,
        observation: Observation
    ) -> Estimate {
        return self.withUpdater(for: observation.model) { updater in
            return updater.updated(prediction: prediction, observation: observation.value)
        }
    }
}
