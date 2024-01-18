//
//  ViewController.swift
//  PennyMead
//
//  Created by siddappa tambakad on 10/01/24.
//

import UIKit

class ViewController: UIViewController {
    
   
    
    
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var midButton: UIButton!
    @IBOutlet var secondLastButton: UIButton!
    @IBOutlet var lastButton: UIButton!
    @IBOutlet var forWardButton: UIButton!
    @IBOutlet var backWardButton: UIButton!
    
    
    var totalPageNumber = 5
    var currentPage = 1
    
    var collectibleManager = CollectiblesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectibleManager.delegate = self
//        collectibleManager.getCollectibles(with: "newlyUpdated", page: 1)
//        // Do any additional setup after loading the view.
        updatePaginationUi(with: currentPage)
    }
    
//    func didUpdateTheCollectibles(_ collectibles: [CollectibleItem]) {
//        print(collectibles)
//    }
//
//    func didUpdateTotalPages(_ totalPages: Int) {
//        totalPageNumber = totalPages
//        updatePaginationUi(with: currentPage)
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
    
    func updatePaginationUi(with currentPage: Int) {
//        DispatchQueue.main.async { [self] in
        let halfTotalPageNumber = Int(round(Double(totalPageNumber) / 2.0))
        if totalPageNumber<6{
            secondButton.isHidden = totalPageNumber==1 ? true : false
            midButton.isHidden = totalPageNumber<3 ? true : false
            secondLastButton.isHidden = totalPageNumber<4 ? true : false
            lastButton.isHidden = totalPageNumber<5 ? true : false
            firstButton.setTitle("1", for: .normal)
            secondButton.setTitle("2", for: .normal)
            midButton.setTitle("3", for: .normal)
            secondLastButton.setTitle("4", for: .normal)
            lastButton.setTitle("5", for: .normal)
            firstButton.backgroundColor = currentPage == 1 ? .red : .white
            firstButton.setTitleColor(currentPage == 1 ? .white : .black, for: .normal)
            secondButton.backgroundColor = currentPage == 2 ? .red : .white
            midButton.backgroundColor = currentPage == 3 ? .red : .white
            secondLastButton.backgroundColor = currentPage == 4 ? .red : .white
            lastButton.backgroundColor = currentPage == 5 ? .red : .white
        }
        else if currentPage <= halfTotalPageNumber {
                // Display pages in the first half
                firstButton.setTitle("\(currentPage)", for: .normal)
                self.currentPage = currentPage
                firstButton.backgroundColor = UIColor.red
                lastButton.backgroundColor = UIColor.white
                secondButton.setTitle("\(currentPage + 1)", for: .normal)
                midButton.isHidden = false
                secondLastButton.setTitle("\(totalPageNumber - 1)", for: .normal)
                lastButton.setTitle("\(totalPageNumber)", for: .normal)
            } else {
                // Display pages in the second half
                lastButton.setTitle("\(currentPage)", for: .normal)
                lastButton.backgroundColor = UIColor.red
                firstButton.backgroundColor = UIColor.white
                secondLastButton.setTitle("\(currentPage - 1)", for: .normal)
                midButton.isHidden = false
                firstButton.setTitle("1", for: .normal)
                secondButton.setTitle("2", for: .normal)
            }
        }
//    }
        
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let title = sender.currentTitle, let newPage = Int(title) {
            currentPage = newPage
            updatePaginationUi(with: newPage)
        } else {
            print("Button tapped without a valid title.")
        }
    }
    
    @IBAction func onPressBackward(_ sender: UIButton) {
        if currentPage > 1 {
            currentPage -= 1
            updatePaginationUi(with: currentPage)
        }
        
    }
    
    @IBAction func onPressForwardButton(_ sender: UIButton) {
        if currentPage < totalPageNumber {
            currentPage += 1
            updatePaginationUi(with: currentPage)
        }
        
    }
    
}
