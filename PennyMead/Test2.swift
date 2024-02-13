import UIKit

class Test2: UIViewController, CustomDropdownDelegate {
    
    let viewtag = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        // Configure UIScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -600) // Added bottom constraint to make scrollView fill the remaining space
        ])
        // Create a contentView for the UIScrollView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        // Configure contentView constraints
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor) // Content height same as scrollview height
        ])
        // Add buttons with UIViews for each button
        var previousView: UIView?
        for index in 0..<4 {
            // Create a UIView to contain button and view
            let buttonContainer = UIView()
            buttonContainer.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(buttonContainer)
            // Configure buttonContainer constraints
            NSLayoutConstraint.activate([
                buttonContainer.widthAnchor.constraint(equalToConstant: 200), // Width equal to scrollview width minus 40 for left and right margins
                buttonContainer.heightAnchor.constraint(equalToConstant: 40), // Height equal to scrollview height minus 40 for top and bottom margins
                buttonContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                buttonContainer.leadingAnchor.constraint(equalTo: previousView?.trailingAnchor ?? contentView.leadingAnchor, constant: 20) // Leading constraint to previous buttonContainer or contentView
            ])
            // Add button to buttonContainer
            let button = UIButton(type: .system)
            button.setTitle("Button \(index + 1)", for: .normal)
            button.backgroundColor = .blue
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonContainer.addSubview(button)
            // Configure button constraints
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 20),
                button.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 5),
                button.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: -5),
                button.widthAnchor.constraint(equalToConstant: 200) // Set a fixed width for the button
            ])
            button.addTarget(self, action: #selector(clickOnButton(_:)), for: .touchUpInside)
            // Add UIView below the button
            let viewBelowButton = UIView()
            viewBelowButton.backgroundColor = .red
            viewBelowButton.tag = viewtag
            viewBelowButton.translatesAutoresizingMaskIntoConstraints = false
            buttonContainer.addSubview(viewBelowButton)
            // Configure viewBelowButton constraints
            NSLayoutConstraint.activate([
                viewBelowButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
                viewBelowButton.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                viewBelowButton.heightAnchor.constraint(equalToConstant: 200),
                viewBelowButton.widthAnchor.constraint(equalToConstant: 100) // Set a fixed width for the view below the button
            ])
            let buttonInsideView = UIButton(type: .system)
            buttonInsideView.backgroundColor = .cyan
            buttonInsideView.setTitle("Hi", for: .normal)
            buttonInsideView.translatesAutoresizingMaskIntoConstraints = false
            viewBelowButton.addSubview(buttonInsideView)
            
            NSLayoutConstraint.activate([
                buttonInsideView.centerXAnchor.constraint(equalTo: viewBelowButton.centerXAnchor),
                buttonInsideView.centerYAnchor.constraint(equalTo: viewBelowButton.centerYAnchor),
                buttonInsideView.widthAnchor.constraint(equalToConstant: 150),
                buttonInsideView.heightAnchor.constraint(equalToConstant: 30)
            ])
            buttonInsideView.addTarget(self, action: #selector(onPressButtonInsideView(_:)), for: .touchUpInside)
            viewBelowButton.isHidden = true
            // Set previousView for next iteration
            previousView = buttonContainer
        }
        // Activate constraint to pin last buttonContainer to contentView's trailing anchor
        if let lastButtonContainer = previousView {
            NSLayoutConstraint.activate([
                lastButtonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20) // Trailing constraint to contentView
            ])
        }
    }
    @objc func clickOnButton(_ sender: UIButton) {
        if let viewBelowButton = sender.superview?.viewWithTag(viewtag) {
            viewBelowButton.isHidden = !viewBelowButton.isHidden // Toggle the hidden state
        }
    }
    
    @objc func onPressButtonInsideView(_ sender: UIButton) {
       print("isClicked")
    }
    func didSelectOption(option: String) {
        print(option)
    }
}
