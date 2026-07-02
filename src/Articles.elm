module Articles exposing
    ( Article
    , ArticleMeta
    , fetchIndex
    , fetchMarkdown
    , parseArticle
    , render
    , slugListDecoder
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


type alias Article =
    { meta : ArticleMeta
    , body : String
    }


{-| index.json はスラッグのリストのみ保持する。
メタデータは各 .md ファイルの frontmatter が正とする（OKF 準拠）。
-}
slugListDecoder : Decoder (List String)
slugListDecoder =
    Decode.list Decode.string


fetchIndex : (Result Http.Error (List String) -> msg) -> Cmd msg
fetchIndex toMsg =
    Http.get
        { url = "/articles/index.json"
        , expect = Http.expectJson toMsg slugListDecoder
        }


fetchMarkdown : String -> (Result Http.Error String -> msg) -> Cmd msg
fetchMarkdown slug toMsg =
    Http.get
        { url = "/articles/" ++ slug ++ ".md"
        , expect = Http.expectString toMsg
        }


{-| rawContent から frontmatter を分離して Article を返す。
frontmatter がない場合は slug をタイトルとして扱う。
-}
parseArticle : String -> String -> Article
parseArticle slug rawContent =
    let
        ( meta, body ) =
            parseFrontmatter slug rawContent
    in
    { meta = meta, body = body }


render : String -> List (Html msg)
render markdownContent =
    markdownContent
        |> Markdown.Parser.parse
        |> Result.mapError (always "parse error")
        |> Result.andThen (Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer)
        |> Result.withDefault [ Html.text markdownContent ]



-- FRONTMATTER PARSING


parseFrontmatter : String -> String -> ( ArticleMeta, String )
parseFrontmatter slug rawContent =
    case String.lines rawContent of
        firstLine :: rest ->
            if String.trim firstLine == "---" then
                splitAtClosingDelimiter slug rest

            else
                ( fallbackMeta slug, rawContent )

        [] ->
            ( fallbackMeta slug, "" )


splitAtClosingDelimiter : String -> List String -> ( ArticleMeta, String )
splitAtClosingDelimiter slug lines =
    let
        go : List String -> List String -> ( ArticleMeta, String )
        go frontmatterLines remaining =
            case remaining of
                [] ->
                    ( fallbackMeta slug, String.join "\n" frontmatterLines )

                line :: rest ->
                    if String.trim line == "---" then
                        ( parseMeta slug frontmatterLines
                        , String.join "\n" rest |> String.trimLeft
                        )

                    else
                        go (frontmatterLines ++ [ line ]) rest
    in
    go [] lines


parseMeta : String -> List String -> ArticleMeta
parseMeta slug frontmatterLines =
    let
        pairs =
            List.filterMap parseYamlLine frontmatterLines

        getValue key =
            pairs
                |> List.filter (\( k, _ ) -> k == key)
                |> List.head
                |> Maybe.map Tuple.second
                |> Maybe.withDefault ""
    in
    { slug = slug
    , title = getValue "title"
    , date = getValue "date"
    }


parseYamlLine : String -> Maybe ( String, String )
parseYamlLine line =
    case String.indexes ":" line of
        idx :: _ ->
            let
                key =
                    String.left idx line |> String.trim

                value =
                    String.dropLeft (idx + 1) line |> String.trim
            in
            if String.isEmpty key then
                Nothing

            else
                Just ( key, value )

        [] ->
            Nothing


fallbackMeta : String -> ArticleMeta
fallbackMeta slug =
    { slug = slug, title = slug, date = "" }
