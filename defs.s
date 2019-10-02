; Main stuff
const LineYInput 10
const LineYHelp 11
const LineYStatus 12

; Pos stuff
const ColourWhite        32 ; 0010 0000
const ColourBlack        64 ; 0100 0000
const ColourBoth         96 ; 0110 0000

const PieceFlagNotSlider  8 ; 0000 1000
const PieceFlagKing      16 ; 0001 0000
const PieceFlagVirgin   128 ; 1000 0000 i.e. not moved
const PieceFlagVirginNeg 127; 0111 1111

const PieceTypeNone       0 ; 0000 0000
const PieceTypePawn      10 ; 0000 1010
const PieceTypeKnight    11 ; 0000 1011
const PieceTypeBishop     6 ; 0000 0110
const PieceTypeRook       5 ; 0000 0101
const PieceTypeQueen      1 ; 0000 0001
const PieceTypeKing      28 ; 0001 1100
const PieceTypeMask      31 ; 0001 1111

const PN                  0 ; 0000 0000
const PWP                42 ; 0010 1010
const PWN                43 ; 0010 1011
const PWB                38 ; 0010 0110
const PWR                37 ; 0010 0101
const PWQ                33 ; 0010 0001
const PWK                60 ; 0011 1100
const PBP                74 ; 0100 1010
const PBN                75 ; 0100 1011
const PBB                70 ; 0100 0110
const PBR                69 ; 0100 0101
const PBQ                65 ; 0100 0001
const PBK                92 ; 0101 1100

const PVWP              170 ; 1010 1010
const PVWN              171 ; 1010 1011
const PVWB              166 ; 1010 0110
const PVWR              165 ; 1010 0101
const PVWQ              163 ; 1010 0001
const PVWK              188 ; 1011 1100
const PVBP              202 ; 1100 1010
const PVBN              203 ; 1100 1011
const PVBB              198 ; 1100 0110
const PVBR              197 ; 1100 0101
const PVBQ              193 ; 1100 0001
const PVBK              220 ; 1101 1100

; Move stuff
const MoveInvalid 0

const moveToStrMinSize 6
