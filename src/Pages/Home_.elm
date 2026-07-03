module Pages.Home_ exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)


page : View msg
page =
    { title = "lab"
    , body =
        [ main_ [ class "home" ]
            [ section [ class "hero" ]
                [ h1 [ class "catchphrase" ] [ text "テステスhogehoge" ]
                , nav [ class "home-nav" ]
                    [ a [ href "/works" ] [ text "作品" ]
                    , a [ href "/log" ] [ text "ログ" ]
                    ]
                ]

            -- issue #25: お気に入りの1作品を Featured Work としてここに埋め込む
            ]
        ]
    }
