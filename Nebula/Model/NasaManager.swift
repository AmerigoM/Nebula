//
//  NasaManager.swift
//  Nebula
//
//  Created by Amerigo Mancino on 30/10/2019.
//  Copyright © 2019 Amerigo Mancino. All rights reserved.
//

import Foundation

protocol NasaManagerDelegate {
    func didUpdateNasaData(_ nasaManager: NasaManager, nasaImageData: NasaModel)
    func didFailWithError(error: Error)
}

class NasaManager {
    
    let baseUrl = "https://api.nasa.gov/planetary/apod"
    
    var delegate: NasaManagerDelegate?
    
    // retrieve the nasa data
    func fetchImage(with key: String) {
        let completeUrl = "\(baseUrl)?api_key=\(key)"
        performRequest(with: completeUrl)
    }
    
    // perform the network request
    func performRequest(with url: String) {
        // 1. create the URL
        if let safeUrl = URL(string: url) {
            // 2. create a session
            let session = URLSession(configuration: .default)
            // 3. give session a task
            let task = session.dataTask(with: safeUrl, completionHandler: handle(data:response:error:))
            // 4. resume the task
            task.resume()
        }
    }
    
    // handle the network response
    func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
        if error != nil {
            // error
            self.delegate?.didFailWithError(error: error!)
            return
        }
        
        // no errors
        if let safeData = data {
            if let nasaImageData = parseJSON(safeData) {
                // return data back
                self.delegate?.didUpdateNasaData(self, nasaImageData: nasaImageData)
            }
        }
    }
    
    // parse the json according to the model
    func parseJSON(_ nasaData: Data) -> NasaModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(NasaData.self, from: nasaData)
            let title = decodedData.title
            let image = decodedData.url
            
            return NasaModel(title: title, image: image)
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
