import UIKit

 private let Str = Rsc.Error.ErrorView.self // swiftlint:disable:this identifier_name

 protocol ErrorDisplayableViewController: AnyObject {
    func showError(_ animated: Bool, completion: (() -> Void)?)
    func dismissError(animated: Bool, completion: (() -> Void)?)
 }

 extension ErrorDisplayableViewController {
    func showError(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        showError(animated, completion: completion)
    }
 }

 extension ErrorDisplayableViewController where Self: UIViewController {
    func showError(_ animated: Bool, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "", message: Str.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Str.Button.title, style: .default, handler: nil))
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        rootViewController?.present(alert, animated: animated, completion: completion)
    }

    func dismissError(animated: Bool, completion: (() -> Void)?) {
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        rootViewController?.dismiss(animated: animated, completion: completion)
    }
 }
