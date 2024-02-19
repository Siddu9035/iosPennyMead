import Foundation
import UIKit

var activityIndicator: UIActivityIndicatorView?

extension UIViewController {
    func showIndicator() {
        DispatchQueue.main.async { [self] in
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.color = UIColor(named: "borderColor")
            activityIndicator?.layer.backgroundColor =  UIColor.lightGray.withAlphaComponent(0.75).cgColor
            activityIndicator?.center = view.center
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(activityIndicator!)
            
            NSLayoutConstraint.activate([
                activityIndicator!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                activityIndicator!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                activityIndicator!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                activityIndicator!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
            startLoading()
        }
    }
    func startLoading() {
        activityIndicator?.startAnimating()
    }
    func stopLoading() {
        DispatchQueue.main.async {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
    }
}
