import CoreGraphics

extension CGRect {
    
    /// Creates a rect with unnamed arguments.
    init(_ origin: CGPoint = .zero, _ size: CGSize = .zero) {
        self.init()
        self.origin = origin
        self.size = size
    }
    
    /// Creates a rect with unnamed arguments.
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
}
