//
//  WebAppInterface.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 27/06/23.
//

import Foundation
import WebKit
import UIKit

class WebAppInterface: NSObject, WKScriptMessageHandler {
    weak var delegate: FrankieOneDelegate?
    private let ACTION_CREATE_ENTITY = WebAppConst.createEntity
    private let viewModel : FrankieOneViewModel
    init(delegate: FrankieOneDelegate, viewModel: FrankieOneViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? [String: Any] {
            guard let data = body[WebAppConst.data] as? [String: Any] else {return}
            guard let action = body[WebAppConst.action] as? String else { return }
            performAction(action: action, data: data)
        } else  {
            self.showToast(message: message.body as? String ?? "")
        }
        debugPrint(message.body)
    }
    
    func actionCallback(action: String, data: String) {
        let jsFunction = "\(WebAppConst.actionCallback)('\(action)', '\(data)');"
        self.delegate?.getJSFunction(function: jsFunction)
    }
    func performAction(action: String, data: [String: Any]) {
        switch action {
        case ACTION_CREATE_ENTITY:
            viewModel.createIntity(payload: data) {[weak self] result in
                DispatchQueue.main.async {[weak self] in
                    guard let self else {return}
                    self.actionCallback(action: self.ACTION_CREATE_ENTITY, data: result ?? "")
                }
            }
        default:
            break
        }
    }
    func showToast(message: String) {
        Toast.showToastMessage(message: message)
    }
}
struct WebAppConst {
    static let createEntity = "CREATE_ENTITY"
    static let data = "data"
    static let action = "action"
    static let actionCallback = "actionCallback"
}
