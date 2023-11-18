import Foundation

enum L10n {
    enum Auth {
        static let title = NSLocalizedString("auth.title", comment: "")
        static let signInButton = NSLocalizedString("auth.sign-in-button", comment: "")
        static let signUpButton = NSLocalizedString("auth.sign-up-button", comment: "")
        static let emailTextField = NSLocalizedString("auth.email-text-field", comment: "")
        static let passwordTextField = NSLocalizedString("auth.password-text-field", comment: "")
        static let textFieldError = NSLocalizedString("auth.text-field-error", comment: "")
        static let emailTextFieldError = NSLocalizedString("auth.email-text-field-error", comment: "")
        static let passwordTextFieldError = NSLocalizedString("auth.password-text-field-error", comment: "")
    }

    enum Main {
        static let profileButton = NSLocalizedString("main.profile-button", comment: "")
        static let emptyLabel = NSLocalizedString("main.empty-label", comment: "")
        static let emptyButton = NSLocalizedString("main.empty-button", comment: "")
        static let title = NSLocalizedString("main.title", comment: "")
    }

    enum SignUp {
        static let title = NSLocalizedString("sign-up.title", comment: "")
        static let signUpButton = NSLocalizedString("sign-up.sign-up-button", comment: "")
        static let nameTextField = NSLocalizedString("sign-up.name-text-field", comment: "")
        static let emailTextField = NSLocalizedString("sign-up.email-text-field", comment: "")
        static let passwordTextField = NSLocalizedString("sign-up.password-text-field", comment: "")
        static let textFieldError = NSLocalizedString("sign-up.text-field-error", comment: "")
        static let nameTextFieldError = NSLocalizedString("sign-up.name-text-field-error", comment: "")
        static let emailTextFieldError = NSLocalizedString("sign-up.email-text-field-error", comment: "")
        static let passwordTextFieldError = NSLocalizedString("sign-up.password-text-field-error", comment: "")
    }
}
