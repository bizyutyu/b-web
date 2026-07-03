module Components.WorkPage exposing (RelatedWork, WorkPage, WorkType(..), view)

import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)


type WorkType
    = Game { embedUrl : Maybe String, gifUrl : Maybe String }
    | Beat { waveformUrl : String }
    | Toy { embedUrl : String }


type alias RelatedWork =
    { title : String
    , url : String
    }


type alias WorkPage =
    { title : String
    , tagline : String
    , workType : WorkType
    , actionUrl : String
    , badges : List String
    , devlogUrl : Maybe String
    , relatedWorks : List RelatedWork
    -- フェーズ2以降で表示予定: エンジニアサイトへの昇格リンク（フェーズ1は非表示）
    , engineerSiteUrl : Maybe String
    }


view : WorkPage -> View msg
view work =
    { title = work.title
    , body =
        [ main_ [ class "work-page" ]
            [ viewHero work.title work.tagline
            , viewExperienceZone work.workType
            , viewMainAction (actionLabel work.workType) work.actionUrl
            , viewBadges work.badges
            , viewDevlogLink work.devlogUrl
            , viewRelatedWorks work.relatedWorks
            ]
        ]
    }


actionLabel : WorkType -> String
actionLabel workType =
    case workType of
        Game _ ->
            "遊ぶ"

        Beat _ ->
            "聴く"

        Toy _ ->
            "叩く"


viewHero : String -> String -> Html msg
viewHero title_ tagline =
    header [ class "work-hero" ]
        [ h1 [] [ text title_ ]
        , p [ class "work-tagline" ] [ text tagline ]
        ]


viewExperienceZone : WorkType -> Html msg
viewExperienceZone workType =
    section [ class "work-experience" ]
        [ case workType of
            Game { embedUrl, gifUrl } ->
                viewGameZone embedUrl gifUrl

            Beat { waveformUrl } ->
                viewBeatZone waveformUrl

            Toy { embedUrl } ->
                viewToyZone embedUrl
        ]


viewGameZone : Maybe String -> Maybe String -> Html msg
viewGameZone embedUrl gifUrl =
    case ( embedUrl, gifUrl ) of
        ( Just url, _ ) ->
            iframe
                [ src url
                , attribute "allowfullscreen" ""
                , class "game-embed"
                ]
                []

        ( Nothing, Just url ) ->
            img [ src url, alt "ゲームプレイ画像", class "game-gif" ] []

        ( Nothing, Nothing ) ->
            div [ class "experience-placeholder" ] [ text "▶ ゲームを表示予定" ]


viewBeatZone : String -> Html msg
viewBeatZone waveformUrl =
    div [ class "beat-player" ]
        [ audio [ src waveformUrl, controls True ] []
        , div [ class "waveform-placeholder" ] [ text "〜 波形プレイヤー 〜" ]
        ]


viewToyZone : String -> Html msg
viewToyZone embedUrl =
    iframe
        [ src embedUrl
        , class "toy-embed"
        ]
        []


viewMainAction : String -> String -> Html msg
viewMainAction label url =
    section [ class "work-action" ]
        [ a [ href url, class "action-button" ] [ text label ]
        ]


viewBadges : List String -> Html msg
viewBadges badges =
    if List.isEmpty badges then
        text ""

    else
        section [ class "work-badges" ]
            [ ul [] (List.map (\badge -> li [] [ text badge ]) badges)
            ]


viewDevlogLink : Maybe String -> Html msg
viewDevlogLink maybeUrl =
    case maybeUrl of
        Nothing ->
            text ""

        Just url ->
            section [ class "work-devlog" ]
                [ a [ href url, class "devlog-link" ] [ text "制作日誌を読む →" ]
                ]


viewRelatedWorks : List RelatedWork -> Html msg
viewRelatedWorks related =
    if List.isEmpty related then
        text ""

    else
        section [ class "work-related" ]
            [ h2 [] [ text "関連作品" ]
            , ul []
                (List.map
                    (\r -> li [] [ a [ href r.url ] [ text r.title ] ])
                    related
                )
            ]
