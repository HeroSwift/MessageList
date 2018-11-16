
import UIKit

class ImageMessageCell: MessageCell {
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()
    
    // imageView 被占用了
    var photoView = UIImageView()
    
    var photoWidthConstraint: NSLayoutConstraint!
    var photoHeightConstraint: NSLayoutConstraint!
    
    var spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var failureView = UIButton()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create(configuration: MessageListConfiguration) {
        
        // 头像
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)
        
        // 昵称
        nameView.numberOfLines = 1
        nameView.translatesAutoresizingMaskIntoConstraints = false
        
        // 图片
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = configuration.imageMessageBorderRadius
        photoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoView)
        
        // spinner icon
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinnerView)
        
        // failure icon
        failureView.translatesAutoresizingMaskIntoConstraints = false
        failureView.setBackgroundImage(configuration.messageFailureIconNormal, for: .normal)
        failureView.setBackgroundImage(configuration.messageFailureIconPressed, for: .highlighted)
        contentView.addSubview(failureView)
        
        addClickHandler(view: contentView, selector: #selector(onMessageClick))
        addClickHandler(view: avatarView, selector: #selector(onUserAvatarClick))
        addClickHandler(view: photoView, selector: #selector(onContentClick))
        addClickHandler(view: failureView, selector: #selector(onFailureClick))
        addLongPressHandler(view: photoView, selector: #selector(onContentLongPress))
        
        photoWidthConstraint = NSLayoutConstraint(item: photoView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        photoHeightConstraint = NSLayoutConstraint(item: photoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        
        contentView.addConstraints([
            photoWidthConstraint,
            photoHeightConstraint
        ])
        
    }
    
    override func update(configuration: MessageListConfiguration) {
        
        let imageMessage = message as! ImageMessage
        
        let avatar = message.user.avatar
        if avatar != "" {
            configuration.loadImage(imageView: avatarView, url: avatar)
        }
        
        nameView.text = message.user.name
        nameView.sizeToFit()
        
        let url = imageMessage.url
        if url != "" {
            configuration.loadImage(imageView: photoView, url: url)
            photoWidthConstraint.constant = CGFloat(imageMessage.width)
            photoHeightConstraint.constant = CGFloat(imageMessage.height)
            setNeedsLayout()
        }
        
        if message.status == .sendIng {
            spinnerView.startAnimating()
        }
        else {
            spinnerView.stopAnimating()
        }
        
        failureView.isHidden = message.status != .sendFailure
        
    }
    
}
