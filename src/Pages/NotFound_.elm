module Pages.NotFound_ exposing (Model, Msg, page)

import Effect
import Html exposing (..)
import Html.Attributes exposing (..)
import Page exposing (Page)
import PageTitle
import Route exposing (Route)
import Shared
import View exposing (View)


{-| elm-land は NotFound\_ を Page として扱うため、静的な内容でも
Model / Msg を持つ Page.new の形を維持する。
-}
page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = \() -> ( {}, Effect.none )
        , update = \_ model -> ( model, Effect.none )
        , subscriptions = \_ -> Sub.none
        , view = \_ -> view
        }


type alias Model =
    {}


type Msg
    = NoOp


view : View Msg
view =
    { title = PageTitle.format "ページが見つかりません"
    , body =
        [ main_ [ class "not-found-page" ]
            [ h1 [] [ text "404" ]
            , p [] [ text "お探しのページは見つかりませんでした。" ]
            , a [ href "/" ] [ text "← トップに戻る" ]
            ]
        ]
    }
