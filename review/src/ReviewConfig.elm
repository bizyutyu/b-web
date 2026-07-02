module ReviewConfig exposing (config)

import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule as Rule exposing (Rule)


config : List Rule
config =
    -- NoUnused.Dependencies は除外: elm-land 生成ファイル (.elm-land/) が
    -- .gitignore に載っているため elm-review がスキャンせず、
    -- Browser/Json/Url 等が偽陽性の「未使用」として報告される
    [ NoUnused.Parameters.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Patterns.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Variables.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    ]
