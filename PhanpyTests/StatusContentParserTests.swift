//
//  StatusContentParserTests.swift
//  PhanpyTests
//
//  Created by 李孛 on 2018/12/9.
//

import XCTest
@testable import Phanpy

// swiftlint:disable line_length

final class StatusContentParserTests: XCTestCase {
    func test0() {
        let content = """
            <p>苏武腿。天苍茫，月迷茫，不知是看词还是看腿。<br>now the full article is here<br>苏武牧羊 (Su Wu Mu Yang)<br><a href="http://xahmusic.org/music/su_wu_mu_yang.html" rel="nofollow noopener" target="_blank"><span class="invisible">http://</span><span class="ellipsis">xahmusic.org/music/su_wu_mu_ya</span><span class="invisible">ng.html</span></a></p>
            """
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.parse().string, """
            苏武腿。天苍茫，月迷茫，不知是看词还是看腿。
            now the full article is here
            苏武牧羊 (Su Wu Mu Yang)
            xahmusic.org/music/su_wu_mu_ya...
            """
        )
    }

    func test1() {
        let content = """
            <p>hit or miss<br />I guess they never miss huh<br />You got a comfort character<br />I bet he doesn't kiss ya<br />MWAH</p>
            """
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.parse().string, """
            hit or miss
            I guess they never miss huh
            You got a comfort character
            I bet he doesn't kiss ya
            MWAH
            """
        )
    }

    func test2() {
        let content = """
            Donald Trump wechselt zum zweiten Mal seinen Stabschef im Weißen Haus aus. John Kelly werde zum Jahreswechsel gehen, so der US-Präsident. Ein Nachfolger soll bis Montag feststehen. <a href="https://www.zdf.de/nachrichten/heute/us-praesident-trump-wechselt-abermals-stabschef-im-weissen-haus-aus-100.html" rel="nofollow noopener" target="_blank">www.zdf.de/nachrichten/heute/u…</a>
            """
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.parse().string, """
            Donald Trump wechselt zum zweiten Mal seinen Stabschef im Weißen Haus aus. John Kelly werde zum Jahreswechsel gehen, so der US-Präsident. Ein Nachfolger soll bis Montag feststehen. www.zdf.de/nachrichten/heute/u…
            """
        )
    }

    func test3() {
        let content = """
            <p><span>あと仕事でコード書いてるからな</span></p>
            """
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.parse().string, """
            あと仕事でコード書いてるからな
            """
        )
    }

    func test4() {
        let content = """
            <p>Test, <a href="https://www.apple.com" rel="nofollow noopener" target="_blank"><span class="invisible">https://www.</span><span class="">apple.com</span><span class="invisible"></span></a> Yo.<br /><span class="h-card"><a href="https://mastodon.social/@libei" class="u-url mention">@<span>libei</span></a></span> is a test.</p><p>Yo!</p><p><a href="https://www.apple.com/cn/shop/buy-mac/macbook-air" rel="nofollow noopener" target="_blank"><span class="invisible">https://www.</span><span class="ellipsis">apple.com/cn/shop/buy-mac/macb</span><span class="invisible">ook-air</span></a></p>
            """
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.parse().string, """
            Test, apple.com Yo.
            @libei is a test.

            Yo!

            apple.com/cn/shop/buy-mac/macb...
            """
        )
    }

    func test5() {
        let content = """
            <p><a href="https://mastodon.social/tags/apple" class="mention hashtag" rel="tag">#<span>apple</span></a></p>
            """
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.parse(), NSAttributedString(string: "#apple", attributes: [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .link: URL(string: "https://mastodon.social/tags/apple")!,
        ]))
    }

    func test6() {
        let content = """
            <p>Redmine 4.0がリリースされました。また、同時に3.4.7と3.3.9もリリースされています。昨年7月の3.4.0以来、一年以上ぶりのメジャーバージョンアップとなりました。</p><p>▶ Redmine 4.0.0, 3.4.7 and 3.3.9 released<br><a href="https://www.redmine.org/news/119" rel="nofollow noopener" target="_blank"><span class="invisible">https://www.</span><span class="">redmine.org/news/119</span><span class="invisible"></span></a></p><p>Redmine 4.0の改善点のいくつかは以下の資料で解説しています。</p><p>▶ Redmine 4.0 おすすめ新機能 ピックアップ（第2版）<br><a href="https://www.slideshare.net/g_maeda/redmine-40-2" rel="nofollow noopener" target="_blank"><span class="invisible">https://www.</span><span class="ellipsis">slideshare.net/g_maeda/redmine</span><span class="invisible">-40-2</span></a></p><p>また、その中から特に個人的に気に入っている機能をピックアップして以下のページで紹介しています。</p><p>▶ リリース間近のRedmine 4.0.0 前田の個人的お気に入り新機能7選<br><a href="https://www.farend.co.jp/blog/2018/10/redmine-4/" rel="nofollow noopener" target="_blank"><span class="invisible">https://www.</span><span class="ellipsis">farend.co.jp/blog/2018/10/redm</span><span class="invisible">ine-4/</span></a></p><p>手っ取り早く4.0を試してみたい方は以下のデモサイトをご利用ください。</p><p><a href="https://my.redmine.jp/demo/" rel="nofollow noopener" target="_blank"><span class="invisible">https://</span><span class="">my.redmine.jp/demo/</span><span class="invisible"></span></a></p>
            """
        let parser = StatusContentParser(content: content)
        XCTAssertEqual(parser.parse().string, """
            Redmine 4.0がリリースされました。また、同時に3.4.7と3.3.9もリリースされています。昨年7月の3.4.0以来、一年以上ぶりのメジャーバージョンアップとなりました。

            ▶ Redmine 4.0.0, 3.4.7 and 3.3.9 released
            redmine.org/news/119

            Redmine 4.0の改善点のいくつかは以下の資料で解説しています。

            ▶ Redmine 4.0 おすすめ新機能 ピックアップ（第2版）
            slideshare.net/g_maeda/redmine...

            また、その中から特に個人的に気に入っている機能をピックアップして以下のページで紹介しています。

            ▶ リリース間近のRedmine 4.0.0 前田の個人的お気に入り新機能7選
            farend.co.jp/blog/2018/10/redm...

            手っ取り早く4.0を試してみたい方は以下のデモサイトをご利用ください。

            my.redmine.jp/demo/
            """
        )
    }
}

// swiftlint:enable line_length
