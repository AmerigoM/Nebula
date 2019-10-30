//
//  ViewController.swift
//  Nebula
//
//  Created by Amerigo Mancino on 30/10/2019.
//  Copyright © 2019 Amerigo Mancino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var nasaImage: UIImageView!
    
    var nasaManager = NasaManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nasaManager.delegate = self
        
        nasaManager.fetchImage()
    }

    @IBAction func onDownloadImage(_ sender: UIButton) {
    }
    
    @IBAction func onShareImage(_ sender: UIButton) {
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
