
# FrankiOne iOS

This project is a small application that allows users to verify documents using a web view. It incorporates document picture capture and biometric (face detection) verification to ensure the authenticity of the documents.

The application consists of the following components:

### FrankieOneViewController

`FrankieOneViewController` is a view controller responsible for displaying a web view and handling its interactions. It utilizes the **WKWebView** to load and present web content.


#### Properties

* `webView: WKWebView!`: The web view used to display the web content.
* `webAppInterface: WebAppInterface!`: An interface between the web view and the view controller.

#### Methods

* `viewDidLoad()`: Called when the view controller's view is loaded into memory. It sets up the web view and configures its properties.

* `setupWebView()`: Sets up the configuration and properties of the web view. 

* `instantiate() -> UIViewController`: Static method to instantiate a `FrankieOneViewController` object.


### FrankieOneDelegate Conformance

`FrankieOneViewController` conforms to the `FrankieOneDelegate` protocol and implements the `getJSFunction(function: String)` method. This method is called when a JavaScript function needs to be executed in the web view. It evaluates the JavaScript function using the web view's `evaluateJavaScript(_:completionHandler:)` method.

#### Methods

* `createIntity(payload: [String: Any], completion: @escaping ((String?) -> Void))`: Sends a request to create an entity with the provided payload. It handles the network request and calls the completion handler with the result.

* `generateUploadDataProvider(payload: [String: Any]) -> Data`: Generates the data for uploading the payload as JSON data.

* `convertDataToDictionary(_ data: Data) -> [String: Any]?`: Converts the data received from a network response to a dictionary.

### WebAppInterface Class

`WebAppInterface` is a class that serves as an interface between the web view and the view controller. It handles messages received from JavaScript and performs corresponding actions.

#### Properties

* `delegate: FrankieOneDelegate?`: The delegate to handle JavaScript function calls.

* `viewModel: FrankieOneViewModel`: The view model used for performing business logic.

#### Methods

* `userContentController(_:didReceive:)`: Called when the web view receives a message from JavaScript. It processes the message and calls the appropriate delegate method.

### Communications

The application support two way communication. In our application we are listening website callbacks and based on that app response back to the website.

#### Website To App

In class `WebAppInterface` we have method `func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)` that receives data from the websites.
To receive call backs from the website we need to also configure listeners in the webview configuration. These includes
```swift
configuration.userContentController.add(webAppInterface, name: "perfromAction")
configuration.userContentController.add(webAppInterface, name: "showToast") 
```

#### App To Website
In class `WebAppInterface` we have a callback method named `func actionCallback(action: String, data: String)` that receives the processed response from website and then creating a JavaScript function that going to call by the app webView to the website. These includes.
```Swift
func actionCallback(action: String, data: String) {
    let jsFunction = "actionCallback('\(action)', '\(data)');"
    self.delegate?.getJSFunction(function: jsFunction)
}

func getJSFunction(function: String) {
    webView.evaluateJavaScript(function) { (result, error) in
        if let error = error {
            Toast.showErrorMessage("JavaScript evaluation error: \(error)")
        } else if let result = result {
            Toast.showToastMessage("JavaScript evaluation result: \(result)")
        }
    }
}
```
### Permissions
To use system features like camera, photos and media, then in that case we need to provide permissions and usage description for that. To do that we need to add keys in the app info.plist that are following.

* Privacy - Camera Usage Description
* Privacy - Photo Library Usage Description
* Privacy - Media Library Usage Description

### User Agent Modification
To let the app have access to the biometric SDK we need to modify the App user agent by concatenating it with chrome and safari user agent. These includes,

```Swift
webView.customUserAgent = (webView.value(forKey: FFVCConst.userAgent) as? String ?? "").getUpdatedUserAgent()

func getUpdatedUserAgent()-> String {
    let inputString = self
    let replacementString = URLGenerator.userAgent
    let regexPattern = "Mobile/[0-9A-Za-z]+"
    let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
    let modifiedString = regex.stringByReplacingMatches(in: inputString, options: [], range: NSRange(location: 0, length: inputString.count), withTemplate: replacementString)
    return modifiedString
}
```

### How to Use

To use the document verification project, follow these steps:

    1. Build and run the project on a real device (Simulator will not work).
    2. The app will launch and display the web view.
    3. Capture a picture of the document using the provided functionality.
    4. Perform biometric (face detection) verification to ensure document authenticity.
    5. The web view will display the result of the verification process.
