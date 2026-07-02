module Pages.Works.Sample exposing (page)

import Components.WorkPage as WorkPage exposing (WorkPage, WorkType(..))
import View exposing (View)


page : View msg
page =
    { title = "作品ページ雛形デモ"
    , body =
        (WorkPage.view gameExample).body
            ++ (WorkPage.view beatExample).body
            ++ (WorkPage.view toyExample).body
    }


gameExample : WorkPage
gameExample =
    { title = "サンプルゲーム"
    , tagline = "ブラウザで遊べるゲームの体験ゾーン例"
    , workType = Game { embedUrl = Nothing, gifUrl = Nothing }
    , actionUrl = "#"
    , badges = [ "🎮 インタラクティブ", "🎯 シングルプレイ" ]
    , devlogUrl = Just "/log/sample-game-devlog"
    , relatedWorks = []
    }


beatExample : WorkPage
beatExample =
    { title = "サンプルビート"
    , tagline = "波形プレイヤーの体験ゾーン例"
    , workType = Beat { waveformUrl = "/audio/sample.mp3" }
    , actionUrl = "#"
    , badges = [ "🎵 アンビエント", "🎧 ヘッドホン推奨" ]
    , devlogUrl = Nothing
    , relatedWorks = []
    }


toyExample : WorkPage
toyExample =
    { title = "サンプルToy"
    , tagline = "生ウィジェットの体験ゾーン例"
    , workType = Toy { embedUrl = "https://example.com/demo" }
    , actionUrl = "#"
    , badges = [ "🤖 AI", "⚡ リアルタイム" ]
    , devlogUrl = Just "/log/sample-toy-devlog"
    , relatedWorks = [ { title = "サンプルゲーム", url = "/works/sample" } ]
    }
