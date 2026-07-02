module Articles exposing
    ( ArticleMeta
    , fetchIndex
    , fetchMarkdown
    , metaListDecoder
    , render
    )

import Html exposing (Html)
import Http
import Json.Decode as Decode exposing (Decoder)
import Markdown.Parser
import Markdown.Renderer


type alias ArticleMeta =
    { slug : String
    , title : String
    , date : String
    }


metaListDecoder : Decoder (List ArticleMeta)
metaListDecoder =
    Decode.list
        (Decode.map3 ArticleMeta
            (Decode.field "slug" Decode.string)
            (Decode.field "title" Decode.string)
            (Decode.field "date" Decode.string)
        )


fetchIndex : (Result Http.Error (List ArticleMeta) -> msg) -> Cmd msg
fetchIndex toMsg =
    Http.get
        { url = "/articles/index.json"
        , expect = Http.expectJson toMsg metaListDecoder
        }


fetchMarkdown : String -> (Result Http.Error String -> msg) -> Cmd msg
fetchMarkdown slug toMsg =
    Http.get
        { url = "/articles/" ++ slug ++ ".md"
        , expect = Http.expectString toMsg
        }


render : String -> List (Html msg)
render markdownContent =
    markdownContent
        |> Markdown.Parser.parse
        |> Result.mapError (always "parse error")
        |> Result.andThen (Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer)
        |> Result.withDefault [ Html.text markdownContent ]
