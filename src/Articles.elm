module Articles exposing
    ( Article
    , ArticleMeta
    , fetchList
    , fetchOne
    , render
    )

import Html exposing (Html)
import Http
import Json.Decode as Decode exposing (Decoder)
import Markdown.Parser
import Markdown.Renderer


{-| 記事データはFirestoreの `articles` コレクションから直接取得する
（バックエンド稼働前の暫定対応）。Security Rulesで `articles` の
読み取りのみ公開しており、書き込みはCIからのAdmin SDK経由のみ許可している。
-}
projectId : String
projectId =
    "b-website-prod"


baseUrl : String
baseUrl =
    "https://firestore.googleapis.com/v1/projects/" ++ projectId ++ "/databases/(default)/documents"


type alias ArticleMeta =
    { slug : String
    , title : String
    , date : String
    , tags : List String
    }


type alias Article =
    { meta : ArticleMeta
    , body : String
    }


{-| 記事一覧を取得する。Firestoreの1コレクションあたりの読み取りAPIを
そのまま利用しており、現時点ではタグ絞り込み・ページネーションは行わず
全件を返す（将来、必要になった時点で `runQuery` ベースのクエリに拡張する）。
-}
fetchList : (Result Http.Error (List Article) -> msg) -> Cmd msg
fetchList toMsg =
    Http.get
        { url = baseUrl ++ "/articles"
        , expect = Http.expectJson toMsg documentsListDecoder
        }


fetchOne : String -> (Result Http.Error Article -> msg) -> Cmd msg
fetchOne slug toMsg =
    Http.get
        { url = baseUrl ++ "/articles/" ++ slug
        , expect = Http.expectJson toMsg articleDecoder
        }


render : String -> List (Html msg)
render markdownContent =
    markdownContent
        |> Markdown.Parser.parse
        |> Result.mapError (always "parse error")
        |> Result.andThen (Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer)
        |> Result.withDefault [ Html.text markdownContent ]



-- DECODING (Firestore REST API のドキュメント形式)
-- https://firestore.googleapis.com/v1/{document} は
-- { "name": "projects/.../documents/articles/<slug>", "fields": { "title": {"stringValue": ...}, ... } }
-- という型付きフィールド形式で返す。


documentsListDecoder : Decoder (List Article)
documentsListDecoder =
    Decode.oneOf
        [ Decode.field "documents" (Decode.list articleDecoder)
        , Decode.succeed []
        ]


articleDecoder : Decoder Article
articleDecoder =
    Decode.map2 Article metaDecoder (stringField "body")


metaDecoder : Decoder ArticleMeta
metaDecoder =
    Decode.map4 ArticleMeta
        (Decode.field "name" Decode.string |> Decode.map slugFromDocumentName)
        (stringField "title")
        (stringField "date")
        tagsField


slugFromDocumentName : String -> String
slugFromDocumentName name =
    name
        |> String.split "/"
        |> List.reverse
        |> List.head
        |> Maybe.withDefault name


stringField : String -> Decoder String
stringField key =
    Decode.at [ "fields", key, "stringValue" ] Decode.string


tagsField : Decoder (List String)
tagsField =
    Decode.oneOf
        [ Decode.at [ "fields", "tags", "arrayValue", "values" ]
            (Decode.list (Decode.field "stringValue" Decode.string))
        , Decode.succeed []
        ]
