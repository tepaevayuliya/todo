////
////  ItemCell.swift
////  todo
////
////  Created by Юлия Тепаева on 19.11.2023.
////
//
//import UIKit
//
//class ItemCell: UICollectionViewCell {
//    struct Style {
//        var cornerRadius: CGFloat = 0
//        var font: UIFont = .systemFont(ofSize: 16)
//        var insets: CGFloat = 0
//        var height: CGFloat = 56
//        var bgColor: UIColor = .clear
//        var highlightedBgColor : UIColor = .clear
//
//        var titleColor: UIColor = .clear
//        var highlightedTitleColor : UIColor = .clear
//    }
//
//    var style: Style = Style() {
//        didSet {
//            configureStyle()
//        }
//    }
//
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        setup()
////    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    override var intrinsicContentSize: CGSize {
//        CGSize(width: super.intrinsicContentSize.width + style.insets, height: style.height)
//    }
//
//    private func setup() {
////        configuration = .plain()
////        configuration?.titleLineBreakMode = .byTruncatingTail
////        configuration?.baseBackgroundColor = nil
////        configuration?.cornerStyle = .fixed
//    }
//
//    private func configureStyle() {
//        backgroundConfiguration?.cornerRadius = style.cornerRadius
//        backgroundConfiguration?.backgroundColor = style.bgColor
//
//        configurationUpdateHandler = { [weak self] cell in
//            guard let self else {
//                return
//            }
//
////            cell.backgroundConfiguration = .clear()
//
//            var config = cell.backgroundConfiguration
//            let (titleColor, bgColor) = colors(for: cell)
//            config?.backgroundColor = bgColor
//            config?.customView?.largeContentTitle = UIConfigurationTextAttributesTransformer { [weak self] attr in
//                var newAttr = attr
//                newAttr.foregroundColor = titleColor
//                newAttr.font = self?.style.font
//                return newAttr
//            }
//            cell.tintColor = titleColor
//            cell.alpha = cell.isEnabled ? 1 : 0.5
//            cell.configuration = config
//        }
//    }
//
//    private func colors(for cell: UICollectionViewCell) -> (fgColor: UIColor, bgColor: UIColor) {
//        if cell.isHighlighted {
//            return (fgColor: style.highlightedTitleColor, bgColor: style.highlightedBgColor)
//        }
//        return (fgColor: style.titleColor, bgColor: style.bgColor)
//    }
//}
