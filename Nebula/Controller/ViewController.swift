//
//  ViewController.swift
//  Nebula
//
//  Created by Amerigo Mancino on 30/10/2019.
//  Copyright © 2019 Amerigo Mancino. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var nasaImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    var nasaManager = NasaManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set us as the delegate
        nasaManager.delegate = self
        
        // modify the button appearances
        shareButton.layer.cornerRadius = 8
        
        // retrieve api key
        let key = valueForAPIKey(named: "ApiSecret")
        
        // make api call
        nasaManager.fetchImage(with: key)
    }
    
    // user tapped on share button
    @IBAction func onShareImage(_ sender: UIButton) {
        let share = [nasaImage.image]
        let activityViewController = UIActivityViewController(activityItems: share as [Any], applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // helper method to retrieve api key from hidden file
    func valueForAPIKey(named keyname: String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
}

// MARK: - NasaManagerDelegate extension

extension ViewController: NasaManagerDelegate {
    
    func didUpdateNasaData(_ nasaManager: NasaManager, nasaImageData: NasaModel) {
        
        if let url = URL(string: nasaImageData.image) {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.nasaImage.image = UIImage(data: data)
                }
            } catch {
                print("error")
            }
        }
        
        DispatchQueue.main.async {
            self.imageTitle.text = nasaImageData.title
        }
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
}
