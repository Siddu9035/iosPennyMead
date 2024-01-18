//
//  customPopUp.swift
//  PennyMead
//
//  Created by siddappa tambakad on 15/01/24.
//

import UIKit

//protocol CustomPopUpDelegate {
//    func handleNetworkButton(_ alert: CustomPopUp)
//}

class CustomPopUp: UIViewController {

    @IBOutlet var networkImage: UIImageView!
    @IBOutlet var networkErrorText: UILabel!
    @IBOutlet var networkButton: UIButton!
    @IBOutlet var backView: UIView!
    @IBOutlet var popUpView: UIView!
    
    var networkErrorTextTitle = ""
//    var delegate: CustomPopUpDelegate?
    
    init() {
        super.init(nibName: "CustomPopUp", bundle: Bundle(for: CustomPopUp.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    
    func show() {
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    func setupAlert() {
        networkErrorText.text = networkErrorTextTitle
        popUpView.layer.cornerRadius = 10
    }
    
    @IBAction func onPressNetworkButton(_ sender: UIButton) {
        self.dismiss(animated: true)
//        delegate?.handleNetworkButton(self)
    }
    
}
