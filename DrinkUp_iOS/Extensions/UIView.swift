
import UIKit

extension UIView {
    
    func addShadow(
        shadowRadius radius: CGFloat,
        shadowOpacity opacity: Float,
        shadowPath path: CGPath? = nil,
        shadowColor color: CGColor? = nil,
        shadowOffset offset: CGSize) {

        self.layer.shadowPath = path
        self.layer.shadowColor = color
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        
        self.layer.masksToBounds = false
        self.frame.size = self.frame.size
    }
    
}
