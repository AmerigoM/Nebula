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
        
        // make api call
        nasaManager.fetchImage()
    }
    
    @IBAction func onShareImage(_ sender: UIButton) {
        let share = [nasaImage.image]
        let activityViewController = UIActivityViewController(activityItems: share as [Any], applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
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
