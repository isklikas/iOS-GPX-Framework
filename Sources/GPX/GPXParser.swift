//
//  GPXParser.swift
//  GPX
//
//  Created by John Sklikas on 3/3/23.
//

import Foundation

/** Instances of this protocol notify of completely parsed GPX documents, or errors that occured during parsing
 */
public protocol GPXParsing: NSObjectProtocol {
    func parser(_ parser: GPXParser, didCompleteParsing rootXMLElement: GPXXMLElement);
    func parser(_ parser: GPXParser, didFailParsingWithError error: Error);
}

/** Instances of this class parse GPX documents.
 */
public class GPXParser: NSObject, GPXParsing {
    
    var gpxXMLParser: GPXXMLParser;
    public weak var delegate: GPXParsing?
    var completion: ((Result<GPXXMLElement, Error>) -> Void)?
    
    /// ---------------------------------
    /// **  Parsing
    /// ---------------------------------

    /**
     Parsing the GPX content referenced by the given URL.
     - Parameter url: A URL object specifying a URL. The URL must be fully qualified and refer to a scheme that is supported by the URL class.
     - Returns: An initialized GPXRoot object or nil if an error occurs.
     */
    public init(_ url: URL) {
        self.gpxXMLParser = GPXXMLParser(url: url);
        super.init()
        gpxXMLParser.gpxParser = self;
    }

    /**
     Parsing the GPX content referenced by the given File path.
     - Parameter path: The absolute path of the file from which to read GPX data.
     - Returns: An initialized GPXRoot object or nil if an error occurs.
     */
    public init?(_ path: String) {
        var url: URL?
        if #available(iOS 16, macOS 13.0, *) {
            url = URL(filePath: path);
        }
        else {
            url = URL(fileURLWithPath: path)
        }
        guard let url = url else {
            return nil;
        }
        self.gpxXMLParser = GPXXMLParser(url: url);
        super.init();
        gpxXMLParser.gpxParser = self;
    }

    /**
     Parsing the GPX content referenced by the given GPX string.
     - Parameter string: The GPX string.
     - Returns: An initialized GPXRoot object or nil if an error occurs.
     */
    public init(withString string: String) {
        self.gpxXMLParser = GPXXMLParser(string: string);
        super.init();
        gpxXMLParser.gpxParser = self;
    }

    /**
     Parsing the GPX content referenced by the given data.
     - Parameter data: The data from which to read GPX data.
     - Returns: An initialized GPXROot object or nil if an error occurs.
     */
    public init(withData data: Data) {
        self.gpxXMLParser = GPXXMLParser(data: data);
        super.init();
        gpxXMLParser.gpxParser = self;
    }
    
    /**
     Called to start parsing the GPX file.
     - NOTE: If no GPXParsing delegate is set, then the object is returned in async manner. Both async and completion handlers are supported.
     */
    public func parse(completion: ((Result<GPXXMLElement, Error>) -> Void)? = nil) {
        if self.delegate == nil {
            self.delegate = self;
            self.completion = completion;
        }
        self.gpxXMLParser.startParsing();
    }
    
    /**
     Called to start parsing the GPX file in async / await manner.
     */
    @available(iOS 15, macOS 10.15, *)
    public func parse() async throws -> GPXXMLElement {
        return try await withCheckedThrowingContinuation { continuation in
            self.parse(completion: { parseResult in
                switch parseResult {
                case .failure(let error):
                    continuation.resume(throwing: error);
                case .success(let parsedElement):
                    continuation.resume(returning: parsedElement);
                }
            })
        }
    }

    /** Called when the GPX file has been parsed successfully
     */
    func gpxParsingComplete(_ rootElement: GPXXMLElement) {
        self.delegate?.parser(self, didCompleteParsing: rootElement);
    }
    
    /** Called when an error has occured during GPX file parsing
     */
    func gpxParsingFailed(_ error: Error) {
        self.delegate?.parser(self, didFailParsingWithError: error);
    }
    
    // MARK: GPXParsing Delegate calls
    public func parser(_ parser: GPXParser, didCompleteParsing rootXMLElement: GPXXMLElement) {
        self.completion?(.success(rootXMLElement));
    }
    public func parser(_ parser: GPXParser, didFailParsingWithError error: Error) {
        self.completion?(.failure(error));
    }
}
