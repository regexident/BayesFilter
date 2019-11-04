public struct MultiModal<Model, Value>
where
    Model: Hashable
{
    public let model: Model
    public let value: Value

    public init(model: Model, value: Value) {
        self.model = model
        self.value = value
    }
}
