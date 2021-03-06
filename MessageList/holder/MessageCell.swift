

import UIKit

class MessageCell: UITableViewCell {
    
    // 文本消息和事件消息，传入 [type:link] 格式就能展现成链接，注意不能匹配 [haha]xx[xx:yy]
    private static let linkPattern = try! NSRegularExpression(pattern: "\\[[^\\[:]+:[^\\]]+\\]")
    
    private var isReady = false

    var configuration: MessageListConfiguration!
    var delegate: MessageListDelegate!
    var message: Message!
    
    var copySelector = #selector(InteractiveButton.onCopy)
    var shareSelector = #selector(InteractiveButton.onShare)
    var recallSelector = #selector(InteractiveButton.onRecall)
    var deleteSelector = #selector(InteractiveButton.onDelete)
    var menuAtions: [Selector]!
    
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    
    var count = 0
    
    var index = -1 {
        didSet {
            
            var topValue: CGFloat = 0
            var bottomValue: CGFloat = 0
            
            if index == 0 {
                topValue = configuration.paddingVertical
            }
            else {
                topValue = configuration.messageMarginTop
            }
            if index == count - 1 {
                bottomValue = -configuration.paddingVertical
            }
            
            if topConstraint.constant != topValue || bottomConstraint.constant != bottomValue {
                topConstraint.constant = topValue
                bottomConstraint.constant = bottomValue
                setNeedsLayout()
            }
            
        }
    }

    func bind(configuration: MessageListConfiguration, delegate: MessageListDelegate, message: Message, index: Int, count: Int) {
        
        self.message = message
        
        if !isReady {
            
            isReady = true
            
            self.configuration = configuration
            self.delegate = delegate
            
            selectionStyle = .none
            backgroundColor = .clear
            
            create()
            
        }
        
        self.count = count
        self.index = index
        
        update()
        
    }
    
    func create() {
        
    }
    
    func update() {
        
    }
    
    func createMenuItems() -> [UIMenuItem] {
        var items = [UIMenuItem]()
        
        if message.canCopy {
            items.append(
                UIMenuItem(
                    title: configuration.menuItemCopy,
                    action: copySelector
                )
            )
        }
        if message.canShare {
            items.append(
                UIMenuItem(
                    title: configuration.menuItemShare,
                    action: shareSelector
                )
            )
        }
        if message.canRecall {
            items.append(
                UIMenuItem(
                    title: configuration.menuItemRecall,
                    action: recallSelector
                )
            )
        }
        if message.canDelete {
            items.append(
                UIMenuItem(
                    title: configuration.menuItemDelete,
                    action: deleteSelector
                )
            )
        }

        return items
    }
    
