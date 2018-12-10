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
    private var output: NSMutableAttributedString!
    private var currentParsingElements: [Element] = []
    private let defaultAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.preferredFont(forTextStyle: .body),
    ]

    // MARK: -

    init(content: String) {
        // Assume a Mastodon instance only use "<br>" or "<br />", not both.
        // If "<br>" is used, the XMLParser will get error in parsing,
        // so just replece "<br>" with "<br />".
        var content = content.replacingOccurrences(of: "<br>", with: "<br />")
        // XMLParser only parse first node...
        // So wrap content in a root node.
        content = "<p>\(content)</p>"
        data = content.data(using: .utf8) ?? Data()
        super.init()
    }

    func parse() -> NSAttributedString {
        output = NSMutableAttributedString()

        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        print(xmlParser.parse())

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
        switch elementName {
        case "br":
            output.append(NSAttributedString(string: "\n"))
        case "p" where output.length > 0:
            output.append(NSAttributedString(string: "\n\n"))
        default:
            break
        }
        currentParsingElements.append(Element(name: elementName, attributes: attributeDict))
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        currentParsingElements.removeLast()
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let element = currentParsingElements.last else {
            fatalError()
        }

        switch element.name {
        case "a":
            guard
                element.attributes["class"] != "u-url mention",
                element.attributes["class"] != "mention hashtag"
            else {
                break
            }

            var attributes = defaultAttributes
            if let url = URL(string: element.attributes["href"] ?? "") {
                attributes[.link] = url
            }
            output.append(NSAttributedString(string: string, attributes: attributes))

        case "p":
            output.append(NSAttributedString(string: string, attributes: defaultAttributes))

        case "span":
            switch element.attributes["class"] {
            case nil:
                if currentParsingElements.count > 1 {
                    let element = currentParsingElements[currentParsingElements.count - 2]
                    if element.name == "a" && element.attributes["class"] == "u-url mention",
                        let url = URL(string: element.attributes["href"] ?? "") {
                        var attributes = defaultAttributes
                        attributes[.link] = url
                        output.append(NSAttributedString(string: "@\(string)", attributes: attributes))
                        break
                    }
                    if element.name == "a" && element.attributes["class"] == "mention hashtag",
                        let url = URL(string: element.attributes["href"] ?? "") {
                        var attributes = defaultAttributes
                        attributes[.link] = url
                        output.append(NSAttributedString(string: "#\(string)", attributes: attributes))
                        break
                    }
                }
                output.append(NSAttributedString(string: string, attributes: defaultAttributes))
            case "", "ellipsis":
                var attributes = defaultAttributes
                if currentParsingElements.count > 1 {
                    let element = currentParsingElements[currentParsingElements.count - 2]
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
