import StateSpace

public protocol EstimateReadable: Estimatable {
    var estimate: Estimate { get }
}

public protocol EstimateReadWritable: EstimateReadable {
    var estimate: Estimate { get set }
}
