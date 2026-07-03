module Pages.Work.Slug_ exposing (Model, Msg, page)

import Components.WorkPage as WorkPage
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)
import Works


page : Shared.Model -> Route { slug : String } -> Page Model Msg
page _ route =
    Page.new
        { init = init route.params.slug
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MODEL


type alias Model =
    Maybe Works.WorkEntry


type Msg
    = NoOp


init : String -> () -> ( Model, Effect Msg )
init slug () =
    ( Works.findBySlug slug, Effect.none )



-- UPDATE


update : Msg -> Model -> ( Model, Effect Msg )
update _ model =
    ( model, Effect.none )



-- VIEW


view : Model -> View Msg
view model =
    case model of
        Nothing ->
            { title = "作品が見つかりません"
            , body =
                [ main_ []
                    [ p [] [ text "存在しない作品です。" ]
                    , a [ href "/work" ] [ text "← 作品一覧に戻る" ]
                    ]
                ]
            }

        Just entry ->
            WorkPage.view entry.work
