module Pages.Log exposing (Model, Msg, page)

import Articles exposing (Article, ArticleMeta)
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MODEL


type Model
    = Fetching
    | Ready (List ArticleMeta)
    | Failed


init : () -> ( Model, Effect Msg )
init () =
    ( Fetching
    , Effect.sendCmd (Articles.fetchList GotArticles)
    )



-- UPDATE


type Msg
    = GotArticles (Result Http.Error (List Article))


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotArticles (Ok articles) ->
            ( Ready (sortByDate (List.map .meta articles)), Effect.none )

        GotArticles (Err _) ->
            ( Failed, Effect.none )



-- VIEW


view : Model -> View Msg
view model =
    { title = "ログ"
    , body =
        [ main_ [ class "log-page" ]
            [ h1 [] [ text "ログ" ]
            , viewContent model
            ]
        ]
    }


viewContent : Model -> Html Msg
viewContent model =
    case model of
        Fetching ->
            p [] [ text "読み込み中..." ]

        Ready [] ->
            p [] [ text "記事はまだありません。" ]

        Ready articles ->
            ul [ class "article-list" ]
                (List.map viewArticle articles)

        Failed ->
            p [] [ text "記事の読み込みに失敗しました。" ]


viewArticle : ArticleMeta -> Html Msg
viewArticle meta =
    li [ class "article-item" ]
        [ span [ class "article-date" ] [ text meta.date ]
        , a
            [ href ("/log/" ++ meta.slug)
            , class "article-title"
            ]
            [ text meta.title ]
        ]



-- HELPERS


sortByDate : List ArticleMeta -> List ArticleMeta
sortByDate =
    List.sortBy .date >> List.reverse
