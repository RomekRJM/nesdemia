.segment "HEADER"
.byte "NES"
.byte $1a
.byte $02 ; 2 * 16KB PRG ROM
.byte $01 ; 1 * 8KB CHR ROM
.byte %00000000 ; mapper and mirroring
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00 ; filler bytes
.segment "ZEROPAGE" ; LSB 0 - FF

.define nmiTimer $04
.define buttons $05
.define previousButtons $06
.define frame   $07
.define randomByte $08
.define spriteCounter $09
.define backgroundPointerLo $0a
.define backgroundPointerHi $0b
.define backgroundLLPointerLo $0c
.define backgroundLLPointerHi $0d
.define attributePointerLo $0e
.define attributePointerHi $0f
.define pointIndex0 $10
.define pointIndex1 $11
.define pointIndex2 $12
.define renderedNumber $13
.define renderedNumberOffset $14
.define playerCollidesWithObject $15
.define dim1Source $16
.define dim2Source $17
.define dim1Destination $18
.define dim2Destination $19
.define pillLeft $1a
.define pillTop $1b
.define pillRight $1c
.define pillBottom $1d
.define pillTimer $1e
.define pillLifeTime $1f
.define playerLeft $20
.define playerTop $21
.define playerRight $22
.define playerBottom $23
.define playerNucleusLeft $24
.define playerNucleusTop $25
.define playerInvincible $26
.define playerDashing $27
.define playerDashCount $28
.define playerSpeed $29
.define playerPallete $2a
.define playerAnimationFrame $2b
.define playerAnimationChangeFrame $2c
.define playerAttacks $2d
.define health $2e
.define initReset $2f
.define resetCounter $30
.define powerupLeft $31
.define powerupTop $32
.define powerupRight $33
.define powerupBottom $34
.define powerupTimer $35
.define powerupLifeTime $36
.define powerupType $37
.define powerupActive $38
.define dashIndex0 $39
.define dashIndex1 $3a
.define gameMode $3b
.define previousGameMode $3c
.define refreshBackground $3d
.define menuCursorTop $3e
.define difficultyLevel $3f
.define gameEndRendered $40
.define virusLeft $41
.define virusTop $42
.define virusRight $43
.define virusBottom $44
.define virusXSpeed $45
.define virusYSpeed $46
.define virusXDirection $47
.define virusYDirection $48
.define virusAlive $49
.define virusMoveFrame $4a
.define virusAnimationFrame $4b
.define virusAnimationChangeFrame $4c
.define virusSmart $4d
.define virusCntr $4e
.define virusPointer $4f
.define dbg1 $50
.define dbg2 $51
; level specific
.define levelNo $52
.define winCondition $53
.define winThreshold $54
.define points $55
.define kills $56
.define smartKills $57
.define usedPowerups $58
.define timeLimit $59
.define noViruses $5a
.define smartVirusChance $5b
.define powerupChance $5c
.define attackChance $5d
.define lastLineTextLo $5e
.define lastLineTextHi $5f
; takes 32 bits - needs to be at the end
.define backgroundLastLineTmp $60

; 0x0100 - ... - viruses

.segment "STARTUP"

JOYPAD1 = $4016
JOYPAD2 = $4017

BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

NO_VIRUSES = $0A
VIRUS_MOVE_INTERVAL = $04
VIRUS_CHANGE_FRAME_INTERVAL = $0a
VIRUS_WIDTH = $10
VIRUS_HEIGHT = $10

PILL_LIFE_TIME = $01
PILL_WIDTH = $08
PILL_HEIGHT = $08

POWERUP_LIFE_TIME = $01
POWERUP_WIDTH = $08
POWERUP_HEIGHT = $08
POWERUP_DASH = $00
POWERUP_ATTACK = $01

PLAYER_WIDTH = $10
PLAYER_HEIGHT = $10
PLAYER_DASHING_TIMEOUT = $1f
PLAYER_NORMAL_SPEED = $01
PLAYER_DASH_SPEED = $03
PLAYER_CHANGE_FRAME_INTERVAL = $08
PLAYER_ATTACK_MAX = $09
PLAYER_INVINCIBLE_DURATION = $ff
PLAYER_DASH_INCREMENT = $02
PLAYER_DASH_MAX = $10

MAIN_MENU_MODE = $00
IN_GAME_MODE = $01
GAME_OVER_MODE = $02
GAME_COMPLETED_MODE = $03

COLLISSION = $01
NO_COLLISSION = $00

LUNG_HEALTHY_ATTRIBUTE = %10101010
LUNG_SICK_ATTRIBUTE = %11111111

POINTS_TO_WIN = $1A

.include "init.asm"

JSR LoadPalettes

.include "menu_background.asm"

MainGameLoop:
  JSR GetControllerInput

  LDA gameMode
  CMP #MAIN_MENU_MODE
  BNE :+
    JSR ReactOnInputInMenu
    JSR RenderCursor
    JMP ContinueMainGameLoop
  :
  LDA gameMode
  CMP #GAME_OVER_MODE
  BNE :+
    JSR AdjustGameMode
    JSR RenderGameOver
    JMP ContinueMainGameLoop
  :
  LDA gameMode
  CMP #GAME_COMPLETED_MODE
  BNE :+
    JSR AdjustGameMode
    JSR RenderGameCompleted
    JMP ContinueMainGameLoop
  :

  JSR ReactOnInput
  JSR ComputeLogic
  JSR RenderGraphics

ContinueMainGameLoop:
  JSR ResetIfNeeded
  JSR WaitForNmi
  JMP MainGameLoop


ComputeLogic:
  JSR AdjustGameMode
  JSR SpawnPill
  JSR SpawnPowerup
  JSR CheckCollisions
  JSR MoveViruses
  JSR DashToDecimal
  JSR CheckWinCondition
  RTS

CheckCollisions:
  JSR CheckCollisionWithPill
  JSR CheckVirusesCollideWithPlayer
  JSR CheckCollisionWithPowerup
  RTS

WaitForNmi:
  LDA nmiTimer			;vblank wait
WaitForNmiLoop:
  CMP nmiTimer
  BEQ WaitForNmiLoop
  RTS

ResetIfNeeded:
  LDA initReset
  BEQ :+
    DEC resetCounter
    LDA resetCounter
    CMP #$A0
    BNE :+
      LDA #GAME_OVER_MODE
      STA gameMode
    :
    LDA resetCounter
    BNE :+
      JMP ($FFFC)
  :

  RTS

.include "nmi.asm"

.include "gamepad.asm"

RenderGraphics:
  LDA #$00
  STA spriteCounter
  JSR RenderPlayer
  JSR RenderPill
  JSR RenderPowerup
  JSR RenderViruses
  JSR RenderHUD
  .include "game_background.asm"

  RTS

RenderGameOver:
  LDA gameEndRendered

  BNE :+
    .include "game_over_background.asm"
    INC gameEndRendered
  :

  RTS

RenderGameCompleted:
  LDA gameEndRendered

  BNE :+
    .include "game_completed_background.asm"
    INC gameEndRendered
  :

  RTS

.include "attributes.asm"

.include "background.asm"

.include "game_attributes.asm"

.include "menu_attributes.asm"

.include "cursor.asm"

.include "game_mode.asm"

.include "player.asm"

.include "pallete.asm"

.include "virus.asm"

.include "hud.asm"

.include "pill.asm"

.include "powerup.asm"

.include "utils.asm"

.include "gfx.asm"

.include "level.asm"

.segment "VECTORS"
  .word NMI
  .word Reset
  ;

.segment "CHARS"
  .incbin "nesdemia.chr"
