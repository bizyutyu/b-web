module PageTitle exposing (format, siteName)

{-| ページ title の書式を一元管理する。各ページは「<ページ名> | lab」、
ホームのみサイト名単体を title とする。
-}


siteName : String
siteName =
    "lab"


format : String -> String
format pageTitle =
    pageTitle ++ " | " ++ siteName
