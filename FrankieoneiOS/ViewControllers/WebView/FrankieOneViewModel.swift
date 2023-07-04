//
//  FrankieOneViewModel.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 26/06/23.
//

import Foundation

final class FrankieOneViewModel {
    func createIntity(payload: [String: Any], completion: @escaping ((String?)-> Void)) {
        guard let url = URL(string: URLGenerator.createEntityURL) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = FrankieOneVMConst.post
        request.setValue(URLGenerator.frankiCustomerID, forHTTPHeaderField: FrankieOneVMConst.customerID)
        request.setValue(URLGenerator.apiKeyValue, forHTTPHeaderField: FrankieOneVMConst.apiKey)
        request.setValue(URLGenerator.customerChildID, forHTTPHeaderField: FrankieOneVMConst.customerChildID)
        request.setValue(FrankieOneVMConst.applicationJson, forHTTPHeaderField: FrankieOneVMConst.contentType)
        
        let uploadDataProvider = generateUploadDataProvider(payload: payload)
        let task = URLSession.shared.uploadTask(with: request, from: uploadDataProvider) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            
            if let error = error {
                Toast.showErrorMessage("Create Entity failed \(error)")
                completion(nil)
                return
            }
            
            if let data = data {
                guard let map = convertDataToDictionary(data) else {return}
                guard let json = try? JSONSerialization.data(withJSONObject: map, options: []) else { return }
                guard let res = String(data: json, encoding: String.Encoding.utf8) else {return}
                debugPrint("Create Entity successful \(res)")
                completion(res)
            } else {
                completion(nil)
            }
        }
        task.resume()
        
    }
    
    private func generateUploadDataProvider(payload: [String: Any]) -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            return jsonData
        } catch {
            Toast.showErrorMessage("Error generating upload data provider: \(error)")
        }
        return Data()
    }
    private func convertStringToBytes(payload: String) -> [UInt8] {
        return Array(payload.utf8)
    }
    func convertDataToDictionary(_ data: Data) -> [String: Any]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = jsonObject as? [String: Any] {
                return dictionary
            }
        } catch {
            Toast.showErrorMessage("Error converting data to dictionary: \(error)")
        }
        return nil
    }
    
}

struct FrankieOneVMConst {
    static let post = "POST"
    static let customerID = "X-Frankie-CustomerId"
    static let apiKey = "api_key"
    static let customerChildID = "X-Frankie-CustomerChildID"
    static let contentType = "Content-Type"
    static let applicationJson = "application/json"
}
