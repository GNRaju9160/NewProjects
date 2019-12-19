

import UIKit

class GradientLabel: UILabel {
    var gradientColors: [CGColor] = []
    
    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }
    
    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }
        
        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
}

class GradientView: UIView {
    
    @IBInspectable
    var startColor: UIColor = .red
    
    @IBInspectable
    var middleColor: UIColor = .green
    
    @IBInspectable
    var endColor: UIColor = .blue
    
    
    
    private let gradientLayerName = "Gradient"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupGradient()
    }
    
    private func setupGradient() {
        var gradient: CAGradientLayer? = layer.sublayers?.first { $0.name == gradientLayerName } as? CAGradientLayer
        if gradient == nil {
            gradient = CAGradientLayer()
            gradient?.name = gradientLayerName
            layer.addSublayer(gradient!)
        }
        gradient?.frame = bounds
        gradient?.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
        gradient?.zPosition = -1
    }
    
}

