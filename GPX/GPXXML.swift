//
//  GPXXML.swift
//  GPX
//
//  Created by John Sklikas on 24/1/23.
//

import UIKit

class GPXXMLAttribute {
    var name: String?
    var value: String?
    var next: GPXXMLAttribute?
}

class GPXXMLElement {
    var name: String?
    var text: String?
    
    var firstAttribute: GPXXMLAttribute?
    
    var parentElement: GPXXMLElement?
    
    var firstChild: GPXXMLElement?
    var currentChild: GPXXMLElement?
    
    var nextSibling: GPXXMLElement?
    var previousSibling: GPXXMLElement?
    
    func nextSiblingNamed(_ aName: String) -> GPXXMLElement? {
        var currentElement = self;
        while(currentElement.nextSibling != nil) {
            currentElement = currentElement.nextSibling!
            if currentElement.name == aName {
                return currentElement;
            }
        }
        return nil;
    }
    
    func childElementNamed(_ aName: String) -> GPXXMLElement? {
        var childElement = self.firstChild;
        while (childElement != nil) {
            if (childElement!.name == name) {
                return childElement;
            }
            childElement = childElement!.nextSibling;
        }
        return nil;
    }
    
    func valueOfAttributeNamed(_ aName: String) -> String? {
        var currentAttribute: GPXXMLAttribute? = self.firstAttribute;
        while (currentAttribute != nil) {
            if currentAttribute!.name == aName {
                return currentAttribute!.value;
            }
            currentAttribute = currentAttribute!.next;
        }
        return nil;
    }
}
    

class GPXXMLElementBuffer {
    var elements: [GPXXMLElement]?
    var next: GPXXMLElementBuffer?
    var previous: GPXXMLElementBuffer?
}

class GPXXMLAttributeBuffer {
    var attributes: [GPXXMLAttribute]?
    var next: GPXXMLAttributeBuffer?
    var previous: GPXXMLAttributeBuffer?
}

class GPXXML: NSObject {
    //Class Variables
    let MAX_ELEMENTS = 100
    let MAX_ATTRIBUTES = 100

    let GPXXML_ATTRIBUTE_NAME_START = 0
    let GPXXML_ATTRIBUTE_NAME_END = 1
    let GPXXML_ATTRIBUTE_VALUE_START = 2
    let GPXXML_ATTRIBUTE_VALUE_END = 3
    let GPXXML_ATTRIBUTE_CDATA_END = 4
    
    //Private variables
    var rootXMLElement: GPXXMLElement?
    
    private var currentElementBuffer: GPXXMLElementBuffer?
    private var currentAttributeBuffer: GPXXMLAttributeBuffer?
    
    private var currentElement = 0;
    private var currentAttribute = 0;
    
    //Initialisers
    init(withURL aURL: URL) {
        super.init()
        do {
            let data = try Data(contentsOf: aURL);
            self.decodeData(data);
        }
        catch(let error) {
            print(error.localizedDescription);
        }
    }
    
    init(withXMLString aXMLString: String) {
        super.init()
        self.decodeString(aXMLString);
    }
    
    init(withXMLData aData: Data) {
        super.init()
        self.decodeData(aData);
    }
    
