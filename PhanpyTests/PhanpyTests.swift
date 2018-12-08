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
            <p>苏武腿。天苍茫，月迷茫，不知是看词还是看腿。<br>now the full article is here<br>苏武牧羊 (Su Wu Mu Yang)<br><a href="http://xahmusic.org/music/su_wu_mu_yang.html" rel="nofollow noopener" target="_blank"><span class="invisible">http://</span><span class="ellipsis">xahmusic.org/music/su_wu_mu_ya</span><span class="invisible">ng.html</span></a></p>
            """
        // swiftlint:enable line_length
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.output.string, """
            苏武腿。天苍茫，月迷茫，不知是看词还是看腿。
            now the full article is here
            苏武牧羊 (Su Wu Mu Yang)
            xahmusic.org/music/su_wu_mu_ya...
            """
        )
    }
}
