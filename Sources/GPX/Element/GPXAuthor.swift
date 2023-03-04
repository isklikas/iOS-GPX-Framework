//
//  GPXAuthor.swift
//  GPX
//
//  Created by John Sklikas on 29/1/23.
//

import Foundation

public class GPXAuthor: GPXPerson {
    //MARK: Tag
    override class func tagName() -> String? {
        return "author";
    }

}
