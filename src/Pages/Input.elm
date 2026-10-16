module Pages.Input exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import PageTitle
import View exposing (View)


page : View msg
page =
    { title = PageTitle.format "input"
    , body =
        [ main_ [ class "input-page" ]
            [ h1 [] [ text "input" ]

            -- issue #25: おすすめ picks 等の配置を検討中
            , p [] [ text "準備中です。" ]
            ]
        ]
    }
