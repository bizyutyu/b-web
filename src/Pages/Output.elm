module Pages.Output exposing (Model, Msg, page)

import Articles exposing (Article, ArticleMeta)
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


{-| 作品・記事を output として同列に並べるための表示用の型。
作品/記事の区別方法は未確定のため、現時点では種別を持たせない。
-}
type alias OutputItem =
    { slug : String
    , title : String
    , date : Maybe String
    }


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
            ( Ready (List.map .meta articles), Effect.none )

        GotArticles (Err _) ->
            ( Failed, Effect.none )



-- VIEW


view : Model -> View Msg
view model =
    { title = PageTitle.format "output"
    , body =
        [ main_ [ class "output-page" ]
            [ h1 [] [ text "output" ]
            , viewContent model
            ]
        ]
    }


viewContent : Model -> Html Msg
viewContent model =
    case model of
        Fetching ->
            p [] [ text "読み込み中..." ]

        Failed ->
            p [] [ text "読み込みに失敗しました。" ]

        Ready articles ->
            case toItems Works.all articles of
                [] ->
                    p [] [ text "まだありません。" ]

                items ->
                    ul [ class "output-list" ]
                        (List.map viewItem items)


viewItem : OutputItem -> Html Msg
viewItem item =
    li [ class "output-item" ]
        [ case item.date of
            Just date ->
                span [ class "output-date" ] [ text date ]

            Nothing ->
                text ""
        , a
            [ href ("/output/" ++ item.slug)
            , class "output-title"
            ]
            [ text item.title ]
        ]



-- HELPERS


{-| 日付を持つ記事を新しい順に並べ、日付を持たない作品をその後ろに続ける。
-}
toItems : List WorkEntry -> List ArticleMeta -> List OutputItem
toItems works articles =
    let
        fromArticles =
            articles
                |> List.sortBy .date
                |> List.reverse
                |> List.map (\meta -> { slug = meta.slug, title = meta.title, date = Just meta.date })

        fromWorks =
            List.map (\entry -> { slug = entry.slug, title = entry.work.title, date = Nothing }) works
    in
    fromArticles ++ fromWorks
