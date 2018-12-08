//
//  StatusContentParser.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/9.
//

import Foundation
import MastodonKit

final class StatusContentParser: NSObject {
    private struct Element {
        let name: String
        let attributes: [String: String]
    }

    var output = NSMutableAttributedString()

    private var currentElements: [Element] = []
    private var currentURL: URL?

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
        currentElements.append(Element(name: elementName, attributes: attributeDict))
        if elementName == "p" && output.length > 0 {
            output.append(NSAttributedString(string: "\n\n"))
        }
        if elementName == "a" {
            currentURL = URL(string: attributeDict["href"] ?? "")
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

        switch element.name {
        case "p":
            output.append(NSAttributedString(string: string, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
            ]))
        case "span":
            switch element.attributes["class"] {
            case "":
                output.append(NSAttributedString(string: string, attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .body),
                    .link: currentURL as Any,
                ]))
            case "ellipsis":
                output.append(NSAttributedString(string: "\(string)...", attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .body),
                    .link: currentURL as Any,
                ]))
            default:
                break
            }
        default:
            break
        }
    }
}
