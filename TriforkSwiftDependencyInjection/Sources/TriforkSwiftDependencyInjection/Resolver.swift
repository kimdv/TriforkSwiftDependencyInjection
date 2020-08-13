import Foundation

/// Resolves the dependencies based on type or key.
public class Resolver {
    
    /// Shared singleton instancce
    public static let shared = Resolver()
    
    /// Allows you to register a new factory on the a key, which already had registered a facotry.
    public var allowOverride: Bool = false
    
    private var factories: [String: () -> Any] = [:]
    
    private init() { }
    
    
    /// Register instance for protocol type or key
    /// The key is optional and can be useful to register multiple instances of the same type. The key can be used in the `Inject` property wrapper.
    public func register<T>(_ proto: T.Type, key: String? = nil, _ factory: @escaping () -> T) {
        let k = key ?? typeKey(proto)
        if self.factories[k] != nil && !self.allowOverride {
            fatalError("You are overriding the factory for \(k). It already contains a value. Enable `allowOverride` property to allow this behaviour.")
        }
        self.factories[k] = factory
    }
    
    /// Resolves the instance from the `Inject` property wrapper.
    internal func resolve<T>(key: String? = nil) -> T {
        let component: T? = self.factories[key ?? typeKey(T.self)]?() as? T
        guard let c = component else {
            fatalError("\(key ?? typeKey(T.self))) could not be resolved. Did you forget to call the register-function?")
        }
        return c
    }
    
    private func typeKey<T>(_ type: T.Type) -> String {
        String(describing: type)
    }
}
