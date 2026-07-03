module Pages.Log.Slug_ exposing (Model, Msg, page)

import Articles exposing (Article)
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route { slug : String } -> Page Model Msg
page _ route =
    Page.new
        { init = init route.params.slug
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MODEL


type Model
    = Loading String
    | Loaded Article
    | Failed


init : String -> () -> ( Model, Effect Msg )
init slug () =
    ( Loading slug
    , Effect.sendCmd (Articles.fetchMarkdown slug GotMarkdown)
    )



-- UPDATE


type Msg
    = GotMarkdown (Result Http.Error String)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotMarkdown (Ok rawContent) ->
            case model of
                Loading slug ->
                    -- SPA ホスティングは存在しないファイルを 200 + HTML で返すことがある
                    if String.startsWith "<" (String.trimLeft rawContent) then
                        ( Failed, Effect.none )

                    else
                        ( Loaded (Articles.parseArticle slug rawContent)
                        , Effect.none
                        )

                _ ->
                    ( model, Effect.none )

        GotMarkdown (Err _) ->
            ( Failed, Effect.none )



-- VIEW


view : Model -> View Msg
view model =
    case model of
        Loading _ ->
            { title = "読み込み中..."
            , body = [ main_ [] [ p [] [ text "読み込み中..." ] ] ]
            }

        Loaded article ->
            { title = article.meta.title
            , body =
                [ main_ [ class "article-page" ]
                    [ a [ href "/log", class "back-link" ] [ text "← ログ一覧" ]
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
            { title = "エラー"
            , body =
                [ main_ []
                    [ p [] [ text "記事の読み込みに失敗しました。" ]
                    , a [ href "/log" ] [ text "← ログ一覧に戻る" ]
                    ]
                ]
            }
