import StateSpace

public protocol EstimateAccessible: Estimatable {
    var estimate: Estimate { get set }
}