    func addTimeView(_ timeView: InsetLabel) {
        
        timeView.numberOfLines = 1
        timeView.textAlignment = .center
        timeView.font = configuration.timeTextFont
        timeView.textColor = configuration.timeTextColor
        timeView.backgroundColor = configuration.timeBackgroundColor
        timeView.contentInsets = UIEdgeInsets(
            top: configuration.timePaddingVertical,
            left: configuration.timePaddingHorizontal,
            bottom: configuration.timePaddingVertical,
            right: configuration.timePaddingHorizontal
        )
        if configuration.timeBorderRadius > 0 {
            timeView.clipsToBounds = true
            timeView.layer.cornerRadius = configuration.timeBorderRadius
        }
        timeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeView)
        
    }
    
    func addAvatarView(_ avatarView: UIImageView) {
        
        if configuration.userAvatarBorderRadius > 0 {
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = configuration.userAvatarBorderRadius
        }
        if configuration.userAvatarBorderWidth > 0 {
            avatarView.layer.borderWidth = configuration.userAvatarBorderWidth
            avatarView.layer.borderColor = configuration.userAvatarBorderColor.cgColor
        }
        avatarView.backgroundColor = configuration.userAvatarBackgroundColor
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)
        
        addClickHandler(view: avatarView, selector: #selector(onUserAvatarClick))
        
    }
    
    func addNameView(_ nameView: UILabel) {
        
        nameView.numberOfLines = 1
        nameView.lineBreakMode = .byTruncatingTail
        nameView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func addSpinnerView(_ spinnerView: UIView) {
        
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinnerView)
        
    }
    
    func addFailureView(_ failureView: UIButton) {
        
        failureView.translatesAutoresizingMaskIntoConstraints = false
        failureView.setBackgroundImage(configuration.messageFailureIconNormal, for: .normal)
        failureView.setBackgroundImage(configuration.messageFailureIconPressed, for: .highlighted)
        contentView.addSubview(failureView)
        
        addClickHandler(view: failureView, selector: #selector(onFailureClick))
        
    }
    
    func formatLinks(text: String, font: UIFont, color: UIColor, lineSpacing: CGFloat) -> NSMutableAttributedString {
        
        let string = NSString(string: text)
        let length = string.length
        
        var links = [LinkToken]()
        var index = 0
        
        // 生成一段新的文本
        let newString = NSMutableString(string: "")
        
        let matches = MessageCell.linkPattern.matches(in: text, options: [], range: NSRange(location: 0, length: length))
        
        for item in matches {
            
            let location = item.range.location
            let length = item.range.length
            
            newString.append(string.substring(with: NSMakeRange(index, location - index)))
            
            // 去掉左右 [ ]
            let range = NSMakeRange(location + 1, length - 2)
            
            let rawText = string.substring(with: range)
            
            let separatorIndex = rawText.firstIndex(of: ":")!
            
            let linkText = String(rawText.prefix(upTo: separatorIndex))
            let labelText = String(rawText.suffix(from: separatorIndex).dropFirst())
            
            links.append(
                LinkToken(text: labelText, link: linkText, position: newString.length)
            )
            
            newString.append(labelText)
            
            index = location + length
            
        }
        
        if index < length {
            newString.append(string.substring(from: index))
        }
        
        let fullRange = NSRange(location: 0, length: newString.length)
        let attributedString = NSMutableAttributedString(string: newString as String)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: fullRange)
        
        for item in links {
            let range = NSMakeRange(item.position, NSString(string: item.text).length)
            attributedString.addAttribute(NSAttributedString.Key.link, value: item.link, range: range)
        }
        
        return attributedString
        
    }
    
    func updateTextSize(textView: UITextView, minWidth: CGFloat, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint) {

        let fixedWidth: CGFloat = 0
        var newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // 算出自适应后的宽度
        var width = newSize.width
        let maxWidth = getContentMaxWidth()
        
        if width > maxWidth {
            width = maxWidth
        }
        else if width < minWidth {
            width = minWidth
        }
        
        newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        widthConstraint.constant = width
        heightConstraint.constant = newSize.height
        
        setNeedsLayout()
        
    }
    
    func updateImageSize(width: Int, height: Int, widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint) {
        
        var imageWidth = CGFloat(width)
        var imageHeight = CGFloat(height)
        let imageRatio = imageWidth / imageHeight
        
        // 简单限制下最大和最小尺寸
        // 剩下的外部自由发挥
        let maxWidth = getContentMaxWidth()

        if imageWidth > maxWidth {
            imageWidth = maxWidth
            imageHeight = imageWidth / imageRatio
        }
        
        if imageHeight < configuration.userAvatarHeight {
            imageHeight = configuration.userAvatarHeight
            imageWidth = imageHeight * imageRatio
        }
        
        widthConstraint.constant = imageWidth
        heightConstraint.constant = imageHeight
        
        setNeedsLayout()
        
        
    }
    
    func showTimeView(timeView: UILabel, time: String, avatarTopConstraint: NSLayoutConstraint) {
        
        let oldValue = timeView.text != nil && timeView.text != ""
        let newValue = time != ""
        
        timeView.text = time
        timeView.sizeToFit()

        if newValue != oldValue {
            if newValue {
                avatarTopConstraint.constant = configuration.messageMarginTop
            }
            else {
                avatarTopConstraint.constant = 0
            }
            setNeedsLayout()
        }
        
    }
    
    func showStatusView(spinnerView: UIActivityIndicatorView, failureView: UIView) {
        
        if message.status == .sendIng {
            spinnerView.startAnimating()
        }
        else {
            spinnerView.stopAnimating()
        }
        
        failureView.isHidden = message.status != .sendFailure
        
    }
    
    func getContentMaxWidth() -> CGFloat {
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        return screenWidth - 2 * (configuration.messagePaddingHorizontal + configuration.userAvatarWidth) - configuration.leftUserNameMarginLeft - configuration.rightUserNameMarginRight
        
    }

    func addContentGesture(view: UIView) {
        
        view.isUserInteractionEnabled = true
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onContentClick))
        )

        view.addGestureRecognizer(
            UILongPressGestureRecognizer(target: self, action: #selector(onContentLongPress))
        )
        
    }

    func addClickHandler(view: UIView, selector: Selector) {
        
        view.isUserInteractionEnabled = true

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: selector)
        )
        
    }
    
    @objc func onUserAvatarClick() {
        delegate.messageListDidClickUserAvatar(message: message)
    }
    
    @objc func onUserNameClick() {
        delegate.messageListDidClickUserName(message: message)
    }
    
    @objc func onContentClick() {
        // 点击触发 UIMenuController 显示的 view
        // 不会自动隐藏 UIMenuController，
        // 因此这里强制隐藏一下
        let menuController = UIMenuController.shared
        if menuController.isMenuVisible {
            menuController.isMenuVisible = false
        }
        delegate.messageListDidClickContent(message: message)
    }
    
    @objc func onContentLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        let menuItems = createMenuItems()
        
        // 会触发两次，第一次是 began 第二次是 ended
        guard gesture.state == .began, menuItems.count > 0 else {
            return
        }
        
        // 确保视图都在
        guard let view = gesture.view, let superview = view.superview, view.canBecomeFirstResponder else {
            return
        }
        
        let menuController = UIMenuController.shared
        
        guard !menuController.isMenuVisible else {
            return
        }
        
        menuAtions = menuItems.map {
            return $0.action
        }
        
        view.becomeFirstResponder()
        
        menuController.menuItems = menuItems
        menuController.setTargetRect(view.frame, in: superview)
        
        // iOS 11 菜单第一次显示后会立即消失
        // 回到主线程操作后正常
        DispatchQueue.main.async {
            menuController.setMenuVisible(true, animated: true)
        }
        
    }
    
    @objc func onFailureClick() {
        delegate.messageListDidClickFailure(message: message)
    }
    
}
