//
//  PhanpyTests.swift
//  PhanpyTests
//
//  Created by 李孛 on 2018/12/8.
//

import XCTest
@testable import Phanpy

final class PhanpyTests: XCTestCase {
    func testStatusContentParser0() {
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

    func testStatusContentParser1() {
        // swiftlint:disable line_length
        let content = """
            <p>hit or miss<br />I guess they never miss huh<br />You got a comfort character<br />I bet he doesn't kiss ya<br />MWAH</p>
            """
        // swiftlint:enable line_length
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.output.string, """
            hit or miss
            I guess they never miss huh
            You got a comfort character
            I bet he doesn't kiss ya
            MWAH
            """
        )
    }

    func testStatusContentParser2() {
        // swiftlint:disable line_length
        let content = """
            Donald Trump wechselt zum zweiten Mal seinen Stabschef im Weißen Haus aus. John Kelly werde zum Jahreswechsel gehen, so der US-Präsident. Ein Nachfolger soll bis Montag feststehen. <a href="https://www.zdf.de/nachrichten/heute/us-praesident-trump-wechselt-abermals-stabschef-im-weissen-haus-aus-100.html" rel="nofollow noopener" target="_blank">www.zdf.de/nachrichten/heute/u…</a>
            """
        // swiftlint:enable line_length
        let parser = StatusContentParser(content: content)
        // swiftlint:disable line_length
        XCTAssertEqual(parser.output.string, """
            Donald Trump wechselt zum zweiten Mal seinen Stabschef im Weißen Haus aus. John Kelly werde zum Jahreswechsel gehen, so der US-Präsident. Ein Nachfolger soll bis Montag feststehen. www.zdf.de/nachrichten/heute/u…
            """
        )
        // swiftlint:enable line_length
    }

    func testStatusContentParser3() {
        // swiftlint:disable line_length
        let content = """
            <p><span>あと仕事でコード書いてるからな</span></p>
            """
        // swiftlint:enable line_length
        let parser = StatusContentParser(content: content)
        // swiftlint:disable line_length
        XCTAssertEqual(parser.output.string, """
            あと仕事でコード書いてるからな
            """
        )
        // swiftlint:enable line_length
    }
}
