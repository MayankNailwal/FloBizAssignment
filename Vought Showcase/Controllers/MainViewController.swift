//
//  ViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentIntermediateViewController()
    }
    
    private func presentIntermediateViewController() {
        let intermediateViewController = IntermediateViewController()
        intermediateViewController.modalPresentationStyle = .fullScreen
        present(intermediateViewController, animated: true, completion: nil)
    }
}

