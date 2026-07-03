module Works exposing (WorkEntry, all, findBySlug)

import Components.WorkPage exposing (WorkPage)


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
