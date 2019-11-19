import CoreGraphics

extension CGSize {
    
    /// Creates a size with unnamed arguments.
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.width = width
        self.height = height
    }
    
    /// Returns a copy with the width value changed.
    func with(width: CGFloat) -> CGSize {
        return .init(width: width, height: height)
    }
    /// Returns a copy with the height value changed.
    func with(height: CGFloat) -> CGSize {
        return .init(width: width, height: height)
    }
}
