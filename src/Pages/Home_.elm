module Pages.Home_ exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import PageTitle
import View exposing (View)


page : View msg
page =
    { title = PageTitle.siteName
    , body =
        [ main_ [ class "home" ]
            [ section [ class "hero" ]
                [ h1 [ class "catchphrase" ] [ text "テステスhogehoge" ]
                , nav [ class "home-nav" ]
                    [ a [ href "/input" ] [ text "input" ]
                    , a [ href "/output" ] [ text "output" ]
                    ]
                ]

            -- issue #25: お気に入りの1作品を Featured Work としてここに埋め込む
            ]
        ]
    }
