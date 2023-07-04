//
//  Bridge.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 26/06/23.
//

import Foundation
import UIKit
import WebKit

protocol FrankieOneDelegate: AnyObject {
    func getJSFunction(function: String)
}

class FrankieOneViewController: UIViewController {
    
    var webView: WKWebView!
    var webAppInterface: WebAppInterface!
    private let ACTION_CREATE_ENTITY = FFVCConst.createEntity
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = FFVCConst.title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupWebView()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        webAppInterface = WebAppInterface(delegate: self, viewModel: FrankieOneViewModel())
        configuration.userContentController.add(webAppInterface, name: FFVCConst.performAction)
        configuration.userContentController.add(webAppInterface, name: FFVCConst.showToast)
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.minimumFontSize = 40
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.upgradeKnownHostsToHTTPS = true
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: configuration)
        webView.autoresizingMask = [.flexibleHeight]
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = URLGenerator.userAgent
        webView.allowsLinkPreview = true
        view.addSubview(webView)
        
        if let url = URL(string: URLGenerator.webURL) {
            let myURLRequest = URLRequest(url: url)
            webView.load(myURLRequest)
        }
    }
    
    class func instantiate() -> UIViewController {
        let vc = UIStoryboard.home.instanceOf(viewController: FrankieOneViewController.self)!
        return vc
    }
}
extension FrankieOneViewController: FrankieOneDelegate {
    func getJSFunction(function: String) {
        webView.evaluateJavaScript(function) { (result, error) in
            if let error = error {
                Toast.showErrorMessage("JavaScript evaluation error: \(error)")
            } else if let result = result {
                Toast.showErrorMessage("JavaScript evaluation result: \(result)")
            }
        }
    }
}
extension FrankieOneViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let userAgent = webView.value(forKey: "userAgent") as? String
        print("User Agent: \(userAgent ?? "")")
        debugPrint("WebView didFinish navigation")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("WebView didFail navigation: \(error)")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    private func requestMediaCapturePermission(for webView: WKWebView, origin: String, initiatedByFrame frame: WKFrameInfo?, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
}

extension FrankieOneViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: FFVCConst.ok, style: .default, handler: { _ in
            completionHandler()
        }))
        present(alertController, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        debugPrint(message)
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: FFVCConst.ok, style: .default, handler: { _ in
            completionHandler(true)
        }))
        present(alertController, animated: true, completion: nil)
        
    }
    
}
struct FFVCConst {
    static let createEntity = "CREATE_ENTITY"
    static let title = "Frankione WebPage"
    static let performAction =  "performAction"
    static let showToast = "showToast"
    static let ok = "OK"
}
