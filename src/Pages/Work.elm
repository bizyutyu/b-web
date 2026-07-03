module Pages.Work exposing (page)

import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)
import Works exposing (WorkEntry)


page : View msg
page =
    { title = "作品"
    , body =
        [ main_ [ class "work-page" ]
            [ h1 [] [ text "作品" ]
            , viewList Works.all
            ]
        ]
    }


viewList : List WorkEntry -> Html msg
viewList works =
    case works of
        [] ->
            p [] [ text "準備中です。" ]

        _ ->
            ul [ class "work-list" ]
                (List.map viewItem works)


viewItem : WorkEntry -> Html msg
viewItem entry =
    li []
        [ a [ href ("/work/" ++ entry.slug) ] [ text entry.work.title ] ]
