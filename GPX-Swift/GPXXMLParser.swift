//
//  GPXXMLParser.swift
//  GPX-Swift
//
//  Created by John Sklikas on 3/3/23.
//

import UIKit

class GPXXMLElement: NSObject {
    
    ///The XML Properties
    var name: String
    var text: String?
    var attributes: [GPXXMLAttribute] = [];
    
    ///The Element Properties
    var parentElement: GPXXMLElement?
    var children: [GPXXMLElement]?
    
    init(name: String, attributesDict: [String : String]?) {
        self.name = name;
        if let attributesDict = attributesDict {
            let attributeKeys = attributesDict.keys;
            for attributeKey in attributeKeys {
                let attributeValue = attributesDict[attributeKey]!;
                let attribute = GPXXMLAttribute(name: attributeKey, value: attributeValue);
                self.attributes.append(attribute);
            }
        }
    }
    
    func addChildElement(_ element: GPXXMLElement) {
        if self.children == nil {
            self.children = [];
        }
        self.children!.append(element);
        element.parentElement = self;
    }
    
    func nextSiblingNamed(_ aName: String) -> GPXXMLElement? {
        //In order to have siblings, there needs to be a parent
        guard let parentElement = self.parentElement else {
            return nil;
        }
        //And obviously, there must be siblings for this condition to work
        guard let siblings = parentElement.children else {
            return nil;
        }
        for sibling in siblings {
            if (sibling.name == aName) {
                return sibling;
            }
        }
        return nil;
    }
    
    func childElementNamed(_ aName: String) -> GPXXMLElement? {
        guard let children = self.children else {
            return nil;
        }
        for child in children {
            if child.name == aName {
                return child;
            }
        }
        return nil;
    }
    
    func valueOfAttributeNamed(_ aName: String) -> String? {
        for currentAttribute in attributes {
            if currentAttribute.name == aName {
                return currentAttribute.value;
            }
        }
        return nil;
    }
}

class GPXXMLAttribute: NSObject {
    var name: String
    var value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
        super.init();
    }
}

protocol GPXParsing: NSObjectProtocol {
    func parser(_ parser: GPXXMLParser, didCompleteParsing rootXMLElement: GPXXMLElement);
    func parser(_ parser: GPXXMLParser, didFailParsingWithError error: Error);
}

class GPXXMLParser: NSObject, XMLParserDelegate {
    /*
     The algorithm logic is to have a currentParent Element, under which every object is added
     Every element is added as a child of its current parent and is then set as parent.
     
     If the end clause returns the same Element Name as the new parent, then this means that this element has been completed
     Then the parent, becomes again the element's parent.
     */
    
    var rootXMLElement: GPXXMLElement?
    private var currentParentElement: GPXXMLElement? {
        didSet {
            if let newCurrentParentName = currentParentElement?.name {
                currentParentName = newCurrentParentName;
            }
        }
    }
    private var currentParentName: String?
    
    //The parsing objects
    private var parser: XMLParser?
    weak var delegate: GPXParsing?
    
    init(data: Data) {
        super.init();
        self.decodeData(data);
    }
    
    init(url: URL) {
        super.init()
        do {
            let data = try Data(contentsOf: url);
            self.decodeData(data);
        }
        catch(let error) {
            print(error.localizedDescription);
        }
    }
    
    init(string: String) {
        super.init();
        if let data = string.data(using: .utf8) {
            self.decodeData(data);
        }
    }
    
    private func decodeData(_ data: Data) {
        parser = XMLParser(data: data);
        parser?.delegate = self;
    }
    
    public func startParsing() {
        parser?.parse();
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if (elementName == "gpx") {
            //This is the standard starting format for gpx files
            rootXMLElement = GPXXMLElement(name: elementName, attributesDict: attributeDict);
            currentParentElement = rootXMLElement;
        }
        else {
            let childElement = GPXXMLElement(name: elementName, attributesDict: attributeDict);
            currentParentElement?.addChildElement(childElement);
            currentParentElement = childElement;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //Always trim whitespaces and empty lines
        if (string.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            //If this method is called, this means that for the element that has started parsing, the text content has been found
            currentParentElement?.text = string;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "gpx") {
            if let completeRootElement = self.rootXMLElement {
                print("Parsing complete")
                self.delegate?.parser(self, didCompleteParsing: completeRootElement);
            }
            else {
                let noRootElementError = NSError(domain: "", code: 404, userInfo: [ NSLocalizedDescriptionKey: "No Root Element was created"]) as Error
                self.delegate?.parser(self, didFailParsingWithError: noRootElementError);
            }
        }
        else {
            //These two cases must never conflict, this is why this is under a separate else and not an else if.
            if (elementName == currentParentName) {
                self.currentParentElement = self.currentParentElement?.parentElement;
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.delegate?.parser(self, didFailParsingWithError: parseError);
    }
}
