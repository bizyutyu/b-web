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
        -- elm-land の Page Model Msg 構造上 NoOp 等のダミーコンストラクタが必要になるため
        -- src/Pages/ と WorkPage コンポーネントを除外する
        |> Rule.ignoreErrorsForDirectories [ ".elm-land", "src/Pages", "src/Components" ]
    , NoUnused.Parameters.rule
        -- elm-land の page 関数は Shared.Model -> Route () を必ず受け取る設計のため
        -- src/Pages/ ではパラメータ未使用を許容する
        |> Rule.ignoreErrorsForDirectories [ ".elm-land", "src/Pages" ]
    , NoUnused.Patterns.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    , NoUnused.Variables.rule
        |> Rule.ignoreErrorsForDirectories [ ".elm-land" ]
    ]
