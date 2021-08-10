module Icon exposing (github, twitter)

import Element exposing (Element)
import Element.Border as Border
import Element.Font as Font
import Element.Keyed
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Json.Encode as Encode
import Request.GoogleCalendar as GoogleCalendar
import SanityApi.Object
import SanityApi.Object.Guest
import SanityApi.Object.Image
import SanityApi.Object.LiveStream
import SanityApi.Object.Project
import SanityApi.Object.SanityImageAsset
import SanityApi.Query as Query
import Scalar exposing (DateTime)
import Style
import Style.Helpers as Helpers
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Utilities as Tw
import Time
import View.FontAwesome as FontAwesome
import Youtube


twitter : Html msg
twitter =
    icon "M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z"


github : Html msg
github =
    icon "M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"


icon : String -> Html msg
icon svgPath =
    Svg.svg
        [ SvgAttr.width "15"
        , SvgAttr.height "15"
        , SvgAttr.viewBox "0 0 24 24"
        , SvgAttr.fill "currentColor"
        ]
        [ Svg.path
            [ SvgAttr.d svgPath
            ]
            []
        ]
