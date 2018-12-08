//
//  PhanpyTests.swift
//  PhanpyTests
//
//  Created by 李孛 on 2018/12/8.
//

import XCTest
@testable import Phanpy

final class PhanpyTests: XCTestCase {
    func testStatusContentParser() {
        // swiftlint:disable line_length
        let content = """
            <p>Test, <a href="https://www.apple.com" rel="nofollow noopener" target="_blank"><span class="invisible">https://www.</span><span class="">apple.com</span><span class="invisible"></span></a> Yo.<br />This is a test.</p><p>Yo!</p><p><a href="https://www.apple.com/cn/shop/buy-mac/macbook-air" rel="nofollow noopener" target="_blank"><span class="invisible">https://www.</span><span class="ellipsis">apple.com/cn/shop/buy-mac/macb</span><span class="invisible">ook-air</span></a></p>
            """
        // swiftlint:enable line_length
        let parser = StatusContentParser(content: content)
        print(parser.output.string)
        print("---")
    }
}
