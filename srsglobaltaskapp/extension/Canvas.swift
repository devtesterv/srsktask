import Foundation
import UIKit
//struct Line {
//    let strokeWidth: Float
//    let color: UIColor
//    var points: [CGPoint]
//}
//
//class Canvas: UIView {
//
//    // public function
//    fileprivate var strokeColor = UIColor.black
//    fileprivate var strokeWidth: Float = 1
//
//    func setStrokeWidth(width: Float) {
//        self.strokeWidth = width
//    }
//
//    func setStrokeColor(color: UIColor) {
//        self.strokeColor = color
//    }
//
//    func undo() {
//        _ = lines.popLast()
//        setNeedsDisplay()
//    }
//
//    func clear() {
//        lines.removeAll()
//        setNeedsDisplay()
//    }
//
//    fileprivate var lines = [Line]()
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//        lines.forEach { (line) in
//            context.setStrokeColor(line.color.cgColor)
//            context.setLineWidth(CGFloat(line.strokeWidth))
//            context.setLineCap(.round)
//            for (i, p) in line.points.enumerated() {
//                if i == 0 {
//                    context.move(to: p)
//                } else {
//                    context.addLine(to: p)
//                }
//            }
//            context.strokePath()
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let point = touches.first?.location(in: nil) else { return }
//        guard var lastLine = lines.popLast() else { return }
//        lastLine.points.append(point)
//        lines.append(lastLine)
//        setNeedsDisplay()
//    }
//}

// MARK: - Designable Class
@IBDesignable open class Canvas: UIView {
    
    // Inspectable elements
    
    @IBInspectable open var lineWidth: CGFloat = 10.0 {
        didSet {
            path.lineWidth = lineWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable open var lineColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var style:CGLineCap = .round {
        didSet {
            path.lineCapStyle = style
            setNeedsDisplay()
        }
    }
    
    open var isEmpty: Bool {
        get {
            guard !self.path.isEmpty else {
                return true
            }
            return false
        }
    }
    
    open var getDesign: UIImage? {
        guard !isEmpty else {
            return nil
        }
        return UIImage(view: self)
    }
    
    private var path = UIBezierPath()
    private var lines = [[CGPoint]]()
    
    // MARK: - Clear path
    
    internal func clear() {
        lines.removeAll()
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
    // Override functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Custome Drawing
        lines.forEach { (line) in
            for (i,p) in line.enumerated() {
                if i == 0 {
                    path.move(to: p)
                }
                else {
                    path.addLine(to: p)
                }
            }
        }
        lineColor.setStroke()
        path.stroke()
    }
    
    // Track the finger as we move across screen
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override open func touchesMoved (_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let points = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(points)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}

// MARK: - Convert UIView to Image

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}
