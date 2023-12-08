// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Auth {
    /// E-mail
    internal static let emailTextField = L10n.tr("Localizable", "auth.email-text-field", fallback: "E-mail")
    /// Введите корректный email
    internal static let emailTextFieldError = L10n.tr("Localizable", "auth.email-text-field-error", fallback: "Введите корректный email")
    /// Пароль
    internal static let passwordTextField = L10n.tr("Localizable", "auth.password-text-field", fallback: "Пароль")
    /// Ошибка!
    internal static let passwordTextFieldError = L10n.tr("Localizable", "auth.password-text-field-error", fallback: "Ошибка!")
    /// Войти
    internal static let signInButton = L10n.tr("Localizable", "auth.sign-in-button", fallback: "Войти")
    /// Еще нет аккаунта?
    internal static let signUpButton = L10n.tr("Localizable", "auth.sign-up-button", fallback: "Еще нет аккаунта?")
    /// Поле должно быть заполнено
    internal static let textFieldError = L10n.tr("Localizable", "auth.text-field-error", fallback: "Поле должно быть заполнено")
    /// Авторизация
    internal static let title = L10n.tr("Localizable", "auth.title", fallback: "Авторизация")
  }
  internal enum EditItem {
    /// Удалить
    internal static let deleteButton = L10n.tr("Localizable", "edit-item.delete-button", fallback: "Удалить")
    /// Запись
    internal static let title = L10n.tr("Localizable", "edit-item.title", fallback: "Запись")
  }
  internal enum Empty {
    /// Новая запись
    internal static let emptyButton = L10n.tr("Localizable", "empty.empty-button", fallback: "Новая запись")
    /// Обновить
    internal static let emptyButtonError = L10n.tr("Localizable", "empty.empty-button-error", fallback: "Обновить")
    /// Пока здесь нет ни одной записи.
    /// Создайте новую!
    internal static let emptyLabel = L10n.tr("Localizable", "empty.empty-label", fallback: "Пока здесь нет ни одной записи.\nСоздайте новую!")
    /// Нет соединения
    internal static let emptyLabelNoConnection = L10n.tr("Localizable", "empty.empty-label-no-connection", fallback: "Нет соединения")
    /// Что-то пошло не так
    internal static let emptyLabelOtherError = L10n.tr("Localizable", "empty.empty-label-other-error", fallback: "Что-то пошло не так")
  }
  internal enum Main {
    /// Создать
    internal static let createButton = L10n.tr("Localizable", "main.create-button", fallback: "Создать")
    /// Новая запись
    internal static let emptyButton = L10n.tr("Localizable", "main.empty-button", fallback: "Новая запись")
    /// Пока здесь нет ни одной записи.
    /// Создайте новую!
    internal static let emptyLabel = L10n.tr("Localizable", "main.empty-label", fallback: "Пока здесь нет ни одной записи.\nСоздайте новую!")
    /// dd MMMM yyyy в HH:mm
    internal static let itemCellDateFormat = L10n.tr("Localizable", "main.item-cell-date-format", fallback: "dd MMMM yyyy в HH:mm")
    /// Дедлайн: 
    internal static let itemDeadline = L10n.tr("Localizable", "main.item-deadline", fallback: "Дедлайн: ")
    /// Профиль
    internal static let profileButton = L10n.tr("Localizable", "main.profile-button", fallback: "Профиль")
    /// Cписок дел
    internal static let title = L10n.tr("Localizable", "main.title", fallback: "Cписок дел")
  }
  internal enum NetworkError {
    /// Закрыть
    internal static let alertButton = L10n.tr("Localizable", "network-error.alert-button", fallback: "Закрыть")
    /// Ошибка!
    internal static let alertTitle = L10n.tr("Localizable", "network-error.alert-title", fallback: "Ошибка!")
    /// Упс! Что-то пошло не так. Неправильный ответ с сервера.
    internal static let wrongResponse = L10n.tr("Localizable", "network-error.wrong-response", fallback: "Упс! Что-то пошло не так. Неправильный ответ с сервера.")
    /// Упс! Что-то пошло не так. Неверный код статуса.
    internal static let wrongStatusCode = L10n.tr("Localizable", "network-error.wrong-status-code", fallback: "Упс! Что-то пошло не так. Неверный код статуса.")
    /// Упс! Что-то пошло не так. Неправильный URL.
    internal static let wrongUrl = L10n.tr("Localizable", "network-error.wrong-url", fallback: "Упс! Что-то пошло не так. Неправильный URL.")
  }
  internal enum NewItem {
    /// Дедлайн
    internal static let deadlineLabel = L10n.tr("Localizable", "new-item.deadline-label", fallback: "Дедлайн")
    /// Поле должно быть заполнено
    internal static let textFieldError = L10n.tr("Localizable", "new-item.text-field-error", fallback: "Поле должно быть заполнено")
    /// Описание
    internal static let textViewDescription = L10n.tr("Localizable", "new-item.text-view-description", fallback: "Описание")
    /// Что нужно сделать
    internal static let textViewTitleTask = L10n.tr("Localizable", "new-item.text-view-title-task", fallback: "Что нужно сделать")
  }
  internal enum SignUp {
    /// E-mail
    internal static let emailTextField = L10n.tr("Localizable", "sign-up.email-text-field", fallback: "E-mail")
    /// Введите корректный email
    internal static let emailTextFieldError = L10n.tr("Localizable", "sign-up.email-text-field-error", fallback: "Введите корректный email")
    /// Имя пользователя
    internal static let nameTextField = L10n.tr("Localizable", "sign-up.name-text-field", fallback: "Имя пользователя")
    /// Имя должно быть до 70 символов длиной
    internal static let nameTextFieldError = L10n.tr("Localizable", "sign-up.name-text-field-error", fallback: "Имя должно быть до 70 символов длиной")
    /// Пароль
    internal static let passwordTextField = L10n.tr("Localizable", "sign-up.password-text-field", fallback: "Пароль")
    /// Пароль должен быть до 256 символов
    internal static let passwordTextFieldError = L10n.tr("Localizable", "sign-up.password-text-field-error", fallback: "Пароль должен быть до 256 символов")
    /// Зарегистрироваться
    internal static let signUpButton = L10n.tr("Localizable", "sign-up.sign-up-button", fallback: "Зарегистрироваться")
    /// Поле должно быть заполнено
    internal static let textFieldError = L10n.tr("Localizable", "sign-up.text-field-error", fallback: "Поле должно быть заполнено")
    /// Регистрация
    internal static let title = L10n.tr("Localizable", "sign-up.title", fallback: "Регистрация")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