    //Private functions
    private func decodeData(_ data: Data) {
        //We will follow a more modern approach in this iteration, without using C
        let xmlString = String(decoding: data, as: UTF8.self)
        self.decodeString(xmlString);
    }
    private func decodeString(_ aString: String) {
        //We will use the string as a character array, so we can iterate through
        var xmlString = aString;
        var charactersArray = xmlString.map { Character(extendedGraphemeClusterLiteral: $0) }
        var k = 0;
        
        // set parent element to nil
        var parentXMLElement: GPXXMLElement?
        
        while (charactersArray[k] == "<") {
            
            // detect comment section
            if (String(charactersArray[k...k+3]) == "<!--") {
                //Find first occurence of -->, so we can find the end of the comment
                let endCommentIndex: Int? = xmlString.index(of: "-->", lowestValue: k);
                k = endCommentIndex! + 3;
                continue;
            }
            
            // detect cdata section within element text
            let isCDATA = (String(charactersArray[k...k+8]) == "<![CDATA[")
            
            // if cdata section found, skip data within cdata section and remove cdata tags
            if (isCDATA) {
                
                // find end of cdata section
                let cDATAEndIndex: Int? = xmlString.index(of: "]]>", lowestValue: k);
                
                // find start of next element skipping any cdata sections within text
                // find next open tag
                var elementEndIndex: Int? = xmlString.index(of: "<", lowestValue: cDATAEndIndex!);
                // if open tag is a cdata section
                while (String(charactersArray[elementEndIndex!...elementEndIndex!+8]) == "<![CDATA[") {
                    // find end of cdata section
                    elementEndIndex = xmlString.index(of: "]]>", lowestValue: elementEndIndex!);
                    // find next open tag
                    elementEndIndex = xmlString.index(of: "<", lowestValue: elementEndIndex!);
                }
                
                // calculate length of cdata content
                //let CDATALength = cDATAEndIndex!-k;
                
                // calculate total length of text
                //let textLength = elementEndIndex!-k;
                
                // remove begining cdata section tag
                charactersArray.removeSubrange(k...k+8);

                // remove ending cdata section tag
                // The indices have moved by 9, so we have to adjust the variables
                charactersArray.removeSubrange(cDATAEndIndex!-9...cDATAEndIndex!-6);
                xmlString = String(charactersArray);
                
                // set new search start position
                k = cDATAEndIndex!-9;
                continue;
            }
            
            // find element end, skipping any cdata sections within attributes
            var elementEnd = k + 1;
            var startIndex: Int? = xmlString.index(of: "<", lowestValue: elementEnd);
            var endIndex: Int? = xmlString.index(of: ">", lowestValue: elementEnd);
            while (startIndex != nil || endIndex != nil) {
                let firstFound = min(startIndex ?? Int.max, endIndex ?? Int.max);
                elementEnd = firstFound;
                if (String(charactersArray[elementEnd...elementEnd+8]) == "<![CDATA[") {
                    let cDataEndIndex: Int? = xmlString.index(of: "]]>", lowestValue: elementEnd);
                    elementEnd = cDataEndIndex! + 3;
                    startIndex = xmlString.index(of: "<", lowestValue: elementEnd);
                    endIndex = xmlString.index(of: ">", lowestValue: elementEnd);
                }
                else {
                    break;
                }
            }
            
            //Element name start
            let elementNameStartIndex = k+1;
            let elementNameStart = charactersArray[elementNameStartIndex];
            
            // ignore tags that start with ? or ! unless cdata "<![CDATA"
            if (elementNameStart == "?" || (elementNameStart == "!" && isCDATA == false)) {
                k = elementEnd+1;
                continue;
            }
            
            // ignore attributes/text if this is a closing element
            if (elementNameStart == "/") {
                k = elementEnd+1;
                if (parentXMLElement != nil) {

                    if (parentXMLElement!.text != nil) {
                        // trim whitespace from start and end of text
                        let xmlElementText = parentXMLElement!.text!
                        let trimmedText = xmlElementText.trimmingCharacters(in: .whitespacesAndNewlines)
                        parentXMLElement?.text = trimmedText;
                    }
                    
                    parentXMLElement = parentXMLElement!.parentElement
                    
                    // if parent element has children clear text
                    if (parentXMLElement != nil && parentXMLElement?.firstChild != nil) {
                        parentXMLElement!.text = nil;
                    }
                    
                }
                continue;
            }
            
            // is this element opening and closing
            var selfClosingElement = false;
            if (charactersArray[elementEnd-1] == "/") {
                selfClosingElement = true;
            }
            
            // create new xmlElement struct
            let xmlElement = self.nextAvailableElement();
            
            // if there is a parent element
            if (parentXMLElement != nil) {
                
                // if this is first child of parent element
                if (parentXMLElement!.currentChild != nil) {
                    // set next child element in list
                    parentXMLElement!.currentChild!.nextSibling = xmlElement;
                    xmlElement.previousSibling = parentXMLElement!.currentChild!;
                    
                    parentXMLElement!.currentChild = xmlElement;
                }
                else {
                    // set first child element
                    parentXMLElement!.currentChild = xmlElement;
                    parentXMLElement!.firstChild = xmlElement;
                }
                
                xmlElement.parentElement = parentXMLElement;
            }
            
            // in the following xml the ">" is replaced with \0 by elementEnd.
            // element may contain no atributes and would return nil while looking for element name end
            // <tile>
            // find end of element name
            let dashIndex: Int? = xmlString.index(of: "/", lowestValue: elementNameStartIndex);
            let spaceIndex: Int? = xmlString.index(of: " ", lowestValue: elementNameStartIndex);
            var elementNameEndIndex: Int?
            if (dashIndex != nil || spaceIndex != nil) {
                if (dashIndex != nil) {
                    elementNameEndIndex = dashIndex;
                }
                else if (spaceIndex != nil) {
                    elementNameEndIndex = spaceIndex;
                }
            }
            
            // set element name
            let elementName = charactersArray[elementNameStartIndex...(elementNameEndIndex ?? charactersArray.count - 1)]
            xmlElement.name = String(elementName);
            
            // if end was found check for attributes
            if (elementNameEndIndex != nil) {
                
                var chr = charactersArray[elementNameEndIndex!];
                var name = ""
                var value = ""
                //var CDATAStart: String?
                //var CDATAEnd: String?
                var lastXMLAttribute: GPXXMLAttribute?
                var xmlAttribute: GPXXMLAttribute?
                var singleQuote = false;
                
                var mode = GPXXML_ATTRIBUTE_NAME_START;
                
                // loop through all characters within element
                for i in elementNameEndIndex!..<elementEnd {
                    chr = charactersArray[i];
                    
                    switch (mode) {
                    // look for start of attribute name
                    case GPXXML_ATTRIBUTE_NAME_START:
                        if chr.isWhitespace {
                            continue;
                        }
                        name.append(chr);
                        mode = GPXXML_ATTRIBUTE_NAME_END;
                        break;
                    // look for end of attribute name
                    case GPXXML_ATTRIBUTE_NAME_END:
                        if (chr.isWhitespace || chr == "=") {
                            mode = GPXXML_ATTRIBUTE_VALUE_START;
                        }
                        break;
                    // look for start of attribute value
                    case GPXXML_ATTRIBUTE_VALUE_START:
                        if chr.isWhitespace {
                            continue;
                        }
                        if (chr == "\"" || chr == "'") {
                            value.append(charactersArray[i+1])
                            mode = GPXXML_ATTRIBUTE_VALUE_END;
                            if (chr == "'") {
                                singleQuote = true;
                            }
                            else {
                                singleQuote = false;
                            }
                        }
                        break;
                    // look for end of attribute value
                    case GPXXML_ATTRIBUTE_VALUE_END:
                        if (chr == "<" && String(charactersArray[i...i+8]) == "<![CDATA[") {
                            mode = GPXXML_ATTRIBUTE_CDATA_END;
                        }
                        else if ((chr == "\"" && singleQuote == false) || (chr == "'" && singleQuote == true)) {
                            /*
                             //These do not seem to be used anywhere, thus they will be skipped
                            // remove cdata section tags
                            while ((CDATAStart = strstr(value, "<![CDATA["))) {
                                
                                // remove begin cdata tag
                                memcpy(CDATAStart, CDATAStart+9, strlen(CDATAStart)-8);
                                    
                                // search for end cdata
                                CDATAEnd = strstr(CDATAStart,"]]>");
                                    
                                // remove end cdata tag
                                memcpy(CDATAEnd, CDATAEnd+3, strlen(CDATAEnd)-2);
                            }
                             */
                                
                            // create new attribute
                            xmlAttribute = self.nextAvailableAttribute();
                                
                            // if this is the first attribute found, set pointer to this attribute on element
                            if (xmlElement.firstAttribute == nil) {
                                xmlElement.firstAttribute = xmlAttribute;
                            }
                                
                            // if previous attribute found, link this attribute to previous one
                            if (lastXMLAttribute != nil) {
                                lastXMLAttribute!.next = xmlAttribute;
                            }
                            
                            // set last attribute to this attribute
                            lastXMLAttribute = xmlAttribute;

                            // set attribute name & value
                            xmlAttribute?.name = name;
                            xmlAttribute?.value = value;
                                
                            // clear name and value pointers
                            name = "";
                            value = "";
                                
                            // start looking for next attribute
                            mode = GPXXML_ATTRIBUTE_NAME_START;
                        }
                        break;
                        // look for end of cdata
                        case GPXXML_ATTRIBUTE_CDATA_END:
                            if (chr == "]") {
                                if (String(charactersArray[i...i+2]) == "]]>") {
                                    mode = GPXXML_ATTRIBUTE_VALUE_END;
                                }
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            
            // if tag is not self closing, set parent to current element
            if (!selfClosingElement) {
                // set text on element to element end+1
                if (charactersArray[elementEnd+1] != ">") {
                    xmlElement.text?.append(charactersArray[elementEnd+1])
                }
                parentXMLElement = xmlElement;
            }
            
            // start looking for next element after end of current element
            k = elementEnd+1;
            
        }
        
    }
    
    private func nextAvailableElement() -> GPXXMLElement {
        self.currentElement = self.currentElement + 1;
        
        if (currentElementBuffer == nil) {
            currentElementBuffer = GPXXMLElementBuffer();
            self.currentElement = 0;
            let elementsArray = [GPXXMLElement](repeating: GPXXMLElement(), count: MAX_ELEMENTS)
            currentElementBuffer!.elements = elementsArray;
            rootXMLElement = currentElementBuffer!.elements?[currentElement]
        }
        else if (currentElement >= MAX_ELEMENTS) {
            currentElementBuffer?.next = GPXXMLElementBuffer()
            currentElementBuffer?.next?.previous = currentElementBuffer;
            currentElementBuffer = currentElementBuffer?.next;
            let elementsArray = [GPXXMLElement](repeating: GPXXMLElement(), count: MAX_ELEMENTS)
            currentElementBuffer?.elements = elementsArray;
            currentElement = 0;
        }
        return currentElementBuffer!.elements![currentElement];
    }
    
    private func nextAvailableAttribute() -> GPXXMLAttribute {
        self.currentAttribute = self.currentAttribute + 1;
        
        if (currentAttributeBuffer == nil) {
            currentAttributeBuffer = GPXXMLAttributeBuffer();
            let attributesArray = [GPXXMLAttribute](repeating: GPXXMLAttribute(), count: MAX_ATTRIBUTES)
            currentAttributeBuffer!.attributes = attributesArray;
            currentAttribute = 0;
        }
        else if (currentAttribute >= MAX_ATTRIBUTES) {
            currentAttributeBuffer!.next = GPXXMLAttributeBuffer();
            currentAttributeBuffer!.next!.previous = currentAttributeBuffer;
            currentAttributeBuffer = currentAttributeBuffer!.next;
            let attributesArray = [GPXXMLAttribute](repeating: GPXXMLAttribute(), count: MAX_ATTRIBUTES)
            currentAttributeBuffer!.attributes = attributesArray;
            currentAttribute = 0;
        }
        
        return currentAttributeBuffer!.attributes![currentAttribute];
        
    }
    
}
