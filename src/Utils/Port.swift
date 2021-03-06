import Foundation

/// Represents the port number of IP protocol.
public struct Port: CustomStringConvertible, Hashable, IntegerLiteralConvertible {
    public typealias IntegerLiteralType = UInt16

    private var inport: UInt16

    /**
     Initialize a new instance with the port number in network byte order.

     - parameter portInNetworkOrder: The port number in network byte order.

     - returns: The initailized port.
     */
    public init(portInNetworkOrder: UInt16) {
        self.inport = portInNetworkOrder
    }

    /**
     Initialize a new instance with the port number.

     - parameter port: The port number.

     - returns: The initailized port.
     */
    public init(port: UInt16) {
        self.init(portInNetworkOrder: NSSwapHostShortToBig(port))
    }

    public init(integerLiteral value: Port.IntegerLiteralType) {
        self.init(port: value)
    }

    /**
     Initialize a new instance with data in network byte order.

     - parameter bytesInNetworkOrder: The port data in network byte order.

     - returns: The initailized port.
     */
    public init(bytesInNetworkOrder: UnsafePointer<Void>) {
        self.init(portInNetworkOrder: UnsafePointer<UInt16>(bytesInNetworkOrder).memory)
    }

    public var description: String {
        return "<Port \(value)>"
    }

    /// The port number.
    public var value: UInt16 {
        return NSSwapBigShortToHost(inport)
    }

    public var valueInNetworkOrder: UInt16 {
        return inport
    }

    /// The hash value of the port.
    public var hashValue: Int {
        return Int(inport)
    }

    /**
     Run a block with the bytes of port in **network order**.

     - parameter block: The block to run.

     - returns: The value the block returns.
     */
    public mutating func withUnsafeValuePointer<T>(block: (UnsafePointer<Void>) -> T) -> T {
        return withUnsafePointer(&inport) {
            return block($0)
        }
    }
}

public func == (left: Port, right: Port) -> Bool {
    return left.valueInNetworkOrder == right.valueInNetworkOrder
}
