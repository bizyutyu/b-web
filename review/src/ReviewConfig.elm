module ReviewConfig exposing (config)

import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule as Rule exposing (Rule)


config : List Rule
config =
    -- NoUnused.Dependencies/Modules/Exports は除外:
    -- .elm-land/ が .gitignore に載り elm-review のスキャン対象外になるため、
    -- それらのファイルに依存する src/ 側の定義が誤って「未使用」と報告される
    [ NoUnused.CustomTypeConstructorArgs.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.CustomTypeConstructors.rule []
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Parameters.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Patterns.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Variables.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    ]
