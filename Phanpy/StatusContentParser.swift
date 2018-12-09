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

    // MARK: -

    private let data: Data
    private var output = NSMutableAttributedString()
    private var currentElements: [Element] = []
    private let defaultAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .body),
    ]

    // MARK: -

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

// MARK: - XMLParserDelegate
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
        case "br":
            output.append(NSAttributedString(string: "\n"))
        case "p" where output.length > 0:
            output.append(NSAttributedString(string: "\n\n"))
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
        case "a":
            var attributes = defaultAttributes
            if let url = URL(string: element.attributes["href"] ?? "") {
                attributes[.link] = url
            }
            output.append(NSAttributedString(string: string, attributes: attributes))

        case "br", "p":
            output.append(NSAttributedString(string: string, attributes: defaultAttributes))

        case "span":
            switch element.attributes["class"] {
            case nil:
                output.append(NSAttributedString(string: string, attributes: defaultAttributes))
            case "", "ellipsis":
                var attributes = defaultAttributes
                if currentElements.count > 1 {
                    let element = currentElements[currentElements.count - 2]
                    if element.name == "a", let url = URL(string: element.attributes["href"] ?? "") {
                        attributes[.link] = url
                    }
                }
                let ellipsis = element.attributes["class"] == "ellipsis" ? "..." : ""
                output.append(NSAttributedString(string: "\(string)\(ellipsis)", attributes: attributes))
            default:
                break
            }

        default:
            break
        }
    }
}
