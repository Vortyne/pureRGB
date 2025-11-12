MACRO bookshelf_tile
	db \1, \2
	db_tx_pre \3
ENDM

BookshelfTileIDs:
	; tileset id, bookshelf tile id, text id
	bookshelf_tile PLATEAU,      $30, IndigoPlateauStatues
	bookshelf_tile HOUSE,        $3D, TownMapText
	bookshelf_tile HOUSE,        $1E, BookcaseText
	bookshelf_tile MANSION,      $32, BookcaseText
	bookshelf_tile REDS_HOUSE_1, $32, BookcaseText
	bookshelf_tile LAB,          $28, BookcaseText
	bookshelf_tile LOBBY,        $16, ElevatorText
	bookshelf_tile GYM,          $1D, BookcaseText
	bookshelf_tile DOJO,         $1D, BookcaseText
	bookshelf_tile GATE,         $22, BookcaseText
	bookshelf_tile MART,         $54, PokemonStuffText
	bookshelf_tile MART,         $55, PokemonStuffText
	bookshelf_tile POKECENTER,   $54, PokemonStuffText
	bookshelf_tile POKECENTER,   $55, PokemonStuffText
	bookshelf_tile LOBBY,        $50, PokemonStuffText
	bookshelf_tile LOBBY,        $52, PokemonStuffText
	bookshelf_tile SHIP,         $36, BookcaseText
	db -1 ; end
