import UIKit

class TestingViewController: UIViewController, DropdownMenuDelegate {

    let dropdownMenu = DropdownMenu(options: ["Option 1", "Option 2", "Option 3"])

    override func viewDidLoad() {
        super.viewDidLoad()

        dropdownMenu.delegate = self

        // Add dropdownMenu to your view hierarchy and set constraints
        // ...

        // Additional setup as needed
    }

    // Implement the DropdownMenuDelegate method
    func didSelectOption(_ option: String) {
        print("Selected option: \(option)")
        // Handle the selected option as needed
    }

    // Handle a trigger to open/close the dropdown menu
    @IBAction func toggleDropdownMenu() {
        dropdownMenu.toggleMenu()
    }
}
