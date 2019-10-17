//public struct Contextual<Context, Value> {
//    let context: Context
//    let value: Value
//}
//
//public class ContextualControllableBayesFilter<Context, Filter>
//    where Context: Hashable, Filter: Estimatable
//{
//    public var estimate: Estimate
//    private var closure: (Context, Estimate) -> Filter
//
//    private var filters: [Context: Filter] = [:]
//
//    public init(
//        estimate: Estimate,
//        _ closure: @escaping (Context, Estimate) -> Filter
//    ) {
//        self.estimate = estimate
//        self.closure = closure
//    }
//
////    public func predict(
////        control: Control
////    ) -> Estimate {
////        let kalmanFilter = self.filter(for: control.context)
////        return kalmanFilter.predict(control: control.payload)
////    }
//
////    public func update(
////        prediction: Estimate,
////        observation: Observation,
////        control: Control
////    ) -> Estimate {
////        let kalmanFilter = self.filter(for: control.context)
////        let estimate = kalmanFilter.update(
////            prediction: prediction,
////            observation: observation,
////            control: control.payload
////        )
////        self.estimate = estimate
////        return estimate
////    }
//}
//
//extension ContextualControllableBayesFilter: Estimatable
//    where Filter: Estimatable
//{
//    public typealias Estimate = Filter.Estimate
//}
//
//extension ContextualControllableBayesFilter: Controllable
//    where Filter: Controllable
//{
//    public typealias Control = Filter.Control
//}
//
//extension ContextualControllableBayesFilter: Observable
//    where Filter: Observable
//{
//    public typealias Observation = Contextual<Context, Filter.Observation>
//}
//
//extension ContextualControllableBayesFilter
//    where Filter: EstimateAccessible
//{
//    private func withFilter<T>(for context: Context, _ closure: (inout Filter) -> T) -> T {
//        var filter = self.filters[context] ?? self.closure(context, self.estimate)
//        filter.estimate = self.estimate
//
//        let result = closure(&filter)
//
//        self.filters[context] = filter
//
//        return result
//    }
////    private func withFilter(for context: Context, _ closure: (inout Filter) -> ()) {
////        var filter = self.filters[context] ?? self.closure(context, self.estimate)
////        filter.estimate = self.estimate
////
////        self.filters[context] = filter
////
////        return filter
////    }
//}
//
//extension ContextualControllableBayesFilter: BayesPredictor
//    where Filter: BayesPredictor & EstimateAccessible
//{
//    public func predict() -> Estimate {
//        return self.withFilter(for: control.context) { filter in
//            return filter.predict()
//        }
//    }
//}
//
//extension ContextualControllableBayesFilter: ControllableBayesPredictor
//    where Filter: ControllableBayesPredictor & EstimateAccessible
//{
//    public func predict(control: Control) -> Estimate {
//        return self.withFilter(for: control.context) { filter in
//            return filter.predict(control: control.value)
//        }
//    }
//}
//
////extension ContextualControllableBayesFilter: BayesUpdater
////    where Filter: BayesUpdater & Controllable & EstimateAccessible
////{
////    public func update(
////        prediction: Estimate,
////        observation: Observation
////    ) -> Estimate {
//////        let context = control.context
//////        let control = control.value
////        let estimate = self.withFilter(for: control.context) { filter in
////            let estimate = filter.update(
////                prediction: prediction,
////                observation: observation,
////                control: control.value
////            )
////        }
////        self.estimate = estimate
////        return estimate
////    }
////}
