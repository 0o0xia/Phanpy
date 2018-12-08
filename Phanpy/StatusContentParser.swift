//
//  StatusContentParser.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/9.
//

import Foundation
import MastodonKit

final class StatusContentParser: NSObject {
    var output = NSMutableAttributedString()

    private var currentElements: [String] = []

    init(content: String) {
        super.init()

        guard let data = "<content>\(content)</content>".data(using: .utf8) else {
            return
        }

        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
}

extension StatusContentParser: XMLParserDelegate {
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        currentElements.append(elementName)
        if elementName == "p" && output.length > 0 {
            output.append(NSAttributedString(string: "\n\n"))
        }
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        currentElements.removeLast()
        if elementName == "br" {
            output.append(NSAttributedString(string: "\n"))
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let element = currentElements.last else {
            fatalError()
        }

        switch element {
        case "p":
            output.append(NSAttributedString(string: string))
        default:
            break
        }
    }
}
