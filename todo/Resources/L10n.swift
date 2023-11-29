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
        static let createButton = NSLocalizedString("main.create-button", comment: "")
        static let itemDeadline = NSLocalizedString("main.item-deadline", comment: "")
        static let itemCellDateFormate = NSLocalizedString("main.item-cell-date-format", comment: "")
    }

    enum Empty {
        static let emptyLabel = NSLocalizedString("empty.empty-label", comment: "")
        static let emptyButton = NSLocalizedString("empty.empty-button", comment: "")
        static let emptyLabelNoConnection = NSLocalizedString("empty.empty-label-no-connection", comment: "")
        static let emptyLabelOtherError = NSLocalizedString("empty.empty-label-other-error", comment: "")
        static let emptyButtonError = NSLocalizedString("empty.empty-button-error", comment: "")
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

    enum NewItem {
        static let deadlineLabel = NSLocalizedString("new-item.deadline-label", comment: "")
        static let textViewTitleTask = NSLocalizedString("new-item.text-view-title-task", comment: "")
        static let textViewDescription = NSLocalizedString("new-item.text-view-description", comment: "")
        static let textFieldError = NSLocalizedString("new-item.text-field-error", comment: "")
    }
}
