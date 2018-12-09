//
//  StatusContentParser.swift
//  Phanpy
//
//  Created by 李孛 on 2018/12/9.
//

import UIKit

final class StatusContentParser: NSObject {
    private struct Element {
        let name: String
        let attributes: [String: String]
    }

    private let data: Data
    private var output = NSMutableAttributedString()

    private var currentElements: [Element] = []
    private var currentURL: URL?

    init(content: String) {
        data = "<p>\(content)</p>".data(using: .utf8) ?? Data()
        super.init()
    }

    func parse() -> NSAttributedString {
        output = NSMutableAttributedString()

        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()

        return output
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
        switch elementName {
        case "p" where output.length > 0:
            output.append(NSAttributedString(string: "\n\n"))
        case "a":
            currentURL = URL(string: attributeDict["href"] ?? "")
        case "br":
            output.append(NSAttributedString(string: "\n"))
        default:
            break
        }
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        currentElements.removeLast()
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let element = currentElements.last else {
            fatalError()
        }

        switch element.name {
        case "p", "br":
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
            case nil:
                output.append(NSAttributedString(string: string, attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .body),
                ]))
            default:
                break
            }
        case "a":
            output.append(NSAttributedString(string: string, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .link: currentURL as Any,
            ]))
        default:
            break
        }
    }
}
