module Pages.Log exposing (Model, Msg, page)

import Articles exposing (ArticleMeta)
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
    = FetchingIndex
    | FetchingArticles Int (List ArticleMeta)
    | Ready (List ArticleMeta)
    | Failed


init : () -> ( Model, Effect Msg )
init () =
    ( FetchingIndex
    , Effect.sendCmd (Articles.fetchIndex GotSlugs)
    )



-- UPDATE


type Msg
    = GotSlugs (Result Http.Error (List String))
    | GotArticle String (Result Http.Error String)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotSlugs (Ok []) ->
            ( Ready [], Effect.none )

        GotSlugs (Ok slugs) ->
            ( FetchingArticles (List.length slugs) []
            , Effect.batch
                (List.map
                    (\slug ->
                        Effect.sendCmd
                            (Articles.fetchMarkdown slug (GotArticle slug))
                    )
                    slugs
                )
            )

        GotSlugs (Err _) ->
            ( Failed, Effect.none )

        GotArticle slug (Ok rawContent) ->
            case model of
                FetchingArticles remaining collected ->
                    let
                        article =
                            Articles.parseArticle slug rawContent

                        newCollected =
                            collected ++ [ article.meta ]

                        newRemaining =
                            remaining - 1
                    in
                    if newRemaining <= 0 then
                        ( Ready (sortByDate newCollected), Effect.none )

                    else
                        ( FetchingArticles newRemaining newCollected
                        , Effect.none
                        )

                _ ->
                    ( model, Effect.none )

        GotArticle _ (Err _) ->
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
        FetchingIndex ->
            p [] [ text "読み込み中..." ]

        FetchingArticles _ _ ->
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
