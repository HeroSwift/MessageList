
import UIKit

class LeftAudioMessageCell: AudioMessageCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func create(configuration: MessageListConfiguration) {
        
        super.create(configuration: configuration)
        
        bubbleView.image = configuration.leftAudioMessageBubble
        
        audioView.image = configuration.leftAudioMessageWave
        audioView.animationImages = configuration.leftAudioMessageWaves
        
        if configuration.leftUserNameVisible {
            
            nameView.font = configuration.leftUserNameTextFont
            nameView.textColor = configuration.leftUserNameTextColor
            nameView.textAlignment = .left
            
            contentView.addSubview(nameView)
            addClickHandler(view: nameView, selector: #selector(onUserNameClick))
            
            contentView.addConstraints([
                
                NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: configuration.messagePaddingVertical),
                NSLayoutConstraint(item: avatarView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.messagePaddingHorizontal),
                
                NSLayoutConstraint(item: nameView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: nameView, attribute: .left, relatedBy: .equal, toItem: avatarView, attribute: .right, multiplier: 1, constant: configuration.leftUserNameMarginLeft),
                
                // 父类算好了气泡的宽度
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1, constant: configuration.leftAudioMessageMarginLeft),
                NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: avatarView, attribute: .right, multiplier: 1, constant: configuration.leftAudioMessageMarginLeft),
                NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.messagePaddingVertical),
                NSLayoutConstraint(item: bubbleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
                
                NSLayoutConstraint(item: audioView, attribute: .centerY, relatedBy: .equal, toItem: bubbleView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: audioView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftAudioMessageWaveMarginLeft),
                
                NSLayoutConstraint(item: durationView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: configuration.leftAudioMessageDurationMarginLeft),
                NSLayoutConstraint(item: durationView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.leftAudioMessageDurationMarginBottom),
                
                NSLayoutConstraint(item: unitView, attribute: .centerY, relatedBy: .equal, toItem: durationView, attribute: .centerY, multiplier: 1, constant: configuration.leftAudioMessageUnitCenterY),
                NSLayoutConstraint(item: unitView, attribute: .left, relatedBy: .equal, toItem: durationView, attribute: .right, multiplier: 1, constant: configuration.leftAudioMessageUnitMarginLeft),
                
            ])
            
        }
        else {
            contentView.addConstraints([
                
                NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: configuration.messagePaddingVertical),
                NSLayoutConstraint(item: avatarView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.messagePaddingHorizontal),
                
                // 父类算好了气泡的宽度
                NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: avatarView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: avatarView, attribute: .right, multiplier: 1, constant: configuration.leftAudioMessageMarginLeft),
                NSLayoutConstraint(item: bubbleView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.messagePaddingVertical),
                NSLayoutConstraint(item: bubbleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.userAvatarHeight),
                
                NSLayoutConstraint(item: audioView, attribute: .centerY, relatedBy: .equal, toItem: bubbleView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: audioView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1, constant: configuration.leftAudioMessageWaveMarginLeft),
                
                NSLayoutConstraint(item: durationView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1, constant: configuration.leftAudioMessageDurationMarginLeft),
                NSLayoutConstraint(item: durationView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1, constant: -configuration.leftAudioMessageDurationMarginBottom),
                
                NSLayoutConstraint(item: unitView, attribute: .centerY, relatedBy: .equal, toItem: durationView, attribute: .centerY, multiplier: 1, constant: configuration.leftAudioMessageUnitCenterY),
                NSLayoutConstraint(item: unitView, attribute: .left, relatedBy: .equal, toItem: durationView, attribute: .right, multiplier: 1, constant: configuration.leftAudioMessageUnitMarginLeft),

            ])
        }
        
    }
    
}
