import Split

@objc public class YoSplit: NSObject {
    @objc public static func getString() -> String {
        return "YoSplit"
    }

    @objc public static func getClient() -> SplitClient? {
        // Create a Split config
        let config = SplitClientConfig()

        let key: Key = Key(matchingKey: "CUSTOMER_ID")
        let apiKey: String = "API_KEY"

        let factoryBuilder = DefaultSplitFactoryBuilder()
        factoryBuilder.setApiKey(apiKey).setKey(key).setConfig(config)
        let factory = factoryBuilder.build()
        let client = factory?.client

        return client
    }
}
