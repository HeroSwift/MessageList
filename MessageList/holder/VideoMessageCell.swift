
import UIKit

class VideoMessageCell: MessageCell {
    
    var timeView = InsetLabel()
    
    var avatarView = UIImageView()
    
    var nameView = UILabel()
    
    var thumbnailView = UIImageView()
    
    var thumbnailWidthConstraint: NSLayoutConstraint!
    var thumbnailHeightConstraint: NSLayoutConstraint!
    var avatarTopConstraint: NSLayoutConstraint!
    
    var playView = UIImageView()
    
    var durationView = UILabel()
    
    var spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var failureView = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create(configuration: MessageListConfiguration) {
        
        // 时间
        timeView.isHidden = true
        timeView.numberOfLines = 1
        timeView.textAlignment = .center
        timeView.font = configuration.timeTextFont
        timeView.textColor = configuration.timeTextColor
        timeView.backgroundColor = configuration.timeBackgroundColor
        timeView.contentInsets = UIEdgeInsetsMake(
            configuration.timePaddingVertical,
            configuration.timePaddingHorizontal,
            configuration.timePaddingVertical,
            configuration.timePaddingHorizontal
        )
        if configuration.timeBorderRadius > 0 {
            timeView.clipsToBounds = true
            timeView.layer.cornerRadius = configuration.timeBorderRadius
        }
        timeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeView)
        
        // 头像
        if configuration.userAvatarBorderRadius > 0 {
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = configuration.userAvatarBorderRadius
        }
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)
        
        // 昵称
        nameView.numberOfLines = 1
        nameView.translatesAutoresizingMaskIntoConstraints = false
        
        // 视频缩略图
        thumbnailView.clipsToBounds = true
        thumbnailView.layer.cornerRadius = configuration.videoMessageBorderRadius
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailView)
        
        // 播放按钮
        playView.image = configuration.videoMessagePlayImage
        playView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playView)
        
        // 视频时长
        durationView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationView)
        
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
        addClickHandler(view: thumbnailView, selector: #selector(onContentClick))
        addClickHandler(view: failureView, selector: #selector(onFailureClick))
        addLongPressHandler(view: thumbnailView, selector: #selector(onContentLongPress))
        
        thumbnailWidthConstraint = NSLayoutConstraint(item: thumbnailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        thumbnailHeightConstraint = NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        avatarTopConstraint = NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        
        contentView.addConstraints([
            thumbnailWidthConstraint,
            thumbnailHeightConstraint,
            avatarTopConstraint,
        ])
        
    }
    
    override func update(configuration: MessageListConfiguration) {
        
        let videoMessage = message as! VideoMessage
        
        configuration.loadImage(imageView: avatarView, url: message.user.avatar)
        
        nameView.text = message.user.name
        nameView.sizeToFit()
        
        durationView.text = formatDuration(videoMessage.duration)
        durationView.sizeToFit()
        
        configuration.loadImage(imageView: thumbnailView, url: videoMessage.thumbnail)
        
        updateImageSize(configuration: configuration, width: videoMessage.width, height: videoMessage.height, widthConstraint: thumbnailWidthConstraint, heightConstraint: thumbnailHeightConstraint)

        showStatusView(spinnerView: spinnerView, failureView: failureView)
        
        avatarTopConstraint = showTimeView(timeView: timeView, time: message.time, avatarView: avatarView, avatarTopConstraint: avatarTopConstraint, marginTop: configuration.messagePaddingVertical)
        
    }
    
    private func formatDuration(_ duration: Int) -> String {
    
        let MINUTE = 60
        let HOUR = MINUTE * 60
        
        var seconds = duration
        let hours = seconds / HOUR
        
        seconds -= hours * HOUR
        
        let minutes = seconds / MINUTE
        
        seconds -= minutes * MINUTE
        
        var result = lpad(minutes) + ":" + lpad(seconds)
        
        if hours > 0 {
            result = lpad(hours) + ":" + result
        }
        
        return result
    
    }
    
    private func lpad(_ value: Int) -> String {
        if value > 9 {
            return "\(value)"
        }
        return "0\(value)"
    }
    
}
