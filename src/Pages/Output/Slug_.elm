module Pages.Output.Slug_ exposing (Model, Msg, page)

import Articles exposing (Article)
import Components.WorkPage as WorkPage
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page exposing (Page)
import PageTitle
import Route exposing (Route)
import Shared
import View exposing (View)
import Works exposing (WorkEntry)


page : Shared.Model -> Route { slug : String } -> Page Model Msg
page _ route =
    Page.new
        { init = init route.params.slug
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MODEL


{-| 作品は Elm コード内の静的データ、記事は Firestore から取得する。
slug はまず作品から引き、見つからなければ記事として取得する。

slug は output 全体（作品・記事の横断）で一意でなければならず、重複は許さない。
重複した場合に作品側が優先されるのはこの解決順による結果であって、仕様ではない。
-}
type Model
    = WorkFound WorkEntry
    | Loading
    | Loaded Article
    | Failed


init : String -> () -> ( Model, Effect Msg )
init slug () =
    case Works.findBySlug slug of
        Just entry ->
            ( WorkFound entry, Effect.none )

        Nothing ->
            if isValidSlug slug then
                ( Loading
                , Effect.sendCmd (Articles.fetchOne slug GotArticle)
                )

            else
                ( Failed, Effect.none )


{-| slug は `^[a-z0-9-]+$` に限る。URL 由来の任意の文字列を Firestore へ
送らないための多層防御（読み取り制御の本体は Security Rules 側）。
-}
isValidSlug : String -> Bool
isValidSlug slug =
    not (String.isEmpty slug)
        && String.all (\c -> Char.isLower c || Char.isDigit c || c == '-') slug



-- UPDATE


type Msg
    = GotArticle (Result Http.Error Article)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotArticle (Ok article) ->
            ( Loaded article, Effect.none )

        GotArticle (Err _) ->
            ( Failed, Effect.none )



-- VIEW


view : Model -> View Msg
view model =
    case model of
        WorkFound entry ->
            WorkPage.view entry.work

        Loading ->
            { title = PageTitle.format "読み込み中..."
            , body = [ main_ [] [ p [] [ text "読み込み中..." ] ] ]
            }

        Loaded article ->
            { title = PageTitle.format article.meta.title
            , body =
                [ main_ [ class "article-page" ]
                    [ a [ href "/output", class "back-link" ] [ text "← output 一覧" ]
                    , header [ class "article-header" ]
                        [ h1 [] [ text article.meta.title ]
                        , p [ class "article-date" ] [ text article.meta.date ]
                        ]
                    , div [ class "article-body" ]
                        (Articles.render article.body)
                    ]
                ]
            }

        Failed ->
            { title = PageTitle.format "エラー"
            , body =
                [ main_ []
                    [ p [] [ text "ページが見つからないか、読み込みに失敗しました。" ]
                    , a [ href "/output" ] [ text "← output 一覧に戻る" ]
                    ]
                ]
            }
