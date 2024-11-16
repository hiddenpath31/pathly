import Foundation
import UIKit

extension NSAttributedString {
    public func attributedStringByTrimming(charSet: CharacterSet) -> NSAttributedString {
        let modifiedString = NSMutableAttributedString(attributedString: self)
        modifiedString.trimCharacters(in: charSet)
        return NSAttributedString(attributedString: modifiedString)
    }
    
    static func spacing(_ width: CGFloat) -> NSAttributedString {
        let spacing = NSTextAttachment()
        spacing.bounds = .init(origin: .zero, size: .init(width: width, height: 0))
        return .init(attachment: spacing)
    }
}

extension NSMutableAttributedString {
    public func trimCharacters(in charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet)
        
        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }
        
        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }
    
    static func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return NSMutableAttributedString(attributedString: result)
    }
    
}

extension NSAttributedString {
    func attributedString(before string: String) -> NSAttributedString {
        guard let range = self.string.range(of: string) else {return self}
        let substring = self.attributedSubstring(from: NSRange.init(location: 0, length: NSRange.init(range, in: self.string).location))
        return substring
    }
}

extension NSAttributedString {
    
    var bolded:NSAttributedString {
        return applying(attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    var underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    //Struckthrough string
    var struckthrough: NSAttributedString {
         return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    
    func colored(_ color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    
    func fonted(_ font: UIFont) -> NSAttributedString {
        return applying(attributes: [.font: font])
    }
    
    func styled(lineHeightFigma: CGFloat, lineHeightFont: CGFloat, alignment: NSTextAlignment = .left) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineSpacing = lineHeightFigma - lineHeightFont

        return styled(style)
    }

    func styled(_ style: NSParagraphStyle) -> NSAttributedString {
        return applying(attributes: [.paragraphStyle: style])
    }
}

extension NSAttributedString {
    
    //Applies given attributes to the new instance of NSAttributedString initialized with self object
    func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)
        return copy
    }
    
    //Apply attributes to substrings matching a regular expression
    func applying(attributes: [NSAttributedString.Key:Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
        
        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)
        
        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }
        
        return result
    }
    
    func applying<T:StringProtocol>(attributes: [NSAttributedString.Key:Any], toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"
        return applying(attributes: attributes,toRangesMatching: pattern)
    }
}

extension String {
    var attr: NSAttributedString {
        return NSAttributedString(string: self)
    }
}

extension UIImage {

    func attr(
        alignCenter: Bool = false,
        customSize: CGSize? = nil,
        font: UIFont? = nil
    ) -> NSAttributedString {
        let attachment = NSTextAttachment(image: self)

        let finalSize = customSize ?? size
        attachment.bounds.size = finalSize

        if alignCenter {
            let yOffset: CGFloat
            if let font = font {
                yOffset = (font.capHeight - finalSize.height)/2
            } else {
                yOffset = -finalSize.height/4
            }
            attachment.bounds = .init(x: 0,
                                      y: yOffset,
                                      width: finalSize.width,
                                      height: finalSize.height)
        }
        return NSAttributedString(attachment: attachment)
    }
}
