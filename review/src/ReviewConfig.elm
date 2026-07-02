module ReviewConfig exposing (config)

import NoUnused.Dependencies
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule as Rule exposing (Rule)


config : List Rule
config =
    [ NoUnused.Dependencies.rule
    , NoUnused.Parameters.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Patterns.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Variables.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    ]
