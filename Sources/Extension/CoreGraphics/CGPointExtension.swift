import CoreGraphics

extension CGPoint {
    
    /// Creates a point with unnamed arguments.
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init()
        self.x = x
        self.y = y
    }
    
    /// Returns a copy with the x value changed.
    func with(x: CGFloat) -> CGPoint {
        return .init(x: x, y: y)
    }
    /// Returns a copy with the y value changed.
    func with(y: CGFloat) -> CGPoint {
        return .init(x: x, y: y)
    }
}
