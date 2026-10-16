module Works exposing (WorkEntry, all, findBySlug)

import Components.WorkPage exposing (WorkPage)


{-| `slug` は `/output/:slug` の URL になる。作品・記事（Firestore の
`articles` ドキュメント ID）を横断して一意でなければならず、重複は許さない。
-}
type alias WorkEntry =
    { slug : String
    , work : WorkPage
    }


all : List WorkEntry
all =
    []


findBySlug : String -> Maybe WorkEntry
findBySlug slug =
    all
        |> List.filter (\entry -> entry.slug == slug)
        |> List.head
