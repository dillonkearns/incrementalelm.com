module CourseIcon exposing (..)

import Html.Styled exposing (Html)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Utilities as Tw


elmTsInterop : Html msg
elmTsInterop =
    svg
        [ SvgAttr.width "500"
        , SvgAttr.height "281.5"
        , SvgAttr.viewBox "0 0 1000 563"
        , SvgAttr.fill "none"
        , SvgAttr.css
            [ Tw.max_w_full
            , Tw.bg_white
            ]
        ]
        [ Svg.rect
            [ SvgAttr.x "119"
            , SvgAttr.y "133"
            , SvgAttr.width "295"
            , SvgAttr.height "295"
            , SvgAttr.fill "white"
            ]
            []
        , path
            [ SvgAttr.d "M128.828 428L266.417 290.411L404.006 428H128.828Z"
            , SvgAttr.fill "#1293D8"
            , SvgAttr.fillOpacity "0.75"
            ]
            []
        , path
            [ SvgAttr.d "M119 142.994L256.589 280.583L119 418.172L119 142.994Z"
            , SvgAttr.fill "#1293D8"
            , SvgAttr.fillOpacity "0.75"
            ]
            []
        , path
            [ SvgAttr.d "M276.404 133H414V270.596L276.404 133Z"
            , SvgAttr.fill "#1293D8"
            , SvgAttr.fillOpacity "0.75"
            ]
            []
        , path
            [ SvgAttr.d "M276.245 280.583L340.125 344.464L404.006 280.583L340.125 216.702L276.245 280.583Z"
            , SvgAttr.fill "#1293D8"
            , SvgAttr.fillOpacity "0.75"
            ]
            []
        , path
            [ SvgAttr.d "M128.828 133.166H256.589L316.539 193.116H188.777L128.828 133.166Z"
            , SvgAttr.fill "#1293D8"
            , SvgAttr.fillOpacity "0.75"
            ]
            []
        , path
            [ SvgAttr.d "M330.298 206.875L266.417 270.755L202.536 206.875H330.298Z"
            , SvgAttr.fill "#1293D8"
            , SvgAttr.fillOpacity "0.75"
            ]
            []
        , path
            [ SvgAttr.d "M413.834 418.172L349.953 354.292L413.834 290.411V418.172Z"
            , SvgAttr.fill "#1293D8"
            , SvgAttr.fillOpacity "0.75"
            ]
            []
        , path
            [ SvgAttr.d "M851.191 133H613.809C597.898 133 585 145.898 585 161.809V399.191C585 415.102 597.898 428 613.809 428H851.191C867.102 428 880 415.102 880 399.191V161.809C880 145.898 867.102 133 851.191 133Z"
            , SvgAttr.fill "#3178C6"
            ]
            []
        , path
            [ SvgAttr.d "M851.191 133H613.809C597.898 133 585 145.898 585 161.809V399.191C585 415.102 597.898 428 613.809 428H851.191C867.102 428 880 415.102 880 399.191V161.809C880 145.898 867.102 133 851.191 133Z"
            , SvgAttr.fill "#3178C6"
            ]
            []
        , path
            [ SvgAttr.fillRule "evenodd"
            , SvgAttr.clipRule "evenodd"
            , SvgAttr.d "M767.611 367.746V396.59C772.3 398.994 777.846 400.796 784.248 401.998C790.651 403.2 797.398 403.801 804.492 403.801C811.406 403.801 817.973 403.14 824.195 401.818C830.417 400.496 835.873 398.317 840.562 395.283C845.25 392.249 848.963 388.282 851.698 383.385C854.433 378.487 855.801 372.433 855.801 365.223C855.801 359.994 855.019 355.413 853.456 351.477C851.893 347.541 849.639 344.041 846.693 340.976C843.748 337.911 840.216 335.162 836.098 332.728C831.98 330.295 827.336 327.996 822.166 325.833C818.379 324.271 814.982 322.754 811.977 321.281C808.971 319.809 806.416 318.307 804.312 316.775C802.208 315.242 800.585 313.62 799.443 311.907C798.301 310.194 797.729 308.257 797.729 306.093C797.729 304.11 798.24 302.323 799.262 300.73C800.284 299.137 801.727 297.771 803.59 296.629C805.454 295.487 807.738 294.601 810.443 293.97C813.149 293.339 816.154 293.024 819.461 293.024C821.865 293.024 824.405 293.204 827.08 293.564C829.756 293.925 832.446 294.481 835.151 295.232C837.856 295.983 840.486 296.93 843.041 298.071C845.596 299.213 847.956 300.535 850.12 302.037V275.086C845.732 273.404 840.937 272.157 835.737 271.346C830.537 270.535 824.571 270.129 817.838 270.129C810.984 270.129 804.492 270.865 798.36 272.337C792.229 273.809 786.834 276.108 782.174 279.232C777.515 282.358 773.833 286.338 771.128 291.176C768.423 296.013 767.07 301.796 767.07 308.527C767.07 317.12 769.55 324.451 774.51 330.52C779.469 336.589 786.998 341.727 797.098 345.934C801.066 347.556 804.763 349.148 808.189 350.711C811.616 352.273 814.577 353.896 817.071 355.578C819.566 357.26 821.535 359.093 822.978 361.076C824.421 363.059 825.142 365.312 825.142 367.837C825.142 369.699 824.691 371.427 823.789 373.019C822.888 374.612 821.52 375.994 819.686 377.166C817.853 378.337 815.568 379.254 812.833 379.914C810.098 380.576 806.897 380.906 803.23 380.906C796.978 380.906 790.786 379.81 784.654 377.616C778.522 375.423 772.841 372.133 767.611 367.746V367.746ZM719.121 296.68H756.123V273.01H652.988V296.68H689.809V402.072H719.121V296.68Z"
            , SvgAttr.fill "white"
            ]
            []
        , path
            [ SvgAttr.d "M442.867 247.268L441.615 245.709L441.615 245.709L442.867 247.268ZM556.054 246.623L557.289 245.05L557.289 245.05L556.054 246.623ZM568 256L559.397 234.568L545.138 252.734L568 256ZM433.253 257.559L444.12 248.827L441.615 245.709L430.747 254.441L433.253 257.559ZM444.12 248.827C476.384 222.902 522.262 222.641 554.819 248.196L557.289 245.05C523.268 218.346 475.329 218.619 441.615 245.709L444.12 248.827Z"
            , SvgAttr.fill "black"
            ]
            []
        , path
            [ SvgAttr.d "M557.133 314.732L558.385 316.291L558.385 316.291L557.133 314.732ZM443.946 315.377L442.711 316.95L442.711 316.95L443.946 315.377ZM432 306L440.603 327.432L454.862 309.266L432 306ZM566.747 304.441L555.88 313.173L558.385 316.291L569.253 307.559L566.747 304.441ZM555.88 313.173C523.616 339.098 477.738 339.359 445.181 313.804L442.711 316.95C476.732 343.654 524.671 343.381 558.385 316.291L555.88 313.173Z"
            , SvgAttr.fill "black"
            ]
            []
        ]
