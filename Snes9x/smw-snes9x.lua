---------------------------------------------------------------------------
--  Super Mario World (U) Utility Script for Snes9x - rr version
--  https://github.com/snes9x-rr/snes9x
--  
--  Author: Rodrigo A. do Amaral (Amaraticando)
--  Git repository: https://github.com/rodamaral/smw-tas
---------------------------------------------------------------------------

--#############################################################################
-- CONFIG:

local OPTIONS = {
    -- Hotkeys
    -- make sure that the hotkeys below don't conflict with previous bindings
    hotkey_increase_opacity = "right",  -- to increase the opacity of the text
    hotkey_decrease_opacity = "left",   -- to decrease the opacity of the text
    
    -- Display
    display_movie_info = true,
    display_misc_info = true,
    display_player_info = true,
    display_player_hitbox = true,  -- can be changed by right-clicking on player
    display_interaction_points = true,  -- can be changed by right-clicking on player
    display_sprite_info = true,
    display_sprite_hitbox = true,  -- you still have to select the sprite with the mouse
    display_extended_sprite_info = false,
    display_extended_sprite_hitbox = true,
    display_bounce_sprite_info = true,
    display_level_info = false,
    display_yoshi_info = true,
    display_counters = true,
    display_controller_input = true,
    display_debug_info = false,  -- shows useful info while investigating the game, but not very useful while TASing
    display_static_camera_region = false,  -- shows the region in which the camera won't scroll horizontally
    
    -- Script settings
    --use_custom_fonts = true,
    max_tiles_drawn = 10,  -- the max number of tiles to be drawn/registered by the script
    
    -- Cheats
    --allow_cheats = false, -- better turn off while recording a TAS
}

-- Colour settings
local COLOUR = {
    -- Text
    default_text_opacity = 1.0,
    default_bg_opacity = 0.4,
    text = 0xffffffff,--
    background = 0x000000ff,--
    outline = 0x000040ff,--
    warning = 0xff0000ff,--
    warning_bg = 0x0000ffff,--
    warning2 = 0xff00ffff,--
    weak = 0xa9a9a9ff,--
    very_weak = 0xffffff60,--
    joystick_input = 0x00ffff00,
    joystick_input_bg = 0xd0ffffff,
    button_text = 0x300030ff,--
    mainmenu_outline = 0xffffffc0,--
    mainmenu_bg = 0x000000c0,--
    
    -- hitbox and related text
    mario = 0xff0000ff,--
    mario_bg = 0,--
    mario_mounted_bg = 0,--
    interaction = 0xffffffff,--
    interaction_bg = 0x00000020,--
    interaction_nohitbox = 0x000000a0,--
    interaction_nohitbox_bg = 0x00000070,--
    
    sprites = {0x00ff00ff, 0x0000ffff, 0xffff00ff, 0xff00ffff, 0xb00040ff},--
    sprites_interaction_pts = 0xffffffff,--
    sprites_bg = 0x0000b050,--
    sprites_clipping_bg = 0x000000a0,--
    extended_sprites = 0xff8000ff,--
    goal_tape_bg = 0xffff0050,--
    fireball = 0xb0d0ffff,--
    
    yoshi = 0x00ffffff,--
    yoshi_bg = 0x00ffff40,--
    yoshi_mounted_bg = 0,--
    tongue_line = 0xffa000ff,--
    tongue_bg = 0x00000060,--
    
    cape = 0xffd700ff,--
    cape_bg = 0xffd70060,--
    
    block = 0x00008bff,--
    blank_tile = 0xffffff70,--
    block_bg = 0x22cc88a0,--
    static_camera_region = 0x40002040,--
}

-- Font settings
local SNES9X_FONT_HEIGHT = 8
local SNES9X_FONT_WIDTH = 4

-- GD images dumps (encoded)
local GD_IMAGES_DUMPS = {}
GD_IMAGES_DUMPS.player_blocked_status = {255, 254, 0, 7, 0, 10, 1, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 248, 64, 112, 0, 248, 216, 112, 0, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 40, 96, 0, 176, 40, 96, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 112, 104, 0, 248, 208, 192, 0, 0, 0, 0, 0, 248, 208, 192, 0, 248, 208, 192, 0, 248, 208, 192, 0, 136, 88, 24, 0, 0, 0, 0, 0, 248, 112, 104, 0, 248, 208, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 136, 88, 24, 0, 136, 88, 24, 0, 32, 48, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 88, 24, 0, 136, 88, 24, 0, 248, 248, 248, 0, 128, 216, 200, 0, 32, 48, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 248, 248, 0, 136, 88, 24, 0, 64, 128, 152, 0, 128, 216, 200, 0, 32, 48, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 88, 24, 0, 136, 88, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
GD_IMAGES_DUMPS.goal_tape = {255, 254, 0, 18, 0, 6, 1, 255, 255, 255, 255, 107, 153, 153, 153, 38, 75, 75, 75, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 32, 84, 84, 84, 0, 186, 186, 186, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 62, 62, 62, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 55, 55, 55, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 33, 75, 75, 75, 0, 136, 136, 136, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 106, 160, 160, 160, 40, 60, 60, 60, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40}

-- Symbols
local LEFT_ARROW = "<-"
local RIGHT_ARROW = "->"

-- Others
local Border_right, Border_left, Border_top, Border_bottom = 0, 0, 0, 0
local Buffer_width, Buffer_height, Buffer_middle_x, Buffer_middle_y = 256, 224, 128, 112
local Screen_width, Screen_height, Pixel_rate_x, Pixel_rate_y = 256, 224, 1, 1
local Y_CAMERA_OFF = 1  -- small adjustment for screen coordinates <-> object position conversion

-- Input key names
local INPUT_KEYNAMES = { -- Snes9x
    xmouse=0, ymouse=0, leftclick=false, rightclick=false, middleclick=false,
    shift=false, control=false, alt=false, capslock=false, numlock=false, scrolllock=false,
    ["false"]=false, ["1"]=false, ["2"]=false, ["3"]=false, ["4"]=false, ["5"]=false, ["6"]=false, ["7"]=false, ["8"]=false,["9"]=false,
    A=false, B=false, C=false, D=false, E=false, F=false, G=false, H=false, I=false, J=false, K=false, L=false, M=false, N=false,
    O=false, P=false, Q=false, R=false, S=false, T=false, U=false, V=false, W=false, X=false, Y=false, Z=false,
    F1=false, F2=false, F3=false, F4=false, F5=false, F6=false, F7=false, F8=false, F9=false, F1false=false, F11=false, F12=false,
    F13=false, F14=false, F15=false, F16=false, F17=false, F18=false, F19=false, F2false=false, F21=false, F22=false, F23=false, F24=false,
    backspace=false, tab=false, enter=false, pause=false, escape=false, space=false,
    pageup=false, pagedown=false, ["end"]=false, home=false, insert=false, delete=false,
    left=false, up=false, right=false, down=false,
    numpadfalse=false, numpad1=false, numpad2=false, numpad3=false, numpad4=false, numpad5=false, numpad6=false, numpad7=false, numpad8=false, numpad9=false,
    ["numpad*"]=false, ["numpad+"]=false, ["numpad-"]=false, ["numpad."]=false, ["numpad/"]=false,
    tilde=false, plus=false, minus=false, leftbracket=false, rightbracket=false,
    semicolon=false, quote=false, comma=false, period=false, slash=false, backslash=false
}

-- END OF CONFIG < < < < < < <
--#############################################################################
-- INITIAL STATEMENTS:


print("Starting script")

-- Load environment
local gui, input, joypad, emu, movie, memory = gui, input, joypad, emu, movie, memory
local unpack = unpack or table.unpack
local string, math, table, next, ipairs, pairs, io, os, type = string, math, table, next, ipairs, pairs, io, os, type
local bit = require"bit"

-- Script tries to verify whether the emulator is indeed Snes9x-rr
if snes9x == nil then
    error("This script works with Snes9x-rr emulator.")
end

-- Text/Background_max_opacity is only changed by the player using the hotkeys
-- Text/Bg_opacity must be used locally inside the functions
local Text_max_opacity = COLOUR.default_text_opacity
local Background_max_opacity = COLOUR.default_bg_opacity
local Text_opacity = 1
local Bg_opacity = 1

local fmt = string.format

-- Compatibility of the memory read/write functions
-- unsigned to signed (based in <bits> bits)
local function signed(num, bits)
    local maxval = 2^(bits - 1)
    if num < maxval then return num else return num - 2*maxval end
end
local u8  = function(address, value) if value then memory.writebyte(0x7e0000 + address, value) else
    return memory.readbyte(0x7e0000 + address) end
end
local s8  = function(address, value) if value then memory.writebyte(0x7e0000 + address, value) else
    return memory.readbytesigned(0x7e0000 + address) end
end
local u16  = function(address, value) if value then memory.writeword(0x7e0000 + address, value) else
    return memory.readword(0x7e0000 + address) end
end
local s16  = function(address, value) if value then memory.writeword(0x7e0000 + address, value) else
    return memory.readwordsigned(0x7e0000 + address) end
end
local u24  = function(address, value) if value then u16(address + 2, math.floor(value/256)) ; u8(address, value%65536) else
    return 256*u16(address + 2) + u8(address) end
end
local s24  = function(address, value) if value then u16(address + 2, math.floor(value/256)) ; u8(address, value%65536) else
    return signed(256*u16(address + 2) + u8(address), 24) end
end

-- Images (for gd library)
local IMAGES = {}
IMAGES.player_blocked_status = string.char(unpack(GD_IMAGES_DUMPS.player_blocked_status))
IMAGES.goal_tape = string.char(unpack(GD_IMAGES_DUMPS.goal_tape))

-- Hotkeys availability -- Snes9x
if INPUT_KEYNAMES[OPTIONS.hotkey_increase_opacity] == nil then
    print(string.format("Hotkey '%s' is not available, to increase opacity.", OPTIONS.hotkey_increase_opacity))
end
if INPUT_KEYNAMES[OPTIONS.hotkey_decrease_opacity] == nil then
    print(string.format("Hotkey '%s' is not available, to decrease opacity.", OPTIONS.hotkey_decrease_opacity))
end


--#############################################################################
-- GAME AND SNES SPECIFIC MACROS:


local NTSC_FRAMERATE = 60.0

local SMW = {
    -- Game Modes
    game_mode_overworld = 0x0e,
    game_mode_level = 0x14,
    
    -- Sprites
    sprite_max = 12,
    extended_sprite_max = 10,
    bounce_sprite_max = 4,
    null_sprite_id = 0xff,
    
    -- Blocks
    blank_tile_map16 = 0x25,
}

WRAM = {
    -- I/O
    ctrl_1_1 = 0x0015,
    ctrl_1_2 = 0x0017,
    firstctrl_1_1 = 0x0016,
    firstctrl_1_2 = 0x0018,
    
    -- General
    game_mode = 0x0100,
    real_frame = 0x0013,
    effective_frame = 0x0014,
    lag_indicator = 0x01fe,
    timer_frame_counter = 0x0f30,
    RNG = 0x148d,
    current_level = 0x00fe,  -- plus 1
    sprite_memory_header = 0x1692,
    lock_animation_flag = 0x009d, -- Most codes will still run if this is set, but almost nothing will move or animate.
    level_mode_settings = 0x1925,
    star_road_speed = 0x1df7,
    star_road_timer = 0x1df8,
    
    -- Cheats
    frozen = 0x13fb,
    level_paused = 0x13d4,
    level_index = 0x13bf,
    room_index = 0x00ce,
    level_flag_table = 0x1ea2,
    level_exit_type = 0x0dd5,
    midway_point = 0x13ce,
    
    -- Camera
    camera_x = 0x001a,
    camera_y = 0x001c,
    screens_number = 0x005d,
    hscreen_number = 0x005e,
    vscreen_number = 0x005f,
    vertical_scroll = 0x1412,  -- #$00 = Disable; #$01 = Enable; #$02 = Enable if flying/climbing/etc.
    camera_scroll_timer = 0x1401,
    
    -- Sprites
    sprite_status = 0x14c8,
    sprite_throw = 0x1504, --
    sprite_stun = 0x1540,
    sprite_contact_mario = 0x154c,
    spriteContactSprite = 0x1564, --
    spriteContactoObject = 0x15dc,  --
    sprite_number = 0x009e,
    sprite_x_high = 0x14e0,
    sprite_x_low = 0x00e4,
    sprite_y_high = 0x14d4,
    sprite_y_low = 0x00d8,
    sprite_x_sub = 0x14f8,
    sprite_y_sub = 0x14ec,
    sprite_x_speed = 0x00b6,
    sprite_y_speed = 0x00aa,
    sprite_direction = 0x157c,
    sprite_x_offscreen = 0x15a0, 
    sprite_y_offscreen = 0x186c,
    sprite_miscellaneous = 0x160e,
    sprite_miscellaneous2 = 0x163e,
    sprite_miscellaneous3 = 0x1528,
    sprite_miscellaneous4 = 0x1594,
    sprite_1_tweaker = 0x1656,
    sprite_2_tweaker = 0x1662,
    sprite_3_tweaker = 0x166e,
    sprite_4_tweaker = 0x167a,
    sprite_5_tweaker = 0x1686,
    sprite_6_tweaker = 0x190f,
    sprite_tongue_length = 0x151c,
    sprite_tongue_timer = 0x1558,
    sprite_tongue_wait = 0x14a3,
    sprite_yoshi_squatting = 0x18af,
    sprite_buoyancy = 0x190e,
    reznor_killed_flag = 0x151c,
    sprite_turn_around = 0x15ac,
    
    -- Extended sprites
    extspr_number = 0x170b,
    extspr_x_high = 0x1733,
    extspr_x_low = 0x171f,
    extspr_y_high = 0x1729,
    extspr_y_low = 0x1715,
    extspr_x_speed = 0x1747,
    extspr_y_speed = 0x173d,
    extspr_suby = 0x1751,
    extspr_subx = 0x175b,
    extspr_table = 0x1765,
    extspr_table2 = 0x176f,
    
    -- Bounce sprites
    bouncespr_number = 0x1699,
    bouncespr_x_high = 0x16ad,
    bouncespr_x_low = 0x16a5,
    bouncespr_y_high = 0x16a9,
    bouncespr_y_low = 0x16a1,
    bouncespr_timer = 0x16c5,
    bouncespr_last_id = 0x18cd,
    turn_block_timer = 0x18ce,
    
    -- Player
    x = 0x0094,
    y = 0x0096,
    previous_x = 0x00d1,
    previous_y = 0x00d3,
    x_sub = 0x13da,
    y_sub = 0x13dc,
    x_speed = 0x007b,
    x_subspeed = 0x007a,
    y_speed = 0x007d,
    direction = 0x0076,
    is_ducking = 0x0073,
    p_meter = 0x13e4,
    take_off = 0x149f,
    powerup = 0x0019,
    cape_spin = 0x14a6,
    cape_fall = 0x14a5,
    cape_interaction = 0x13e8,
    flight_animation = 0x1407,
    diving_status = 0x1409,
    player_movement_mode = 0x0071,
    climbing_status = 0x0074,
    spinjump_flag = 0x140d,
    player_blocked_status = 0x0077, 
    player_item = 0x0dc2, --hex
    cape_x = 0x13e9,
    cape_y = 0x13eb,
    on_ground = 0x13ef,
    on_ground_delay = 0x008d,
    on_air = 0x0072,
    can_jump_from_water = 0x13fa,
    carrying_item = 0x148f,
    mario_score = 0x0f34,
    player_coin = 0x0dbf,
    player_looking_up = 0x13de,
    
    -- Yoshi
    yoshi_riding_flag = 0x187a,  -- #$00 = No, #$01 = Yes, #$02 = Yes, and turning around.
    yoshi_tile_pos = 0x0d8c,
    
    -- Timer
    --keep_mode_active = 0x0db1,
    score_incrementing = 0x13d6,
    end_level_timer = 0x1493,
    multicoin_block_timer = 0x186b, 
    gray_pow_timer = 0x14ae,
    blue_pow_timer = 0x14ad,
    dircoin_timer = 0x190c,
    pballoon_timer = 0x1891,
    star_timer = 0x1490,
    animation_timer = 0x1496,--
    invisibility_timer = 0x1497,
    fireflower_timer = 0x149b,
    yoshi_timer = 0x18e8,
    swallow_timer = 0x18ac,
    lakitu_timer = 0x18e0,
}
local WRAM = WRAM

local X_INTERACTION_POINTS = {center = 0x8, left_side = 0x2 + 1, left_foot = 0x5, right_side = 0xe - 1, right_foot = 0xb}

local Y_INTERACTION_POINTS = {
    {head = 0x10, center = 0x18, shoulder = 0x16, side = 0x1a, foot = 0x20, sprite = 0x15},
    {head = 0x08, center = 0x12, shoulder = 0x0f, side = 0x1a, foot = 0x20, sprite = 0x07},
    {head = 0x13, center = 0x1d, shoulder = 0x19, side = 0x28, foot = 0x30, sprite = 0x19},
    {head = 0x10, center = 0x1a, shoulder = 0x16, side = 0x28, foot = 0x30, sprite = 0x11}
}

local HITBOX_SPRITE = {  -- sprites' hitbox against player and other sprites
    [0x00] = { xoff = 2, yoff = 3, width = 12, height = 10, oscillation = true },
    [0x01] = { xoff = 2, yoff = 3, width = 12, height = 21, oscillation = true },
    [0x02] = { xoff = 16, yoff = -2, width = 16, height = 18, oscillation = true },
    [0x03] = { xoff = 20, yoff = 8, width = 8, height = 8, oscillation = true },
    [0x04] = { xoff = 0, yoff = -2, width = 48, height = 14, oscillation = true },
    [0x05] = { xoff = 0, yoff = -2, width = 80, height = 14, oscillation = true },
    [0x06] = { xoff = 1, yoff = 2, width = 14, height = 24, oscillation = true },
    [0x07] = { xoff = 8, yoff = 8, width = 40, height = 48, oscillation = true },
    [0x08] = { xoff = -8, yoff = -2, width = 32, height = 16, oscillation = true },
    [0x09] = { xoff = -2, yoff = 8, width = 20, height = 30, oscillation = true },
    [0x0a] = { xoff = 3, yoff = 7, width = 1, height = 2, oscillation = true },
    [0x0b] = { xoff = 6, yoff = 6, width = 3, height = 3, oscillation = true },
    [0x0c] = { xoff = 1, yoff = -2, width = 13, height = 22, oscillation = true },
    [0x0d] = { xoff = 0, yoff = -4, width = 15, height = 16, oscillation = true },
    [0x0e] = { xoff = 6, yoff = 6, width = 20, height = 20, oscillation = true },
    [0x0f] = { xoff = 2, yoff = -2, width = 36, height = 18, oscillation = true },
    [0x10] = { xoff = 0, yoff = -2, width = 15, height = 32, oscillation = true },
    [0x11] = { xoff = -24, yoff = -24, width = 64, height = 64, oscillation = true },
    [0x12] = { xoff = -4, yoff = 16, width = 8, height = 52, oscillation = true },
    [0x13] = { xoff = -4, yoff = 16, width = 8, height = 116, oscillation = true },
    [0x14] = { xoff = 4, yoff = 2, width = 24, height = 12, oscillation = true },
    [0x15] = { xoff = 0, yoff = -2, width = 15, height = 14, oscillation = true },
    [0x16] = { xoff = -4, yoff = -12, width = 24, height = 24, oscillation = true },
    [0x17] = { xoff = 2, yoff = 8, width = 12, height = 69, oscillation = true },
    [0x18] = { xoff = 2, yoff = 19, width = 12, height = 58, oscillation = true },
    [0x19] = { xoff = 2, yoff = 35, width = 12, height = 42, oscillation = true },
    [0x1a] = { xoff = 2, yoff = 51, width = 12, height = 26, oscillation = true },
    [0x1b] = { xoff = 2, yoff = 67, width = 12, height = 10, oscillation = true },
    [0x1c] = { xoff = 0, yoff = 10, width = 10, height = 48, oscillation = true },
    [0x1d] = { xoff = 2, yoff = -3, width = 28, height = 27, oscillation = true },
    [0x1e] = { xoff = 6, yoff = -8, width = 3, height = 32, oscillation = true },  -- default: { xoff = -32, yoff = -8, width = 48, height = 32, oscillation = true },
    [0x1f] = { xoff = -16, yoff = -4, width = 48, height = 18, oscillation = true },
    [0x20] = { xoff = -4, yoff = -24, width = 8, height = 24, oscillation = true },
    [0x21] = { xoff = -4, yoff = 16, width = 8, height = 24, oscillation = true },
    [0x22] = { xoff = 0, yoff = 0, width = 16, height = 16, oscillation = true },
    [0x23] = { xoff = -8, yoff = -24, width = 32, height = 32, oscillation = true },
    [0x24] = { xoff = -12, yoff = 32, width = 56, height = 56, oscillation = true },
    [0x25] = { xoff = -14, yoff = 4, width = 60, height = 20, oscillation = true },
    [0x26] = { xoff = 0, yoff = 88, width = 32, height = 8, oscillation = true },
    [0x27] = { xoff = -4, yoff = -4, width = 24, height = 24, oscillation = true },
    [0x28] = { xoff = -14, yoff = -24, width = 28, height = 40, oscillation = true },
    [0x29] = { xoff = -16, yoff = -4, width = 32, height = 27, oscillation = true },
    [0x2a] = { xoff = 2, yoff = -8, width = 12, height = 19, oscillation = true },
    [0x2b] = { xoff = 0, yoff = 2, width = 16, height = 76, oscillation = true },
    [0x2c] = { xoff = -8, yoff = -8, width = 16, height = 16, oscillation = true },
    [0x2d] = { xoff = 4, yoff = 4, width = 8, height = 4, oscillation = true },
    [0x2e] = { xoff = 2, yoff = -2, width = 28, height = 34, oscillation = true },
    [0x2f] = { xoff = 2, yoff = -2, width = 28, height = 32, oscillation = true },
    [0x30] = { xoff = 8, yoff = -14, width = 16, height = 28, oscillation = true },
    [0x31] = { xoff = 0, yoff = -2, width = 48, height = 18, oscillation = true },
    [0x32] = { xoff = 0, yoff = -2, width = 48, height = 18, oscillation = true },
    [0x33] = { xoff = 0, yoff = -2, width = 64, height = 18, oscillation = true },
    [0x34] = { xoff = -4, yoff = -4, width = 8, height = 8, oscillation = true },
    [0x35] = { xoff = 3, yoff = 0, width = 18, height = 32, oscillation = true },
    [0x36] = { xoff = 8, yoff = 8, width = 52, height = 46, oscillation = true },
    [0x37] = { xoff = 0, yoff = -8, width = 15, height = 20, oscillation = true },
    [0x38] = { xoff = 8, yoff = 16, width = 32, height = 40, oscillation = true },
    [0x39] = { xoff = 4, yoff = 3, width = 8, height = 10, oscillation = true },
    [0x3a] = { xoff = -8, yoff = 16, width = 32, height = 16, oscillation = true },
    [0x3b] = { xoff = 0, yoff = 0, width = 16, height = 13, oscillation = true },
    [0x3c] = { xoff = 12, yoff = 10, width = 3, height = 6, oscillation = true },
    [0x3d] = { xoff = 12, yoff = 21, width = 3, height = 20, oscillation = true },
    [0x3e] = { xoff = 16, yoff = 18, width = 254, height = 16, oscillation = true },
    [0x3f] = { xoff = 8, yoff = 8, width = 8, height = 24, oscillation = true }
}

local OBJ_CLIPPING_SPRITE = {  -- sprites' interaction points against objects
    [0x0] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  2},
    [0x1] = {xright = 14, xleft =  2, xdown =  7, xup =  7, yright = 18, yleft = 18, ydown = 32, yup =  2},
    [0x2] = {xright =  7, xleft =  7, xdown =  7, xup =  7, yright =  7, yleft =  7, ydown =  7, yup =  7},
    [0x3] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright = 16, yleft = 16, ydown = 32, yup = 11},
    [0x4] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright = 18, yleft = 18, ydown = 32, yup =  2},
    [0x5] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright = 24, yleft = 24, ydown = 32, yup = 16},
    [0x6] = {xright =  7, xleft =  0, xdown =  4, xup =  4, yright =  4, yleft =  4, ydown =  8, yup =  0},
    [0x7] = {xright = 31, xleft =  1, xdown = 16, xup = 16, yright = 16, yleft = 16, ydown = 31, yup =  1},
    [0x8] = {xright = 15, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 15, yup =  0},
    [0x9] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  0},
    [0xa] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright = 72, yleft = 72, ydown = 80, yup = 66},
    [0xb] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright =  4, yleft =  4, ydown =  8, yup =  0},
    [0xc] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright =  0, yleft =  0, ydown =  0, yup =  0},
    [0xd] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  0},
    [0xe] = {xright = 31, xleft =  0, xdown = 16, xup = 16, yright =  8, yleft =  8, ydown = 16, yup =  0},
    [0xf] = {xright =  8, xleft =  8, xdown =  8, xup = 16, yright =  4, yleft =  1, ydown =  2, yup =  4}
}

local HITBOX_EXTENDED_SPRITE = {  -- extended sprites' hitbox
    -- To fill the slots...
    --[0] ={ xoff = 3, yoff = 3, width = 64, height = 64},  -- Free slot
    [0x01] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Puff of smoke with various objects
    [0x0e] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Wiggler's flower
    [0x0f] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Trail of smoke
    [0x10] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Spinjump stars
    [0x12] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Water bubble
    -- extracted from ROM:
    [0x02] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Reznor fireball
    [0x03] = { xoff = 3, yoff = 3, width = 1, height = 1},  -- Flame left by hopping flame
    [0x04] = { xoff = 4, yoff = 4, width = 8, height = 8},  -- Hammer
    [0x05] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Player fireball
    [0x06] = { xoff = 4, yoff = 4, width = 8, height = 8},  -- Bone from Dry Bones
    [0x07] = { xoff = 0, yoff = 0, width = 0, height = 0},  -- Lava splash
    [0x08] = { xoff = 0, yoff = 0, width = 0, height = 0},  -- Torpedo Ted shooter's arm
    [0x09] = { xoff = 0, yoff = 0, width = 15, height = 15},  -- Unknown flickering object
    [0x0a] = { xoff = 4, yoff = 2, width = 8, height = 12},  -- Coin from coin cloud game
    [0x0b] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Piranha Plant fireball
    [0x0c] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Lava Lotus's fiery objects
    [0x0d] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = 0x40a0 },  -- Baseball
    -- got experimentally:
    [0x11] = { xoff = -0x1, yoff = -0x4, width = 11, height = 19, color_line = 0xa0ffff, color_bg = nil},  -- Yoshi fireballs
}

;                              -- 0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f  10 11 12
local SPRITE_MEMORY_MAX = {[0] = 10, 6, 7, 6, 7, 5, 8, 5, 7, 9, 9, 4, 8, 6, 8, 9, 10, 6, 6}  -- the max of sprites in a room

-- Creates a set from a list
local function make_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

-- from sprite number, returns oscillation flag
-- A sprite must be here iff it processes interaction with player every frame AND this bit is not working in the sprite_4_tweaker WRAM(0x167a)
local OSCILLATION_SPRITES = make_set{0x0e, 0x21, 0x29, 0x35, 0x54, 0x74, 0x75, 0x76, 0x77, 0x78, 0x81, 0x83, 0x87}

-- Sprites that have a custom hitbox drawing
local ABNORMAL_HITBOX_SPRITES = make_set{0x62, 0x63, 0x6b, 0x6c}

-- Sprites whose clipping interaction points usually matter
local GOOD_SPRITES_CLIPPING = make_set{
0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xf, 0x10, 0x11, 0x13, 0x14, 0x18,
0x1b, 0x1d, 0x1f, 0x20, 0x26, 0x27, 0x29, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31,
0x32, 0x34, 0x35, 0x3d, 0x3e, 0x3f, 0x40, 0x46, 0x47, 0x48, 0x4d, 0x4e,
0x51, 0x53, 0x6e, 0x6f, 0x70, 0x80, 0x81, 0x86, 
0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0xa1, 0xa2, 0xa5, 0xa6, 0xa7, 0xab, 0xb2,
0xb4, 0xbb, 0xbc, 0xbd, 0xbf, 0xc3, 0xda, 0xdb, 0xdc, 0xdd, 0xdf
}

-- Extended sprites that don't interact with the player
local UNINTERESTING_EXTENDED_SPRITES = make_set{1, 7, 8, 0x0e, 0x10, 0x12}

-- ROM hacks in which the lag indicator feature was tested and works
local LAG_INDICATOR_ROMS = make_set{  -- EDIT: is it possible to checksum in Snes9x?
    "0838e531fe22c077528febe14cb3ff7c492f1f5fa8de354192bdff7137c27f5b",  -- Super Mario World (U) [!].smc
    "75765b309c35978928f4a91fa58ffa89dc1575995b795afabad2586e67fce289",  -- Super Demo World - The Legend Continues (U) [!].smc
}


--#############################################################################
-- SCRIPT UTILITIES:


-- Variables used in various functions
local Cheat = {}  -- family of cheat functions and variables
local Previous = {}
local User_input = INPUT_KEYNAMES -- Snes9x
local Tiletable = {}
local Update_screen = true
local Is_lagged = nil
local Show_options_menu = false
local Mario_boost_indicator = nil
local Show_player_point_position = false
local Sprites_info = {}  -- keeps track of useful sprite info that might be used outside the main sprite function
local Sprite_hitbox = {}  -- keeps track of what sprite slots must display the hitbox

-- Initialization of some tables
for i = 0, SMW.sprite_max -1 do
    Sprites_info[i] = {}
end
for key = 0, SMW.sprite_max - 1 do
    Sprite_hitbox[key] = {}
    for number = 0, 0xff do
        Sprite_hitbox[key][number] = {["sprite"] = true, ["block"] = GOOD_SPRITES_CLIPPING[number]}
    end
end

-- Sum of the digits of a integer
local function sum_digits(number)
    local sum = 0
    while number > 0 do
        sum = sum + number%10
        number = math.floor(number*0.1)
    end
    
    return sum
end


-- Transform the binary representation of base into a string
-- For instance, if each bit of a number represents a char of base, then this function verifies what chars are on
local function decode_bits(data, base)
    local result = {}
    local i = 1
    local size = base:len()
    
    for ch in base:gmatch(".") do
        if bit.test(data, size-i) then
            result[i] = ch
        else
            result[i] = " "
        end
        i = i + 1
    end
    
    return table.concat(result)
end


function bit.test(value, bitnum)  -- Snes9x
    return bit.rshift(value, bitnum)%2 == 1
end


local function mouse_onregion(x1, y1, x2, y2)
    -- Reads external mouse coordinates
    local mouse_x = User_input.xmouse
    local mouse_y = User_input.ymouse
    
    -- From top-left to bottom-right
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    
    if mouse_x >= x1 and mouse_x <= x2 and  mouse_y >= y1 and mouse_y <= y2 then
        return true
    else
        return false
    end
end


-- Register a function to be executed on key press or release
-- execution happens in the main loop
local Keys = {}
Keys.press = {}
Keys.release = {}
Keys.down, Keys.up, Keys.pressed, Keys.released = {}, {}, {}, {}
function Keys.registerkeypress(key, fn)
    Keys.press[key] = fn
end
function Keys.registerkeyrelease(key, fn)
    Keys.release[key] = fn
end


-- Set the relative opacity of given text -- Snes9x
local function relative_opacity(text_opacity, bg_opacity)
    Text_opacity = text_opacity or Text_opacity
    Bg_opacity = bg_opacity or Bg_opacity
    
    return Text_opacity, Bg_opacity
end


-- A cross sign with pos and size
gui.crosshair = gui.crosshair or function(x, y, size, color)
    gui.line(x - size, y, x + size, y, color)
    gui.line(x, y-size, x, y+size, color)
end


local Movie_active, Readonly, Framecount, Lagcount, Rerecords
local Lastframe_emulated, Starting_subframe_last_frame, Size_last_frame, Final_subframe_last_frame
local Nextframe, Starting_subframe_next_frame, Starting_subframe_next_frame, Final_subframe_next_frame
local function snes9x_status()
    Movie_active = movie.active()  -- Snes9x
    Readonly = movie.playing()  -- Snes9x
    Framecount = movie.length()
    Lagcount = emu.lagcount() -- Snes9x
    Rerecords = movie.rerecordcount()
    
    -- Last frame info
    Lastframe_emulated = emu.framecount()
    
    -- Next frame info (only relevant in readonly mode)
    Nextframe = Lastframe_emulated + 1
    
end


-- draw a pixel given (x,y) with SNES' pixel sizes
local draw_pixel = gui.pixel


-- draws a line given (x,y) and (x',y') with given scale and SNES' pixel thickness (whose scale is 2) -- EDIT
local function draw_line(x1, y1, x2, y2, scale, color)
    -- Draw from top-left to bottom-right
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    
    x1, y1, x2, y2 = scale*x1, scale*y1, scale*x2, scale*y2
    gui.line(x1, y1, x2, y2, color)
end


-- draws a box given (x,y) and (x',y') with SNES' pixel sizes
local draw_box = function(x1, y1, x2, y2, line, fill)
    gui.box(x1, y1, x2, y2, fill, line)
end


-- draws a rectangle given (x,y) and dimensions, with SNES' pixel sizes
local draw_rectangle = function(x, y, w, h, line, fill)
    gui.box(x, y, x + w, y + h, fill, line)
end


-- Takes a position and dimensions of a rectangle and returns a new position if this rectangle has points outside the screen
local function put_on_screen(x, y, width, height)
    local x_screen, y_screen
    width = width or 0
    height = height or 0
    
    if x < - Border_left then
        x_screen = - Border_left
    elseif x > Buffer_width + Border_right - width then
        x_screen = Buffer_width + Border_right - width
    else
        x_screen = x
    end
    
    if y < - Border_top then
        y_screen = - Border_top
    elseif y > Buffer_height + Border_bottom - height then
        y_screen = Buffer_height + Border_bottom - height
    else
        y_screen = y
    end
    
    return x_screen, y_screen
end


-- returns the (x, y) position to start the text and its length:
-- number, number, number text_position(x, y, text, font_width, font_height[[[[, always_on_client], always_on_game], ref_x], ref_y])
-- x, y: the coordinates that the refereed point of the text must have
-- text: a string, don't make it bigger than the buffer area width and don't include escape characters
-- font_width, font_height: the sizes of the font
-- always_on_client, always_on_game: boolean
-- ref_x and ref_y: refer to the relative point of the text that must occupy the origin (x,y), from 0% to 100%
--                  for instance, if you want to display the middle of the text in (x, y), then use 0.5, 0.5
local function text_position(x, y, text, font_width, font_height, always_on_client, always_on_game, ref_x, ref_y)
    -- Reads external variables
    local border_left     = 0
    local border_right    = 0
    local border_top      = 0
    local border_bottom   = 0
    local buffer_width    = 256
    local buffer_height   = 224
    
    -- text processing
    local text_length = text and string.len(text)*font_width or font_width  -- considering another objects, like bitmaps
    
    -- actual position, relative to game area origin
    x = (not ref_x and x) or (ref_x == 0 and x) or x - math.floor(text_length*ref_x)
    y = (not ref_y and y) or (ref_y == 0 and y) or y - math.floor(font_height*ref_y)
    
    -- adjustment needed if text is supposed to be on screen area
    local x_end = x + text_length
    local y_end = y + font_height
    
    if always_on_game then
        if x < 0 then x = 0 end
        if y < 0 then y = 0 end
        
        if x_end > buffer_width  then x = buffer_width  - text_length end
        if y_end > buffer_height then y = buffer_height - font_height end
        
    elseif always_on_client then
        if x < -border_left then x = -border_left end
        if y < -border_top  then y = -border_top  end
        
        if x_end > buffer_width  + border_right  then x = buffer_width  + border_right  - text_length end
        if y_end > buffer_height + border_bottom then y = buffer_height + border_bottom - font_height end
    end
    
    return x, y, text_length
end


-- Complex function for drawing, that uses text_position
local function draw_text(x, y, text, ...)
    -- Reads external variables
    local font_name = Font or false
    local font_width  = SNES9X_FONT_WIDTH
    local font_height = SNES9X_FONT_HEIGHT
    local bg_default_color = font_name and COLOUR.outline or COLOUR.background
    local text_color, bg_color, always_on_client, always_on_game, ref_x, ref_y
    local arg1, arg2, arg3, arg4, arg5, arg6 = ...
    
    if not arg1 or arg1 == true then
        
        text_color = COLOUR.text
        bg_color = bg_default_color
        always_on_client, always_on_game, ref_x, ref_y = arg1, arg2, arg3, arg4
        
    elseif not arg2 or arg2 == true then
        
        text_color = arg1
        bg_color = bg_default_color
        always_on_client, always_on_game, ref_x, ref_y = arg2, arg3, arg4, arg5
        
    else
        
        text_color, bg_color = arg1, arg2
        always_on_client, always_on_game, ref_x, ref_y = arg3, arg4, arg5, arg6
        
    end
    
    local x_pos, y_pos, length = text_position(x, y, text, font_width, font_height,
                                    always_on_client, always_on_game, ref_x, ref_y)
    ;
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_pos, y_pos, text, text_color, bg_color)
    gui.opacity(1.0) -- Snes9x
    
    return x_pos + length, y_pos + font_height, length
end


local function alert_text(x, y, text, text_color, bg_color, always_on_game, ref_x, ref_y)
    -- Reads external variables
    local font_width  = SNES9X_FONT_WIDTH
    local font_height = SNES9X_FONT_HEIGHT
    
    local x_pos, y_pos, text_length = text_position(x, y, text, font_width, font_height, false, always_on_game, ref_x, ref_y)
    
    gui.opacity(Background_max_opacity * Bg_opacity)
    draw_rectangle(x_pos, y_pos, text_length - 1, font_height - 1, bg_color, bg_color)  -- Snes9x
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_pos, y_pos, text, text_color, 0)
    gui.opacity(1.0)
end


local function draw_over_text(x, y, value, base, color_base, color_value, color_bg, always_on_client, always_on_game, ref_x, ref_y)
    value = decode_bits(value, base)
    local x_end, y_end, length = draw_text(x, y, base,  color_base, color_bg, always_on_client, always_on_game, ref_x, ref_y)
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_end - length, y_end - SNES9X_FONT_HEIGHT, value, color_value or COLOUR.text)
    gui.opacity(1.0)
    
    return x_end, y_end, length
end


-- Returns frames-time conversion
local function frame_time(frame)
    if not NTSC_FRAMERATE then error("NTSC_FRAMERATE undefined."); return end
    
    local total_seconds = frame/NTSC_FRAMERATE
    local hours = math.floor(total_seconds/3600)
    local tmp = total_seconds - 3600*hours
    local minutes = math.floor(tmp/60)
    tmp = tmp - 60*minutes
    local seconds = math.floor(tmp)
    
    local miliseconds = 1000* (total_seconds%1)
    if hours == 0 then hours = "" else hours = string.format("%d:", hours) end
    local str = string.format("%s%.2d:%.2d.%03.0f", hours, minutes, seconds, miliseconds)
    return str
end


-- Background opacity functions
local function increase_opacity()
    if Text_max_opacity <= 0.9 then Text_max_opacity = Text_max_opacity + 0.1
    else
        if Background_max_opacity <= 0.9 then Background_max_opacity = Background_max_opacity + 0.1 end
    end
end


local function decrease_opacity()
    if  Background_max_opacity >= 0.1 then Background_max_opacity = Background_max_opacity - 0.1
    else
        if Text_max_opacity >= 0.1 then Text_max_opacity = Text_max_opacity - 0.1 end
    end
end


-- displays a button everytime in (x,y)
-- object can be a text or a dbitmap
-- if user clicks onto it, fn is executed once
local Script_buttons = {}
local function create_button(x, y, object, fn, always_on_client, always_on_game, ref_x, ref_y)
    local width, height
    local is_text = type(object) == "string"
    if not is_text then error"Non-text butttons not supported yet" end -- EDIT
    
    if is_text then
        width, height = SNES9X_FONT_WIDTH, SNES9X_FONT_HEIGHT
        x, y, width = text_position(x, y, object, width, height, always_on_client, always_on_game, ref_x, ref_y)
    else
        --width, height = object:size()
        x, y = text_position(x, y, nil, width, height, always_on_client, always_on_game, ref_x, ref_y)
    end
    
    -- draw the button
    draw_rectangle(x, y, width, height, 0xe0e0e0ff, 0x808080ff)
    if is_text then
        gui.text(x, y, object, COLOUR.button_text, 0)
    else
        --object:draw(x, y) -- EDIT
    end
    
    -- updates the table of buttons
    table.insert(Script_buttons, {x = x, y = y, width = width, height = height, object = object, action = fn})
end


local function options_menu()
    if not Show_options_menu then return end
    
    -- Pauses emulator and draws the background
    relative_opacity(1.0)
    draw_rectangle(0, 0, Buffer_width, Buffer_height, COLOUR.mainmenu_outline, COLOUR.mainmenu_bg)
    
    -- Font stuff
    local delta_x = SNES9X_FONT_WIDTH
    local delta_y = SNES9X_FONT_HEIGHT + 4
    local x_pos, y_pos = 4, 4
    local tmp
    
    -- Exit menu button
    create_button(Buffer_width, 0, " X ", function() Show_options_menu = false end, true, true)
    
    -- Main buttons
    tmp = OPTIONS.allow_cheats and "Cheats: allowed" or "Cheats: blocked"
    create_button(-Border_left, Buffer_height, tmp, function() OPTIONS.allow_cheats = not OPTIONS.allow_cheats end, true, false, 0.0, 1.0)
    
    create_button(Buffer_width + Border_right, Buffer_height, "Erase Tiles", function() Tiletable = {} end, true, false, 0.0, 1.0)
    
    -- Show/hide options
    gui.text(x_pos, y_pos, "Show/hide options:")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_debug_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_info = not OPTIONS.display_debug_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Some Debug Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_movie_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_movie_info = not OPTIONS.display_movie_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Display Movie Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_misc_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_misc_info = not OPTIONS.display_misc_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Display Misc Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_player_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_player_info = not OPTIONS.display_player_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Player Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_sprite_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_sprite_info = not OPTIONS.display_sprite_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Sprite Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_sprite_hitbox and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_sprite_hitbox = not OPTIONS.display_sprite_hitbox end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Sprite Hitbox?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_extended_sprite_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_extended_sprite_info = not OPTIONS.display_extended_sprite_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Extended Sprite Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_extended_sprite_hitbox and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_extended_sprite_hitbox = not OPTIONS.display_extended_sprite_hitbox end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Extended Sprite Hitbox?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_bounce_sprite_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_bounce_sprite_info = not OPTIONS.display_bounce_sprite_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Bounce Sprite Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_level_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_level_info = not OPTIONS.display_level_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Level Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_yoshi_info and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_yoshi_info = not OPTIONS.display_yoshi_info end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Yoshi Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_counters and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_counters = not OPTIONS.display_counters end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Counters Info?")
    y_pos = y_pos + delta_y
    
    tmp = OPTIONS.display_static_camera_region and "Yes" or "No "
    create_button(x_pos, y_pos, tmp, function() OPTIONS.display_static_camera_region = not OPTIONS.display_static_camera_region end)
    gui.text(x_pos + 4*delta_x, y_pos, "Show Static Camera Region?")
    y_pos = y_pos + delta_y
    
    -- Misc buttons
    gui.text(x_pos, y_pos, "Misc options:")
    y_pos = y_pos + delta_y
    
    -- Useful tips
    create_button(x_pos, y_pos, "Show tips in Snes9x: Console", function()
        print("\n")
        print(" - - - TIPS - - - ")
        print("MOUSE:")
        print("Use the left click to draw blocks and to see the Map16 properties.")
        print("Use the right click to toogle the hitbox mode of Mario and sprites.")
        print("\n")
        
        print("CHEATS(better turn off while recording a movie):")
        print("L+R+up: stop gravity for Mario fly / L+R+down to cancel")
        print("Use the mouse to drag and drop sprites")
        print("While paused: B+select to get out of the level")
        print("              X+select to beat the level (main exit)")
        print("              A+select to get the secret exit (don't use it if there isn't one)")
        
        print("\n")
        print("OTHERS:")
        print(fmt("Press \"%s\" for more and \"%s\" for less opacity.", OPTIONS.hotkey_increase_opacity, OPTIONS.hotkey_decrease_opacity))
        print("It's better to play without the mouse over the game window.")
        print(" - - - end of tips - - - ")
    end)
    
    return true
end


-- Gets input of the 1st controller / Might be deprecated someday...
local Joypad = {}
local function get_joypad()
    Joypad = joypad.get()
    for button, status in pairs(Joypad) do
        Joypad[button] = status and 1 or 0
    end
end



--#############################################################################
-- SMW FUNCTIONS:


local Real_frame, Previous_real_frame, Effective_frame, Lag_indicator, Game_mode
local Level_index, Room_index, Level_flag, Current_level, Is_paused, Lock_animation_flag
local Camera_x, Camera_y
local function scan_smw()
    Previous_real_frame = Real_frame or u8(WRAM.real_frame)
    Real_frame = u8(WRAM.real_frame)
    Effective_frame = u8(WRAM.effective_frame)
    Lag_indicator = u16(WRAM.lag_indicator)
    Game_mode = u8(WRAM.game_mode)
    Level_index = u8(WRAM.level_index)
    Level_flag = u8(WRAM.level_flag_table + Level_index)
    Is_paused = u8(WRAM.level_paused) == 1
    Lock_animation_flag = u8(WRAM.lock_animation_flag)
    Room_index = u24(WRAM.room_index)
    
    -- In level frequently used info
    Camera_x = s16(WRAM.camera_x)
    Camera_y = s16(WRAM.camera_y)
    Yoshi_riding_flag = u8(WRAM.yoshi_riding_flag) ~= 0
end


-- Converts the in-game (x, y) to SNES-screen coordinates
local function screen_coordinates(x, y, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or u8(WRAM.camera_x)
    camera_y = camera_y or Camera_y or u8(WRAM.camera_y)
    
    local x_screen = (x - camera_x)
    local y_screen = (y - camera_y) - Y_CAMERA_OFF
    
    return x_screen, y_screen
end


-- Converts Snes9x-screen coordinates to in-game (x, y)
local function game_coordinates(x_snes9x, y_snes9x, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or u8(WRAM.camera_x)
    camera_y = camera_y or Camera_y or u8(WRAM.camera_y)
    
    local x_game = x_snes9x + camera_x
    local y_game = y_snes9x + Y_CAMERA_OFF + camera_y
    
    return x_game, y_game
end


-- Returns the extreme values that Mario needs to have in order to NOT touch a rectangular object
local function display_boundaries(x_game, y_game, width, height, camera_x, camera_y)
    -- Font
    relative_opacity(0.5, 0.4) -- Snes9x
    
    -- Coordinates around the rectangle
    local left = width*math.floor(x_game/width)
    local top = height*math.floor(y_game/height)
    left, top = screen_coordinates(left, top, camera_x, camera_y)
    local right = left + width - 1
    local bottom = top + height - 1
    
    -- Reads WRAM values of the player
    local is_ducking = u8(WRAM.is_ducking)
    local powerup = u8(WRAM.powerup)
    local is_small = is_ducking ~= 0 or powerup == 0
    
    -- Left
    local left_text = string.format("%4d.0", width*math.floor(x_game/width) - 13)
    draw_text(left, (top+bottom)/2, left_text, false, false, 1.0, 0.5)
    
    -- Right
    local right_text = string.format("%d.f", width*math.floor(x_game/width) + 12)
    draw_text(right, (top+bottom)/2, right_text, false, false, 0.0, 0.5)
    
    -- Top
    local value = (Yoshi_riding_flag and y_game - 16) or y_game
    local top_text = fmt("%d.0", width*math.floor(value/width) - 32)
    draw_text((left+right)/2, top, top_text, false, false, 0.5, 1.0)
    
    -- Bottom
    value = height*math.floor(y_game/height)
    if not is_small and not Yoshi_riding_flag then
        value = value + 0x07
    elseif is_small and Yoshi_riding_flag then
        value = value - 4
    else
        value = value - 1  -- the 2 remaining cases are equal
    end
    
    local bottom_text = fmt("%d.f", value)
    draw_text((left+right)/2, bottom, bottom_text, false, false, 0.5, 0.0)
    
    return left, top
end


local function read_screens()
	local screens_number = u8(WRAM.screens_number)
    local vscreen_number = u8(WRAM.vscreen_number)
    local hscreen_number = u8(WRAM.hscreen_number) - 1
    local vscreen_current = s8(WRAM.y + 1)
    local hscreen_current = s8(WRAM.x + 1)
    local level_mode_settings = u8(WRAM.level_mode_settings)
    --local b1, b2, b3, b4, b5, b6, b7, b8 = bit.multidiv(level_mode_settings, 128, 64, 32, 16, 8, 4, 2)
    --draw_text(Buffer_middle_x, Buffer_middle_y, {"%x: %x%x%x%x%x%x%x%x", level_mode_settings, b1, b2, b3, b4, b5, b6, b7, b8}, COLOUR.text, COLOUR.background)
    
    local level_type
    if (level_mode_settings ~= 0) and (level_mode_settings == 0x3 or level_mode_settings == 0x4 or level_mode_settings == 0x7
        or level_mode_settings == 0x8 or level_mode_settings == 0xa or level_mode_settings == 0xd) then
            level_type = "Vertical"
        ;
    else
        level_type = "Horizontal"
    end
    
    return level_type, screens_number, hscreen_current, hscreen_number, vscreen_current, vscreen_number
end


local function get_map16_value(x_game, y_game)
    local num_x = math.floor(x_game/16)
    local num_y = math.floor(y_game/16)
    if num_x < 0 or num_y < 0 then return end  -- 1st breakpoint

    local level_type, screens, _, hscreen_number, _, vscreen_number = read_screens()
    local max_x, max_y
    if level_type == "Horizontal" then
        max_x = 16*(hscreen_number + 1)
        max_y = 27
    else
        max_x = 32
        max_y = 16*(vscreen_number + 1)
    end
    
    if num_x > max_x or num_y > max_y then return end  -- 2nd breakpoint
    
    local num_id, kind
    if level_type == "Horizontal" then
        num_id = 16*27*math.floor(num_x/16) + 16*num_y + num_x%16
        kind = (num_id >= 0 and num_id <= 0x35ff) and 256*u8(0x1c800 + num_id) + u8(0xc800 + num_id)
    else
        local nx = math.floor(num_x/16)
        local ny = math.floor(num_y/16)
        local n = 2*ny + nx
        local num_id = 16*16*n + 16*(num_y%16) + num_x%16
        kind = (num_id >= 0 and num_id <= 0x37ff) and 256*u8(0x1c800 + num_id) + u8(0xc800 + num_id)
    end
    
    if kind then return  num_x, num_y, kind end
end


local function draw_tilesets(camera_x, camera_y)
    local x_origin, y_origin = screen_coordinates(0, 0, camera_x, camera_y)
    local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, camera_x, camera_y)
    x_mouse = 16*math.floor(x_mouse/16)
    y_mouse = 16*math.floor(y_mouse/16)
    local push_direction = Real_frame%2 == 0 and 0 or 7  -- block pushes sprites to left or right?
    
    for number, positions in ipairs(Tiletable) do
        -- Calculate the Lsnes coordinates
        local left = positions[1] + x_origin
        local top = positions[2] + y_origin
        local right = left + 15
        local bottom = top + 15
        local x_game, y_game = game_coordinates(left, top, camera_x, camera_y)
        
        -- Returns if block is way too outside the screen
        if left > - Border_left - 32 and top  > - Border_top - 32 and -- Snes9x: w/ 2*
        right < Screen_width  + Border_right + 32 and bottom < Screen_height + Border_bottom + 32 then
            
            -- Drawings
            relative_opacity(1.0) -- Snes9x
            local num_x, num_y, kind = get_map16_value(x_game, y_game)
            if kind >= 0x111 and kind <= 0x16d or kind == 0x2b then  -- default solid blocks, don't know how to include custom blocks
                draw_rectangle(left + push_direction, top, 8, 15, 0, COLOUR.block_bg)
            end
            draw_rectangle(left, top, 15, 15, kind == SMW.blank_tile_map16 and COLOUR.blank_tile or COLOUR.block, 0)
            
            if Tiletable[number][3] then
                display_boundaries(x_game, y_game, 16, 16, camera_x, camera_y)  -- the text around it
            end
            
            -- Draw Map16 id
            relative_opacity(1.0) -- Snes9x
            if kind and x_mouse == positions[1] and y_mouse == positions[2] then
                draw_text(left + 4, top - SNES9X_FONT_HEIGHT, fmt("Map16 (%d, %d), %x", num_x, num_y, kind), false, false, 0.5, 1.0)
            end
            
        end
        
    end
    
end


-- if the user clicks in a tile, it will be be drawn
-- if click is onto drawn region, it'll be erased
-- there's a max of possible tiles
-- Tileset[n] is a triple compound of {x, y, draw info?}
local function select_tile()
    local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
    x_mouse = 16*math.floor(x_mouse/16)
    y_mouse = 16*math.floor(y_mouse/16)
    
    for number, positions in ipairs(Tiletable) do  -- if mouse points a drawn tile, erase it
        if x_mouse == positions[1] and y_mouse == positions[2] then
            if Tiletable[number][3] == false then
                Tiletable[number][3] = true
            else
                table.remove(Tiletable, number)
            end
            
            return
        end
    end
    
    -- otherwise, draw a new tile
    if #Tiletable == OPTIONS.max_tiles_drawn then
        table.remove(Tiletable, 1)
        Tiletable[OPTIONS.max_tiles_drawn] = {x_mouse, y_mouse, false}
    else
        table.insert(Tiletable, {x_mouse, y_mouse, false})
    end
    
end


-- uses the mouse to select an object
local function select_object(mouse_x, mouse_y, camera_x, camera_y)
    -- Font
    relative_opacity(1.0, 0.5)
    
    local x_game, y_game = game_coordinates(mouse_x, mouse_y, camera_x, camera_y)
    local obj_id
    
    -- Checks if the mouse is over Mario
    local x_player = s16(WRAM.x)
    local y_player = s16(WRAM.y)
    if x_player + 0xe >= x_game and x_player + 0x2 <= x_game and y_player + 0x30 >= y_game and y_player + 0x8 <= y_game then
        obj_id = "Mario"
    end
    
    if not obj_id and OPTIONS.display_sprite_info then
        for id = 0, SMW.sprite_max - 1 do
            local sprite_status = u8(WRAM.sprite_status + id)
            if sprite_status ~= 0 then
                -- Import some values
                local x_sprite, y_sprite = Sprites_info[id].x, Sprites_info[id].y
                local x_screen, y_screen = Sprites_info[id].x_screen, Sprites_info[id].y_screen
                local boxid = Sprites_info[id].boxid
                local xoff, yoff = Sprites_info[id].xoff, Sprites_info[id].yoff
                local width, height = Sprites_info[id].width, Sprites_info[id].height
                
                if x_sprite + xoff + width >= x_game and x_sprite + xoff <= x_game and
                y_sprite + yoff + height >= y_game and y_sprite + yoff <= y_game then
                    obj_id = id
                    break
                end
            end
        end
    end
    
    if not obj_id then return end
    
    draw_text(User_input.xmouse, User_input.ymouse - 8, obj_id, true, false, 0.5, 1.0)
    return obj_id, x_game, y_game
end


-- This function sees if the mouse if over some object, to change its hitbox mode
-- The order is: 1) player, 2) sprite.
local function right_click()
    local id = select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
    if id == nil then return end
    
    if tostring(id) == "Mario" then
        
        if OPTIONS.display_player_hitbox and OPTIONS.display_interaction_points then
            OPTIONS.display_interaction_points = false
            OPTIONS.display_player_hitbox = false
        elseif OPTIONS.display_player_hitbox then
            OPTIONS.display_interaction_points = true
            OPTIONS.display_player_hitbox = false
        elseif OPTIONS.display_interaction_points then
            OPTIONS.display_player_hitbox = true
        else
            OPTIONS.display_player_hitbox = true
        end
        
    end
    
    local spr_id = tonumber(id)
    if spr_id and spr_id >= 0 and spr_id <= SMW.sprite_max - 1 then
        
        local number = Sprites_info[spr_id].number
        if Sprite_hitbox[spr_id][number].sprite and Sprite_hitbox[spr_id][number].block then
            Sprite_hitbox[spr_id][number].sprite = false
            Sprite_hitbox[spr_id][number].block = false
        elseif Sprite_hitbox[spr_id][number].sprite then
            Sprite_hitbox[spr_id][number].block = true
            Sprite_hitbox[spr_id][number].sprite = false
        elseif Sprite_hitbox[spr_id][number].block then
            Sprite_hitbox[spr_id][number].sprite = true
        else
            Sprite_hitbox[spr_id][number].sprite = true
        end
        
    end
end


local function show_movie_info()
    if not OPTIONS.display_movie_info then
        draw_text(0, -Border_top, "Movie info: off", COLOUR.very_weak, true, false)
        return
    end
    
    -- Font
    relative_opacity(1.0, 1.0)
    local y_text = - Border_top
    local x_text = 0
    local width = SNES9X_FONT_WIDTH
    
    local rec_color = (Readonly or not Movie_active) and COLOUR.text or COLOUR.warning
    local recording_bg = (Readonly or not Movie_active) and COLOUR.background or COLOUR.warning_bg 
    
    -- Read-only or read-write?
    local movie_type = (not Movie_active and "No movie ") or (Readonly and "Movie " or "REC ")
    alert_text(x_text, y_text, movie_type, rec_color, recording_bg)
    
    if Movie_active then
        -- Frame count
        x_text = x_text + width*string.len(movie_type)
        local movie_info
        if Readonly then
            movie_info = string.format("%d/%d", Lastframe_emulated, Framecount)
        else
            movie_info = string.format("%d", Lastframe_emulated)
        end
        draw_text(x_text, y_text, movie_info)  -- Shows the latest frame emulated, not the frame being run now
        
        -- Rerecord count
        x_text = x_text + width*string.len(movie_info)
        local rr_info = string.format(" %d ", Rerecords)
        draw_text(x_text, y_text, rr_info, COLOUR.weak)
        
        -- Lag count
        x_text = x_text + width*string.len(rr_info)
        draw_text(x_text, y_text, Lagcount, COLOUR.warning)
    end
    
    local str = frame_time(Lastframe_emulated)    -- Shows the latest frame emulated, not the frame being run now
    alert_text(Buffer_width, Buffer_height, str, COLOUR.text, recording_bg, false, 1.0, 1.0)
    
    if Is_lagged then
        alert_text(Buffer_middle_x - 3*SNES9X_FONT_WIDTH, 2*SNES9X_FONT_HEIGHT, " LAG ", COLOUR.warning, COLOUR.warning_bg)
        emu.message("Lag detected!") -- Snes9x
        
    end
    
    --[[ lag indicator: only works in SMW and some hacks
    if LAG_INDICATOR_ROMS[ROM_hash] then
        if Lag_indicator == 32884 then
            gui.textV(Buffer_middle_x - 7*SNES9X_FONT_WIDTH, 4*SNES9X_FONT_HEIGHT, "Lag Indicator",
                        COLOUR.warning, change_transparency(COLOUR.warning_bg, Background_max_opacity))
        end
    end
    --]]
end


local function show_misc_info()
    if not OPTIONS.display_misc_info then
        draw_text(Buffer_width + Border_right, -Border_top, "Misc info: off", COLOUR.very_weak, true, false)
        return
    end
    
    -- Font
    relative_opacity(Game_mode == SMW.game_mode_level and 0.5 or 1.0, 1.0) -- Snes9x
    
    -- Display
    local RNG = u16(WRAM.RNG)
    local main_info = string.format("Frame(%02x, %02x) RNG(%04x) Mode(%02x)",
                                    Real_frame, Effective_frame, RNG, Game_mode)
    ;
    
    draw_text(Buffer_width + Border_right, -Border_top, main_info, true, false)
    
    if Game_mode == SMW.game_mode_level then
        -- Time frame counter of the clock
        relative_opacity(1.0)
        local timer_frame_counter = u8(WRAM.timer_frame_counter)
        draw_text(161, 15, fmt("%.2d", timer_frame_counter))
        
        -- Score: sum of digits, useful for avoiding lag
        relative_opacity(0.5)
        local score = u24(WRAM.mario_score)
        draw_text(240, 24, fmt("=%d", sum_digits(score)), COLOUR.weak)
    end
end


-- Shows the controller input as the RAM and SNES registers store it
local function show_controller_data()
    if not OPTIONS.display_debug_info then return end
    
    -- Font
    relative_opacity(0.9)
    local height = SNES9X_FONT_HEIGHT
    local x_pos, y_pos, x, y, _ = 0, 0, 0, SNES9X_FONT_HEIGHT
    
    local controller = memory.readword(0x1000000 + 0x4218) -- Snes9x / BUS area
    x = draw_over_text(x, y, controller, "BYsS^v<>AXLR0123", COLOUR.warning, false, true)
    _, y = draw_text(x, y, " (Registers)", COLOUR.warning, false, true)
    
    x = x_pos
    x = draw_over_text(x, y, 256*u8(WRAM.ctrl_1_1) + u8(WRAM.ctrl_1_2), "BYsS^v<>AXLR0123", COLOUR.weak)
    _, y = draw_text(x, y, " (RAM data)", COLOUR.weak, false, true)
    
    x = x_pos
    draw_over_text(x, y, 256*u8(WRAM.firstctrl_1_1) + u8(WRAM.firstctrl_1_2), "BYsS^v<>AXLR0123", 0, 0xffff, 0) -- Snes9x
end


local function level_info()
    -- Font
    relative_opacity(0.2, 1.0)  -- Snes9x
    local x_pos = 134
    local y_pos = 200
    local color = COLOUR.text
    
    if not OPTIONS.display_level_info then
        draw_text(x_pos, y_pos + 2*SNES9X_FONT_HEIGHT, "Level info: off", COLOUR.very_weak, true, false)
        return
    end
    relative_opacity(1.0, 1.0)  -- Snes9x
    
    local sprite_buoyancy = math.floor(u8(WRAM.sprite_buoyancy)/64)
    if sprite_buoyancy == 0 then sprite_buoyancy = "" else
        sprite_buoyancy = fmt(" %.2x", sprite_buoyancy)
        color = COLOUR.warning
    end
    
    -- converts the level number to the Lunar Magic number; should not be used outside here
    local lm_level_number = Level_index
    if Level_index > 0x24 then lm_level_number = Level_index + 0xdc end
    
    -- Number of screens within the level
    local level_type, screens_number, hscreen_current, hscreen_number, vscreen_current, vscreen_number = read_screens()
    
    draw_text(x_pos, y_pos, fmt("%.1sLevel(%.2x)%s", level_type, lm_level_number, sprite_buoyancy),
                    color, true, false)
	;
    
    draw_text(x_pos, y_pos + SNES9X_FONT_HEIGHT, fmt("Screens(%d):", screens_number), true)
    
    draw_text(x_pos, y_pos + 2*SNES9X_FONT_HEIGHT, fmt("(%d/%d, %d/%d)", hscreen_current, hscreen_number,
                vscreen_current, vscreen_number), true)
    ;
end


function draw_blocked_status(x_text, y_text, player_blocked_status, x_speed, y_speed)
    local bitmap_width  = 7 -- Snes9x
    local bitmap_height = 10 -- Snes9x
    local block_str = "Block:"
    local str_len = string.len(block_str)
    local xoffset = x_text + str_len*SNES9X_FONT_WIDTH
    local yoffset = y_text
    local color_line = COLOUR.warning
    
    gui.gdoverlay(xoffset, yoffset, IMAGES.player_blocked_status, Background_max_opacity * Bg_opacity) -- Snes9x
    
    gui.opacity(Text_max_opacity*Text_opacity) -- Snes9x
    local blocked_status = {}
    local was_boosted = false
    
    if bit.test(player_blocked_status, 0) then  -- Right
        draw_line(xoffset + bitmap_width - 1, yoffset, xoffset + bitmap_width - 1, yoffset + bitmap_height - 1, 1, color_line)
        if x_speed < 0 then was_boosted = true end
    end
    
    if bit.test(player_blocked_status, 1) then  -- Left
        draw_line(xoffset, yoffset, xoffset, yoffset + bitmap_height - 1, 1, color_line)
        if x_speed > 0 then was_boosted = true end
    end
    
    if bit.test(player_blocked_status, 2) then  -- Down
        draw_line(xoffset, yoffset + bitmap_height - 1, xoffset + bitmap_width - 1, yoffset + bitmap_height - 1, 1, color_line)
    end
    
    if bit.test(player_blocked_status, 3) then  -- Up
        draw_line(xoffset, yoffset, xoffset + bitmap_width - 1, yoffset, 1, color_line)
        if y_speed > 6 then was_boosted = true end
    end
    
    if bit.test(player_blocked_status, 4) then  -- Middle
        gui.crosshair(xoffset + math.floor(bitmap_width/2), yoffset + math.floor(bitmap_height/2),
        math.min(bitmap_width/2, bitmap_height/2), color_line)
    end
    
    draw_text(x_text, y_text, block_str, COLOUR.text, was_boosted and COLOUR.warning_bg or nil)
    
end


-- displays player's hitbox
local function player_hitbox(x, y, is_ducking, powerup, transparency_level)
    local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
    local yoshi_hitbox = nil
    local is_small = is_ducking ~= 0 or powerup == 0
    
    local x_points = X_INTERACTION_POINTS
    local y_points
    if is_small and not Yoshi_riding_flag then
        y_points = Y_INTERACTION_POINTS[1]
    elseif not is_small and not Yoshi_riding_flag then
        y_points = Y_INTERACTION_POINTS[2]
    elseif is_small and Yoshi_riding_flag then
        y_points = Y_INTERACTION_POINTS[3]
    else
        y_points = Y_INTERACTION_POINTS[4]
    end
    
    draw_box(x_screen + x_points.left_side, y_screen + y_points.head, x_screen + x_points.right_side, y_screen + y_points.foot,
            COLOUR.interaction_bg, COLOUR.interaction_bg)  -- background for block interaction
    ;
    
    if OPTIONS.display_player_hitbox then
        
        -- Collision with sprites
        local mario_bg = (not Yoshi_riding_flag and COLOUR.mario_bg) or COLOUR.mario_mounted_bg
        
        draw_box(x_screen + x_points.left_side  - 1, y_screen + y_points.sprite,
                 x_screen + x_points.right_side + 1, y_screen + y_points.foot + 1, COLOUR.mario, mario_bg)
        ;
        
    end
    
    -- interaction points (collision with blocks)
    if OPTIONS.display_interaction_points then
        
        local color = COLOUR.interaction
        
        if not SHOW_PLAYER_HITBOX then
            draw_box(x_screen + x_points.left_side , y_screen + y_points.head,
                     x_screen + x_points.right_side, y_screen + y_points.foot, COLOUR.interaction_nohitbox, COLOUR.interaction_nohitbox_bg)
        end
        
        gui.line(x_screen + x_points.left_side, y_screen + y_points.side, x_screen + x_points.left_foot, y_screen + y_points.side, color)  -- left side
        gui.line(x_screen + x_points.right_side, y_screen + y_points.side, x_screen + x_points.right_foot, y_screen + y_points.side, color)  -- right side
        gui.line(x_screen + x_points.left_foot, y_screen + y_points.foot - 2, x_screen + x_points.left_foot, y_screen + y_points.foot, color)  -- left foot bottom
        gui.line(x_screen + x_points.right_foot, y_screen + y_points.foot - 2, x_screen + x_points.right_foot, y_screen + y_points.foot, color)  -- right foot bottom
        gui.line(x_screen + x_points.left_side, y_screen + y_points.shoulder, x_screen + x_points.left_side + 2, y_screen + y_points.shoulder, color)  -- head left point
        gui.line(x_screen + x_points.right_side - 2, y_screen + y_points.shoulder, x_screen + x_points.right_side, y_screen + y_points.shoulder, color)  -- head right point
        gui.line(x_screen + x_points.center, y_screen + y_points.head, x_screen + x_points.center, y_screen + y_points.head + 2, color)  -- head point
        gui.line(x_screen + x_points.center - 1, y_screen + y_points.center, x_screen + x_points.center + 1, y_screen + y_points.center, color)  -- center point
        gui.line(x_screen + x_points.center, y_screen + y_points.center - 1, x_screen + x_points.center, y_screen + y_points.center + 1, color)  -- center point
    end
    
    -- That's the pixel that appears when Mario dies in the pit
    Show_player_point_position = Show_player_point_position or y_screen >= 200 or OPTIONS.display_debug_info
    if Show_player_point_position then
        draw_rectangle(x_screen - 1, y_screen - 1, 2, 2, COLOUR.interaction_bg, COLOUR.text)
        Show_player_point_position = false
    end
    
    return x_points, y_points
end


-- displays the hitbox of the cape while spinning
local function cape_hitbox(spin_direction)
    local cape_interaction = u8(WRAM.cape_interaction)
    if cape_interaction == 0 then return end
    
    local cape_x = u16(WRAM.cape_x)
    local cape_y = u16(WRAM.cape_y)
    
    local cape_x_screen, cape_y_screen = screen_coordinates(cape_x, cape_y, Camera_x, Camera_y)
    local cape_left = -2
    local cape_right = 0x12
    local cape_up = 0x01
    local cape_down = 0x11
    local cape_middle = 0x08
    local block_interaction_cape = (spin_direction < 0 and cape_left + 4) or cape_right - 4
    local active_frame_sprites = Real_frame%2 == 1  -- active iff the cape can hit a sprite
    local active_frame_blocks  = Real_frame%2 == (spin_direction < 0 and 0 or 1)  -- active iff the cape can hit a block
    
    if active_frame_sprites then bg_color = COLOUR.cape_bg else bg_color = 0 end
    draw_box(cape_x_screen + cape_left, cape_y_screen + cape_up, cape_x_screen + cape_right, cape_y_screen + cape_down, COLOUR.cape, bg_color)
    
    if active_frame_blocks then
        draw_pixel(cape_x_screen + block_interaction_cape, cape_y_screen + cape_middle, COLOUR.warning)
    else
        draw_pixel(cape_x_screen + block_interaction_cape, cape_y_screen + cape_middle, COLOUR.text)
    end
end


local function player()
    if not OPTIONS.display_player_info then
        draw_text(0, 32, "Player info: off", COLOUR.very_weak)
        return
    end
    
    -- Font
    relative_opacity(1.0)
    
    -- Reads WRAM
    local x = s16(WRAM.x)
    local y = s16(WRAM.y)
    local previous_x = s16(WRAM.previous_x)
    local previous_y = s16(WRAM.previous_y)
    local x_sub = u8(WRAM.x_sub)
    local y_sub = u8(WRAM.y_sub)
    local x_speed = s8(WRAM.x_speed)
    local x_subspeed = u8(WRAM.x_subspeed)
    local y_speed = s8(WRAM.y_speed)
    local p_meter = u8(WRAM.p_meter)
    local take_off = u8(WRAM.take_off)
    local powerup = u8(WRAM.powerup)
    local direction = u8(WRAM.direction)
    local cape_spin = u8(WRAM.cape_spin)
    local cape_fall = u8(WRAM.cape_fall)
    local flight_animation = u8(WRAM.flight_animation)
    local diving_status = s8(WRAM.diving_status)
    local player_blocked_status = u8(WRAM.player_blocked_status)
    local player_item = u8(WRAM.player_item)
    local is_ducking = u8(WRAM.is_ducking)
    local on_ground = u8(WRAM.on_ground)
    local spinjump_flag = u8(WRAM.spinjump_flag)
    local can_jump_from_water = u8(WRAM.can_jump_from_water)
    local carrying_item = u8(WRAM.carrying_item)
    local scroll_timer = u8(WRAM.camera_scroll_timer)
    
    -- Transformations
    if direction == 0 then direction = LEFT_ARROW else direction = RIGHT_ARROW end
    local x_sub_simple, y_sub_simple-- = x_sub, y_sub
    if x_sub%0x10 == 0 then x_sub_simple = fmt("%x", x_sub/0x10) else x_sub_simple = fmt("%.2x", x_sub) end
    if y_sub%0x10 == 0 then y_sub_simple = fmt("%x", y_sub/0x10) else y_sub_simple = fmt("%.2x", y_sub) end
    
    local x_speed_int, x_speed_frac = math.modf(x_speed + x_subspeed/0x100)
    x_speed_frac = math.abs(x_speed_frac*100)
    
    local spin_direction = (Effective_frame)%8
    if spin_direction < 4 then
        spin_direction = spin_direction + 1
    else
        spin_direction = 3 - spin_direction
    end
    
    local is_caped = powerup == 0x2
    local is_spinning = cape_spin ~= 0 or spinjump_flag ~= 0
    
    -- Display info
    local i = 0
    local delta_x = SNES9X_FONT_WIDTH
    local delta_y = SNES9X_FONT_HEIGHT
    local table_x = 0
    local table_y = 32
    
    draw_text(table_x, table_y + i*delta_y, fmt("Meter (%03d, %02d) %s", p_meter, take_off, direction))
    draw_text(table_x + 18*delta_x, table_y + i*delta_y, fmt(" %+d", spin_direction),
    (is_spinning and COLOUR.text) or COLOUR.weak)
    i = i + 1
    
    draw_text(table_x, table_y + i*delta_y, fmt("Pos (%+d.%s, %+d.%s)", x, x_sub_simple, y, y_sub_simple))
    i = i + 1
    
    draw_text(table_x, table_y + i*delta_y, fmt("Speed (%+d(%d.%02.0f), %+d)", x_speed, x_speed_int, x_speed_frac, y_speed))
    i = i + 1
    
    if is_caped then
        draw_text(table_x, table_y + i*delta_y, fmt("Cape (%.2d, %.2d)/(%d, %d)", cape_spin, cape_fall, flight_animation, diving_status), COLOUR.cape)
        i = i + 1
    end
    
    local x_txt = draw_text(table_x, table_y + i*delta_y, fmt("Camera (%d, %d)", Camera_x, Camera_y))
    if scroll_timer ~= 0 then draw_text(x_txt, table_y + i*delta_y, 16 - scroll_timer, COLOUR.warning) end
    i = i + 1
    
    if OPTIONS.display_static_camera_region then
        Show_player_point_position = true
        local left_cam, right_cam = u16(0x142c), u16(0x142e)  -- unlisted WRAM
        draw_box(left_cam, 0, right_cam, 224, COLOUR.static_camera_region, COLOUR.static_camera_region)
    end
    
    draw_blocked_status(table_x, table_y + i*delta_y, player_blocked_status, x_speed, y_speed)
    
    -- Mario boost indicator (experimental)
    -- This looks for differences between the expected x position and the actual x position, after a frame advance
    -- Fails during a loadstate and has false positives if the game is paused or lagged
    Previous.player_x = 256*x + x_sub  -- the total amount of 256-based subpixels
    Previous.x_speed = 16*x_speed  -- the speed in 256-based subpixels
    
    if Mario_boost_indicator and not Cheat.under_free_move then
        local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
        gui.text(2*x_screen + 8, 2*y_screen + 120, Mario_boost_indicator, COLOUR.warning, 0x20000000)
    end
    
    -- shows hitbox and interaction points for player
    if not (OPTIONS.display_player_hitbox or OPTIONS.display_interaction_points) then return end
    
    cape_hitbox(spin_direction)
    player_hitbox(x, y, is_ducking, powerup, 1.0)
    
    -- Shows where Mario is expected to be in the next frame, if he's not boosted or stopped (DEBUG)
    gui.opacity(0.3) -- Snes9x
    if OPTIONS.display_debug_info then player_hitbox( math.floor((256*x + x_sub + 16*x_speed)/256),
            math.floor((256*y + y_sub + 16*y_speed)/256), is_ducking, powerup)
    end
    
end


-- Returns the id of Yoshi; if more than one, the lowest sprite slot
local function get_yoshi_id()
    for i = 0, SMW.sprite_max - 1 do
        id = u8(WRAM.sprite_number + i)
        status = u8(WRAM.sprite_status + i)
        if id == 0x35 and status ~= 0 then return i end
    end
    
    return nil
end


local function extended_sprites()
    if not OPTIONS.display_extended_sprite_info then
        relative_opacity(0.3) -- Snes9x
        draw_text(Buffer_width + Border_right, 144, "Ext. Spr. info: off", COLOUR.very_weak, true, false)
        if not OPTIONS.display_extended_sprite_hitbox then return end
    end
    
    -- Font
    relative_opacity(1.0) -- Snes9x
    local height = SNES9X_FONT_HEIGHT
    
    local y_pos = 144
    local counter = 0
    for id = 0, SMW.extended_sprite_max - 1 do
        local extspr_number = u8(WRAM.extspr_number + id)
        
        if extspr_number ~= 0 then
            -- Reads WRAM addresses
            local x = 256*u8(WRAM.extspr_x_high + id) + u8(WRAM.extspr_x_low + id)
            local y = 256*u8(WRAM.extspr_y_high + id) + u8(WRAM.extspr_y_low + id)
            local sub_x = bit.rshift(u8(WRAM.extspr_subx + id), 4)
            local sub_y = bit.rshift(u8(WRAM.extspr_suby + id), 4)
            local x_speed = s8(WRAM.extspr_x_speed + id)
            local y_speed = s8(WRAM.extspr_y_speed + id)
            local extspr_table = u8(WRAM.extspr_table + id)
            local extspr_table2 = u8(WRAM.extspr_table2 + id)
            
            -- Reduction of useless info
            local special_info = ""
            if OPTIONS.display_debug_info and (extspr_table ~= 0 or extspr_table2 ~= 0) then
                special_info = fmt("(%x, %x) ", extspr_table, extspr_table2)
            end
            
            -- x speed for Fireballs
            if extspr_number == 5 then x_speed = 16*x_speed end
            
            if OPTIONS.display_extended_sprite_info then
                draw_text(Buffer_width + Border_right, y_pos + counter*height, fmt("#%.2d %.2x %s(%d.%x(%+.2d), %d.%x(%+.2d))",
                                                    id, extspr_number, special_info, x, sub_x, x_speed, y, sub_y, y_speed),
                                                    COLOUR.extended_sprites, true, false)
            end
            
            if OPTIONS.display_debug_info or not UNINTERESTING_EXTENDED_SPRITES[extspr_number]
                or (extspr_number == 1 and extspr_table2 == 0xf)
            then
                local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
                
                local xoff = HITBOX_EXTENDED_SPRITE[extspr_number].xoff
                local yoff = HITBOX_EXTENDED_SPRITE[extspr_number].yoff + Y_CAMERA_OFF
                local xrad = HITBOX_EXTENDED_SPRITE[extspr_number].width
                local yrad = HITBOX_EXTENDED_SPRITE[extspr_number].height
                
                local color_line = HITBOX_EXTENDED_SPRITE[extspr_number].color_line or COLOUR.extended_sprites
                local color_bg = HITBOX_EXTENDED_SPRITE[extspr_number].color_bg or 0x00ff0050
                if extspr_number == 0x5 or extspr_number == 0x11 then
                    color_bg = (Real_frame - id)%4 == 0 and 0x00ff0060 or 0  -- lots of unlisted colours
                end
                draw_rectangle(x_screen+xoff, y_screen+yoff, xrad, yrad, color_line, color_bg) -- regular hitbox
                
                -- Experimental: attempt to show Mario's fireball vs sprites
                -- this is likely wrong in some situation, but I can't solve this yet
                if extspr_number == 5 or extspr_number == 1 then
                    local xoff_spr = x_speed >= 0 and -5 or  1
                    local yoff_spr = - math.floor(y_speed/16) - 4 + (y_speed >= -40 and 1 or 0)
                    local yrad_spr = y_speed >= -40 and 19 or 20
                    draw_rectangle(x_screen + xoff_spr, y_screen + yoff_spr, 12, yrad_spr, color_line, color_bg)
                end
            end
            
            counter = counter + 1
        end
    end
    
    relative_opacity(0.5)
    draw_text(Buffer_width + Border_right, y_pos, fmt("Ext. spr:%2d ", counter), COLOUR.weak, true, false, 0.0, 1.0)
    
end


local function bounce_sprite_info()
    if not OPTIONS.display_bounce_sprite_info then return end
    
    -- Debug info
    local x_txt, y_txt = 90, 37 -- Snes9x
    if OPTIONS.display_debug_info then
        relative_opacity(0.5)
        draw_text(x_txt, y_txt, "Bounce Spr.", COLOUR.weak)
    end
    
    -- Font
    relative_opacity(0.6)
    local height = SNES9X_FONT_HEIGHT
    
    local stop_id = (u8(WRAM.bouncespr_last_id) - 1)%SMW.bounce_sprite_max
    for id = 0, SMW.bounce_sprite_max - 1 do
        local bounce_sprite_number = u8(WRAM.bouncespr_number + id)
        if bounce_sprite_number ~= 0 then
            local x = 256*u8(WRAM.bouncespr_x_high + id) + u8(WRAM.bouncespr_x_low + id)
            local y = 256*u8(WRAM.bouncespr_y_high + id) + u8(WRAM.bouncespr_y_low + id)
            local bounce_timer = u8(WRAM.bouncespr_timer + id)
            
            if OPTIONS.display_debug_info then
                draw_text(x_txt, y_txt + height*(id + 1), fmt("#%d:%d (%d, %d)", id, bounce_sprite_number, x, y))
            end
            
            local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
            x_screen, y_screen = x_screen + 8, y_screen -- Snes9x
            local color = id == stop_id and COLOUR.warning or COLOUR.text
            draw_text(x_screen , y_screen, fmt("#%d:%d", id, bounce_timer), color, false, false, 0.5)  -- timer
            
            -- Turn blocks
            if bounce_sprite_number == 7 then
                turn_block_timer = u8(WRAM.turn_block_timer + id)
                draw_text(x_screen, y_screen + height, turn_block_timer, color, false, false, 0.5)
            end
        end
    end
end


local function sprite_info(id, counter, table_position)
    relative_opacity(1.0)
    
    local sprite_status = u8(WRAM.sprite_status + id)
    if sprite_status == 0 then return 0 end  -- returns if the slot is empty
    
    local x = 256*u8(WRAM.sprite_x_high + id) + u8(WRAM.sprite_x_low + id)
    local y = 256*u8(WRAM.sprite_y_high + id) + u8(WRAM.sprite_y_low + id)
    local x_sub = u8(WRAM.sprite_x_sub + id)
    local y_sub = u8(WRAM.sprite_y_sub + id)
    local number = u8(WRAM.sprite_number + id)
    local stun = u8(WRAM.sprite_stun + id)
    local x_speed = s8(WRAM.sprite_x_speed + id)
    local y_speed = s8(WRAM.sprite_y_speed + id)
    local contact_mario = u8(WRAM.sprite_contact_mario + id)
    local x_offscreen = s8(WRAM.sprite_x_offscreen + id)
    local y_offscreen = s8(WRAM.sprite_y_offscreen + id)
    
    local special = ""
    if OPTIONS.display_debug_info or ((sprite_status ~= 0x8 and sprite_status ~= 0x9 and sprite_status ~= 0xa and sprite_status ~= 0xb) or stun ~= 0) then
        special = string.format("(%d %d) ", sprite_status, stun)
    end
    
    -- Let x and y be 16-bit signed
    x = signed(x, 16)
    y = signed(y, 16)
    
    ---**********************************************
    -- Calculates the sprites dimensions and screen positions
    
    local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
    
    -- Sprite clipping vs mario and sprites
    local boxid = bit.band(u8(WRAM.sprite_2_tweaker + id), 0x3f)  -- This is the type of box of the sprite
    local xoff = HITBOX_SPRITE[boxid].xoff
    local yoff = HITBOX_SPRITE[boxid].yoff + Y_CAMERA_OFF
    local sprite_width = HITBOX_SPRITE[boxid].width
    local sprite_height = HITBOX_SPRITE[boxid].height
    
    -- Sprite clipping vs objects
    local clip_obj = bit.band(u8(WRAM.sprite_1_tweaker + id), 0xf)  -- type of hitbox for blocks
    local xpt_right = OBJ_CLIPPING_SPRITE[clip_obj].xright
    local ypt_right = OBJ_CLIPPING_SPRITE[clip_obj].yright
    local xpt_left = OBJ_CLIPPING_SPRITE[clip_obj].xleft 
    local ypt_left = OBJ_CLIPPING_SPRITE[clip_obj].yleft
    local xpt_down = OBJ_CLIPPING_SPRITE[clip_obj].xdown
    local ypt_down = OBJ_CLIPPING_SPRITE[clip_obj].ydown
    local xpt_up = OBJ_CLIPPING_SPRITE[clip_obj].xup
    local ypt_up = OBJ_CLIPPING_SPRITE[clip_obj].yup
    
    -- Process interaction with player every frame?
    -- Format: dpmksPiS. This 'm' bit seems odd, since it has false negatives
    local oscillation_flag = bit.test(u8(WRAM.sprite_4_tweaker + id), 5) or OSCILLATION_SPRITES[number]
    
    -- calculates the correct color to use, according to id
    local info_color
    local color_background
    if number == 0x35 then
        info_color = COLOUR.yoshi
        color_background = COLOUR.yoshi_bg
    else
        info_color = COLOUR.sprites[id%(#COLOUR.sprites) + 1]
        color_background = COLOUR.sprites_bg
    end
    
    
    if (not oscillation_flag) and (Real_frame - id)%2 == 1 then color_background = 0 end     -- due to sprite oscillation every other frame
                                                                                    -- notice that some sprites interact with Mario every frame
    ;
    
    
    ---**********************************************
    -- Displays sprites hitboxes
    if OPTIONS.display_sprite_hitbox then
        -- That's the pixel that appears when the sprite vanishes in the pit
        if y_screen >= 224 or OPTIONS.display_debug_info then
            draw_pixel(x_screen, y_screen, info_color)
        end
        
        if Sprite_hitbox[id][number].block then
            draw_box(x_screen + xpt_left, y_screen + ypt_down, x_screen + xpt_right, y_screen + ypt_up,
                COLOUR.sprites_clipping_bg, Sprite_hitbox[id][number].sprite and 0 or COLOUR.sprites_clipping_bg)
        end
        
        if Sprite_hitbox[id][number].sprite and not ABNORMAL_HITBOX_SPRITES[number] then  -- show sprite/sprite clipping
            draw_rectangle(x_screen + xoff, y_screen + yoff, sprite_width, sprite_height, info_color, color_background)
        end
        
        if Sprite_hitbox[id][number].block then  -- show sprite/object clipping
            local size, color = 1, COLOUR.sprites_interaction_pts
            draw_line(x_screen + xpt_right, y_screen + ypt_right, x_screen + xpt_right - size, y_screen + ypt_right, 1, color) -- right
            draw_line(x_screen + xpt_left, y_screen + ypt_left, x_screen + xpt_left + size, y_screen + ypt_left, 1, color)  -- left
            draw_line(x_screen + xpt_down, y_screen + ypt_down, x_screen + xpt_down, y_screen + ypt_down - size, 1, color) -- down
            draw_line(x_screen + xpt_up, y_screen + ypt_up, x_screen + xpt_up, y_screen + ypt_up + size, 1, color)  -- up
        end
    end
    
    
    ---**********************************************
    -- Special sprites analysis:
    
    --[[
    PROBLEMATIC ONES
        29	Koopa Kid
        54  Revolving door for climbing net, wrong hitbox area, not urgent
        5a  Turn block bridge, horizontal, hitbox only applies to central block and wrongly
        86	Wiggler, the second part of the sprite, that hurts Mario even if he's on Yoshi, doesn't appear
        89	Layer 3 Smash, hitbox of generator outside
        9e	Ball 'n' Chain, hitbox only applies to central block, rotating ball
        a3	Rotating gray platform, wrong hitbox, rotating plataforms
    ]]
    
    if number == 0x5f then  -- Swinging brown platform (fix it)
        --[[
        local platform_x = -s8(0x1523)
        local platform_y = -s8(0x0036)
        --]]
        
        -- Powerup Incrementation helper
        local yoshi_left  = 256*math.floor(x/256) - 58
        local yoshi_right = 56*math.floor(x/256) - 26
        local x_text, y_text, height = x_screen + xoff, y_screen + yoff, SNES9X_FONT_HEIGHT -- Snes9x
        
        if mouse_onregion(x_text, y_text, x_text + sprite_width, y_text + sprite_height) then -- Snes9x
            y_text = y_text + 32
            draw_text(x_text, y_text, "Powerup Incrementation help:", info_color, COLOUR.background, true, false, 0.5)
            draw_text(x_text, y_text + height, "Yoshi's id must be #4. The x position depends on its direction:",
                            info_color, COLOUR.background, true, false, 0.5)
            draw_text(x_text, y_text + 2*height, fmt("%s: %d, %s: %d.", LEFT_ARROW, yoshi_left, RIGHT_ARROW, yoshi_right),
                            info_color, COLOUR.background, true, false, 0.5)
        end
        --The status change happens when yoshi's id number is #4 and when (yoshi's x position) + Z mod 256 = 214,
        --where Z is 16 if yoshi is facing right, and -16 if facing left. More precisely, when (yoshi's x position + Z) mod 256 = 214,
        --the address 0x7E0015 + (yoshi's id number) will be added by 1.
        -- therefore: X_yoshi = 256*math.floor(x/256) + 32*yoshi_direction - 58
    end
    
    if number == 0x35 then  -- Yoshi
        if not Yoshi_riding_flag and OPTIONS.display_sprite_hitbox and Sprite_hitbox[id][number].sprite then
            draw_rectangle(x_screen + 4, y_screen + 20, 8, 8, COLOUR.yoshi)
        end
    end
    
    if number == 0x62 or number == 0x63 then  -- Brown line-guided platform & Brown/checkered line-guided platform
            xoff = xoff - 24
            yoff = yoff - 8
            -- for some reason, the actual base is 1 pixel below when Mario is small
            if OPTIONS.display_sprite_hitbox then
                draw_rectangle(x_screen + xoff, y_screen + yoff, sprite_width, sprite_height, info_color, color_background)
            end
    end
    
    if number == 0x6b then  -- Wall springboard (left wall)
        xoff = xoff - 8
        sprite_height = sprite_height + 1  -- for some reason, small Mario gets a bigger hitbox
        
        if OPTIONS.display_sprite_hitbox then
            draw_rectangle(x_screen + xoff, y_screen + yoff, sprite_width, sprite_height, info_color, color_background)
            draw_line(x_screen + xoff, y_screen + yoff + 3, x_screen + xoff + sprite_width, y_screen + yoff + 3, 1, info_color)
        end
    end
    
    if number == 0x6c then  -- Wall springboard (right wall)
        xoff = xoff - 31
        sprite_height = sprite_height + 1
        
        if OPTIONS.display_sprite_hitbox then
            draw_rectangle(x_screen + xoff, y_screen + yoff, sprite_width, sprite_height, info_color, color_background)
            draw_line(x_screen + xoff, y_screen + yoff + 3, x_screen + xoff + sprite_width, y_screen + yoff + 3, 1, info_color)
        end
    end
    
    if number == 0x7b then  -- Goal Tape
    
        relative_opacity(0.8)
        
        -- This draws the effective area of a goal tape
        local x_effective = 256*u8(WRAM.sprite_tongue_length + id) + u8(0xc2 + id)  -- unlisted WRAM
        local y_low = 256*u8(0x1534 + id) + u8(WRAM.sprite_miscellaneous3 + id)  -- unlisted WRAM
        local _, y_high = screen_coordinates(0, 0, Camera_x, Camera_y)
        local x_s, y_s = screen_coordinates(x_effective, y_low, Camera_x, Camera_y)
        
        if OPTIONS.display_sprite_hitbox then
            draw_box(x_s, y_high, x_s + 15, y_s, info_color, COLOUR.goal_tape_bg)
        end
        draw_text(x_s, y_screen, fmt("Touch=%4d.0->%4d.f", x_effective, x_effective + 15), info_color, false, false)
        
        -- Draw a bitmap if the tape is unnoticeable
        local x_png, y_png = put_on_screen(x_s, y_s, 18, 6)  -- png is 18x6
        if x_png ~= x_s or y_png > y_s then  -- tape is outside the screen
            gui.gdoverlay(x_png, y_png, IMAGES.goal_tape, 0.6) -- Snes9x
        else
            Show_player_point_position = true
            if y_low < 10 then gui.gdoverlay(x_png, y_png, IMAGES.goal_tape, 0.4) end  -- tape is too small, 10 is arbitrary here
        end
        relative_opacity(1.0, 1.0)
    
    elseif number == 0xa9 then  -- Reznor
    
        local reznor
        local color
        for index = 0, SMW.sprite_max - 1 do
            reznor = u8(WRAM.reznor_killed_flag + index)
            if index >= 4 and index <= 7 then
                color = COLOUR.warning
            else
                color = color_weak
            end
            draw_text(3*SNES9X_FONT_WIDTH*index, Buffer_height, fmt("%.2x", reznor), color, true, false, 0.0, 1.0)
        end
    
    elseif number == 0xa0 then  -- Bowser
    
        local height = SNES9X_FONT_HEIGHT
        local y_text = Screen_height - 10*height
        local address = 0x14b0  -- unlisted WRAM
        for index = 0, 9 do
            local value = u8(address + index)
            draw_text(Buffer_width + Border_right, y_text + index*height, fmt("%2x = %3d", value, value), info_color, true)
        end
    
    end
    
    
    ---**********************************************
    -- Prints those informations next to the sprite
    relative_opacity(0.7, 1.0)  -- Snes9x
    
    if x_offscreen ~= 0 or y_offscreen ~= 0 then
        relative_opacity(0.4)
    end
    
    local contact_str = contact_mario == 0 and "" or " "..contact_mario
    
    local sprite_middle = x_screen + xoff + math.floor(sprite_width/2)
    draw_text(sprite_middle, y_screen + math.min(yoff, ypt_up), fmt("#%.2d%s", id, contact_str), info_color, true, false, 0.5, 1.0)
    
    
    ---**********************************************
    -- Sprite tweakers info
    if OPTIONS.display_debug_info then
        relative_opacity(0.5)  -- Snes9x
        local height = SNES9X_FONT_HEIGHT
        local x_txt, y_txt = sprite_middle - 4*SNES9X_FONT_WIDTH ,  (y_screen + yoff) - 7*height
        
        local tweaker_1 = u8(WRAM.sprite_1_tweaker + id)
        draw_over_text(x_txt, y_txt, tweaker_1, "sSjJcccc", COLOUR.weak, info_color)
        y_txt = y_txt + height
        
        local tweaker_2 = u8(WRAM.sprite_2_tweaker + id)
        draw_over_text(x_txt, y_txt, tweaker_2, "dscccccc", COLOUR.weak, info_color)
        y_txt = y_txt + height
        
        local tweaker_3 = u8(WRAM.sprite_3_tweaker + id)
        draw_over_text(x_txt, y_txt, tweaker_3, "lwcfpppg", COLOUR.weak, info_color)
        y_txt = y_txt + height
        
        local tweaker_4 = u8(WRAM.sprite_4_tweaker + id)
        draw_over_text(x_txt, y_txt, tweaker_4, "dpmksPiS", COLOUR.weak, info_color)
        y_txt = y_txt + height
        
        local tweaker_5 = u8(WRAM.sprite_5_tweaker + id)
        draw_over_text(x_txt, y_txt, tweaker_5, "dnctswye", COLOUR.weak, info_color)
        y_txt = y_txt + height
        
        local tweaker_6 = u8(WRAM.sprite_6_tweaker + id)
        draw_over_text(x_txt, y_txt, tweaker_6, "wcdj5sDp", COLOUR.weak, info_color)
        relative_opacity(1.0)  -- Snes9x
    end
    
    
    ---**********************************************
    -- The sprite table:
    local sprite_str = fmt("#%02d %02x %s%d.%1x(%+.2d) %d.%1x(%+.2d)",
                        id, number, special, x, math.floor(x_sub/16), x_speed, y, math.floor(y_sub/16), y_speed)
                        
    relative_opacity(1.0, 1.0)  -- Snes9x
    if x_offscreen ~= 0 or y_offscreen ~= 0 then
        relative_opacity(0.6)
    end
    draw_text(Buffer_width + Border_right, table_position + counter*SNES9X_FONT_HEIGHT, sprite_str, info_color, true)
    
    -- Exporting some values
    Sprites_info[id].number = number
    Sprites_info[id].x, Sprites_info[id].y = x, y
    Sprites_info[id].x_screen, Sprites_info[id].y_screen = x_screen, y_screen
    Sprites_info[id].boxid = boxid
    Sprites_info[id].xoff, Sprites_info[id].yoff = xoff, yoff
    Sprites_info[id].width, Sprites_info[id].height = sprite_width, sprite_height
    
    return 1
end


local function sprites()
    local counter = 0
    local table_position = 48
    
    if not OPTIONS.display_sprite_info then
        draw_text(0, 32, "Player info: off", COLOUR.very_weak)
        return
    end
    
    for id = 0, SMW.sprite_max - 1 do
        counter = counter + sprite_info(id, counter, table_position)
    end
    
    -- Font
    relative_opacity(0.6) -- Snes9x
    
    local swap_slot = u8(0x1861) -- unlisted WRAM
    local smh = u8(WRAM.sprite_memory_header)
    draw_text(Buffer_width + Border_right, table_position - 2*SNES9X_FONT_HEIGHT, fmt("spr:%.2d", counter), COLOUR.weak, true)
    draw_text(Buffer_width + Border_right, table_position - SNES9X_FONT_HEIGHT, fmt("1st div: %d. Swap: %d", -- Snes9x: no extra space at the end
                                                            SPRITE_MEMORY_MAX[smh], swap_slot), COLOUR.weak, true)
end


local function yoshi()
    if not OPTIONS.display_yoshi_info then
        draw_text(0, 88, "Yoshi info: off", COLOUR.yoshi_bg)
        return
    end
    
    -- Font
    relative_opacity(1.0, 1.0)
    local x_text = 0
    local y_text = 88
    
    local yoshi_id = get_yoshi_id()
    if yoshi_id ~= nil then
        local eat_id = u8(WRAM.sprite_miscellaneous + yoshi_id)
        local eat_type = u8(WRAM.sprite_number + eat_id)
        local tongue_len = u8(WRAM.sprite_tongue_length + yoshi_id)
        local tongue_timer = u8(WRAM.sprite_tongue_timer + yoshi_id)
        local tongue_wait = u8(WRAM.sprite_tongue_wait)
        local tongue_height = u8(WRAM.yoshi_tile_pos)
        local tongue_out = u8(WRAM.sprite_miscellaneous4 + yoshi_id)
        
        local eat_type_str = eat_id == SMW.null_sprite_id and "-" or string.format("%02x", eat_type)
        local eat_id_str = eat_id == SMW.null_sprite_id and "-" or string.format("#%02d", eat_id)
        
        -- Yoshi's direction and turn around
        local turn_around = u8(WRAM.sprite_turn_around + yoshi_id)
        local yoshi_direction = u8(WRAM.sprite_direction + yoshi_id)
        local direction_symbol
        if yoshi_direction == 0 then direction_symbol = RIGHT_ARROW else direction_symbol = LEFT_ARROW end
        
        draw_text(x_text, y_text, fmt("Yoshi %s %d", direction_symbol, turn_around), COLOUR.yoshi)
        local h = SNES9X_FONT_HEIGHT
        
        if eat_id == SMW.null_sprite_id and tongue_len == 0 and tongue_timer == 0 and tongue_wait == 0 then
            relative_opacity(0.2) -- Snes9x
        end
        draw_text(x_text, y_text + h, fmt("(%0s, %0s) %02d, %d, %d",
                            eat_id_str, eat_type_str, tongue_len, tongue_wait, tongue_timer), COLOUR.yoshi)
        ;
        
        -- more WRAM values
        local yoshi_x = 256*u8(WRAM.sprite_x_high + yoshi_id) + u8(WRAM.sprite_x_low + yoshi_id)
        local yoshi_y = 256*u8(WRAM.sprite_y_high + yoshi_id) + u8(WRAM.sprite_y_low + yoshi_id)
        local x_screen, y_screen = screen_coordinates(yoshi_x, yoshi_y, Camera_x, Camera_y)
        
        -- invisibility timer
        local mount_invisibility = u8(WRAM.sprite_miscellaneous2 + yoshi_id)
        if mount_invisibility ~= 0 then
            relative_opacity(0.5) -- Snes9x
            draw_text(x_screen + 4, y_screen - 12, mount_invisibility, COLOUR.yoshi)
        end
        
        -- Tongue hitbox and timer
        if tongue_wait ~= 0 or tongue_out ~=0 or tongue_height == 0x89 then  -- if tongue is out or appearing
            -- the position of the hitbox pixel
            local tongue_direction = yoshi_direction == 0 and 1 or -1
            local tongue_high = tongue_height ~= 0x89
            local x_tongue = x_screen + 24 - 40*yoshi_direction + tongue_len*tongue_direction
            x_tongue = not tongue_high and x_tongue or x_tongue - 5*tongue_direction
            local y_tongue = y_screen + 10 + 11*(tongue_high and 0 or 1)
            
            -- the drawing
            local tongue_line
            if tongue_wait <= 9  then  -- hitbox point vs berry tile
                draw_rectangle(x_tongue - 1, y_tongue - 1, 2, 2, COLOUR.tongue_bg, COLOUR.text)
                tongue_line = COLOUR.tongue_line
            else tongue_line = COLOUR.tongue_bg
            end
            
            -- tongue out: time predictor
            local tinfo, tcolor
            if tongue_wait > 9 then tinfo = tongue_wait - 9; tcolor = COLOUR.tongue_line  -- not ready yet
            
            elseif tongue_out == 1 then tinfo = 17 + tongue_wait; tcolor = COLOUR.text  -- tongue going out
            
            elseif tongue_out == 2 then  -- at the max or tongue going back
                tinfo = math.max(tongue_wait, tongue_timer) + math.floor((tongue_len + 7)/4) - (tongue_len ~= 0 and 1 or 0)
                tcolor = eat_id == SMW.null_sprite_id and COLOUR.text or COLOUR.warning
            
            elseif tongue_out == 0 then tinfo = 0; tcolor = COLOUR.text  -- tongue in
            
            else tinfo = tongue_timer + 1; tcolor = COLOUR.tongue_line -- item was just spat out
            end
            
            relative_opacity(0.5) -- Snes9x
            draw_text(x_tongue + 4, y_tongue + 5, tinfo, tcolor, false, false, 0.5)
            relative_opacity(1.0) -- Snes9x
            draw_rectangle(x_tongue, y_tongue + 1, 8, 4, tongue_line, COLOUR.tongue_bg)
        end
        
    end
end


local function show_counters()
    if not OPTIONS.display_counters then
        draw_text(0, 102, "Counters info: off", COLOUR.very_weak)
        return
    end
    
    -- Font
    relative_opacity(1.0, 1.0)
    local height = SNES9X_FONT_HEIGHT
    local text_counter = 0
    
    local multicoin_block_timer = u8(WRAM.multicoin_block_timer)
    local gray_pow_timer = u8(WRAM.gray_pow_timer)
    local blue_pow_timer = u8(WRAM.blue_pow_timer)
    local dircoin_timer = u8(WRAM.dircoin_timer)
    local pballoon_timer = u8(WRAM.pballoon_timer)
    local star_timer = u8(WRAM.star_timer)
    local invisibility_timer = u8(WRAM.invisibility_timer)
    local animation_timer = u8(WRAM.animation_timer)
    local fireflower_timer = u8(WRAM.fireflower_timer)
    local yoshi_timer = u8(WRAM.yoshi_timer)
    local swallow_timer = u8(WRAM.swallow_timer)
    local lakitu_timer = u8(WRAM.lakitu_timer)
    local score_incrementing = u8(WRAM.score_incrementing)
    local end_level_timer = u8(WRAM.end_level_timer)
    
    local display_counter = function(label, value, default, mult, frame, color)
        if value == default then return end
        text_counter = text_counter + 1
        local color = color or COLOUR.text
        
        draw_text(0, 102 + (text_counter * height), fmt("%s: %d", label, (value * mult) - frame), color)
    end
    
    display_counter("Multi Coin", multicoin_block_timer, 0, 1, 0, 0xffff00ff) --
    display_counter("Pow", gray_pow_timer, 0, 4, Effective_frame % 4, 0xa5a5a5ff) --
    display_counter("Pow", blue_pow_timer, 0, 4, Effective_frame % 4, 0x4242deff) --
    display_counter("Dir Coin", dircoin_timer, 0, 4, Real_frame % 4, 0x8c5a19ff) --
    display_counter("P-Balloon", pballoon_timer, 0, 4, Real_frame % 4, 0xf8d870ff) --
    display_counter("Star", star_timer, 0, 4, (Effective_frame - 3) % 4, 0xffd773ff)  --
    display_counter("Invibility", invisibility_timer, 0, 1, 0)
    display_counter("Fireflower", fireflower_timer, 0, 1, 0, 0xff8c00ff) --
    display_counter("Yoshi", yoshi_timer, 0, 1, 0, COLOUR.yoshi) --
    display_counter("Swallow", swallow_timer, 0, 4, (Effective_frame - 1) % 4, COLOUR.yoshi) --
    display_counter("Lakitu", lakitu_timer, 0, 4, Effective_frame % 4) --
    display_counter("End Level", end_level_timer, 0, 2, (Real_frame - 1) % 2)
    display_counter("Score Incrementing", score_incrementing, 0x50, 1, 0)
    
    if Lock_animation_flag ~= 0 then display_counter("Animation", animation_timer, 0, 1, 0) end  -- shows when player is getting hurt or dying
    
end


-- Main function to run inside a level
local function level_mode()
    if Game_mode == SMW.game_mode_level then
        
        -- Draws/Erases the tiles if user clicked
        draw_tilesets(Camera_x, Camera_y)
        
        sprites()
        
        extended_sprites()
        
        bounce_sprite_info()
        
        level_info()
        
        player()
        
        yoshi()
        
        show_counters()
        
        -- Draws/Erases the hitbox for objects
        if true or User_input.mouse_inwindow == 1 then
            select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
        end
        
    end
end


local function overworld_mode()
    if Game_mode ~= SMW.game_mode_overworld then return end
    
    -- Font
    relative_opacity(1.0, 1.0)
    
    local height = SNES9X_FONT_HEIGHT
    local y_text = SNES9X_FONT_HEIGHT
    
    -- Real frame modulo 8
    local real_frame_8 = Real_frame%8
    draw_text(Buffer_width + Border_right, y_text, fmt("Real Frame = %3d = %d(mod 8)", Real_frame, real_frame_8), true)
    
    -- Star Road info
    local star_speed = u8(WRAM.star_road_speed)
    local star_timer = u8(WRAM.star_road_timer)
    y_text = y_text + height
    draw_text(Buffer_width + Border_right, y_text, fmt("Star Road(%x %x)", star_speed, star_timer), COLOUR.cape, true)
end


local function left_click()
    local buttontable = Script_buttons
    
    for _, field in pairs(buttontable) do
        
        -- if mouse is over the button
        if mouse_onregion(field.x, field.y, field.x + field.width, field.y + field.height) then
                field.action()
                Script_buttons = {}
                return
        end
    end
    
    -- Drag and drop sprites
    if OPTIONS.allow_cheats then
        local id = select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
        if type(id) == "number" and id >= 0 and id < SMW.sprite_max then
            Cheat.dragging_sprite_id = id
            Cheat.is_dragging_sprite = true
            return
        end
    end
    
    select_tile()
end


-- This function runs at the end of paint callback
-- Specific for info that changes if the emulator is paused and idle callback is called
local function snes9x_buttons()
    -- Font
    relative_opacity(1.0) -- Snes9x
    
    if not Show_options_menu and User_input.mouse_inwindow == 1 then
        create_button(100, -Border_top, " Menu ", function() Show_options_menu = true end) -- Snes9x
        
        create_button(-Border_left, Buffer_height - Border_bottom, OPTIONS.allow_cheats and "Cheats: allowed" or "Cheats: blocked",
            function() OPTIONS.allow_cheats = not OPTIONS.allow_cheats end, true, false, 0.0, 1.0)
        ;
        
        create_button(Buffer_width + Border_right, Buffer_height + Border_bottom, "Erase Tiles",
            function() Tiletable = {} end, true, false, 0.0, 1.0)
        ;
    else
        if OPTIONS.allow_cheats then  -- show cheat status anyway
            relative_opacity(0.5)
            draw_text(-Border_left, Buffer_height + Border_bottom, "Cheats: allowed", COLOUR.warning, true, false, 0.0, 1.0)
        end
    end
    
    -- Drag and drop sprites with the mouse
    if Cheat.is_dragging_sprite then
        Cheat.drag_sprite(Cheat.dragging_sprite_id)
        Cheat.is_cheating = true
    end
    
    options_menu()
end



--#############################################################################
-- CHEATS

-- This signals that some cheat is activated, or was some short time ago
Cheat.is_cheating = false
function Cheat.is_cheat_active()
    if Cheat.is_cheating then
        alert_text(Buffer_middle_x - 3*SNES9X_FONT_WIDTH, 0, " Cheat ", COLOUR.warning,COLOUR.warning_bg)
        Previous.is_cheating = true
    else
        if Previous.is_cheating then
            emu.message("Script applied cheat")
            Previous.is_cheating = false
        end
    end
end


-- Called from Cheat.beat_level()
function Cheat.activate_next_level(secret_exit)
    if u8(WRAM.level_exit_type) == 0x80 and u8(WRAM.midway_point) == 1 then
        if secret_exit then
            u8(WRAM.level_exit_type, 0x2)
        else
            u8(WRAM.level_exit_type, 1)
        end
    end
    
    Cheat.is_cheating = true
end


-- allows start + select + X to activate the normal exit
--        start + select + A to activate the secret exit 
--        start + select + B to exit the level without activating any exits
function Cheat.beat_level()
    if Is_paused and Joypad["select"] == 1 and (Joypad["X"] == 1 or Joypad["A"] == 1 or Joypad["B"] == 1) then
        u8(WRAM.level_flag_table + Level_index, bit.bor(Level_flag, 0x80))
        
        local secret_exit = Joypad["A"] == 1
        if Joypad["B"] == 0 then
            u8(WRAM.midway_point, 1)
        else
            u8(WRAM.midway_point, 0)
        end
        
        Cheat.activate_next_level(secret_exit)
    end
end


-- This function makes Mario's position free
-- Press L+R+up to activate and L+R+down to turn it off.
-- While active, press directionals to fly free and Y or X to boost him up
Cheat.under_free_move = false
function Cheat.free_movement()
    if (Joypad["L"] == 1 and Joypad["R"] == 1 and Joypad["up"] == 1) then Cheat.under_free_move = true end
    if (Joypad["L"] == 1 and Joypad["R"] == 1 and Joypad["down"] == 1) then Cheat.under_free_move = false end
    if not Cheat.under_free_move then
        if Previous.under_free_move then u8(WRAM.frozen, 0) end
        return
    end
    
    local x_pos, y_pos = u16(WRAM.x), u16(WRAM.y)
    local movement_mode = u8(WRAM.player_movement_mode)
    local pixels = (Joypad["Y"] == 1 and 7) or (Joypad["X"] == 1 and 4) or 1  -- how many pixels per frame
    
    if Joypad["left"] == 1 then x_pos = x_pos - pixels end
    if Joypad["right"] == 1 then x_pos = x_pos + pixels end
    if Joypad["up"] == 1 then y_pos = y_pos - pixels end
    if Joypad["down"] == 1 then y_pos = y_pos + pixels end
    
    -- freeze player to avoid deaths
    if movement_mode == 0 then
        u8(WRAM.frozen, 1)
        u8(WRAM.x_speed, 0)
        u8(WRAM.y_speed, 0)
        
        -- animate sprites by incrementing the effective frame
        u8(WRAM.effective_frame, (u8(WRAM.effective_frame) + 1) % 256)
    else
        u8(WRAM.frozen, 0)
    end
    
    -- manipulate some values
    u16(WRAM.x, x_pos)
    u16(WRAM.y, y_pos)
    u8(WRAM.invisibility_timer, 127)
    u8(WRAM.vertical_scroll, 1)  -- free vertical scrolling
    
    Cheat.is_cheating = true
    Previous.under_free_move = true
end


-- Drag and drop sprites with the mouse, if the cheats are activated and mouse is over the sprite
-- Right clicking and holding: drags the sprite
-- Releasing: drops it over the latest spot
function Cheat.drag_sprite(id)
    if Game_mode ~= SMW.game_mode_level then Cheat.is_dragging_sprite = false ; return end
    
    local xoff, yoff = Sprites_info[id].xoff, Sprites_info[id].yoff
    local xgame, ygame = game_coordinates(User_input.xmouse - xoff, User_input.ymouse - yoff, Camera_x, Camera_y)
    
    local sprite_xhigh = math.floor(xgame/256)
    local sprite_xlow = xgame - 256*sprite_xhigh
    local sprite_yhigh = math.floor(ygame/256)
    local sprite_ylow = ygame - 256*sprite_yhigh
    
    u8(WRAM.sprite_x_high + id, sprite_xhigh)
    u8(WRAM.sprite_x_low + id, sprite_xlow)
    u8(WRAM.sprite_y_high + id, sprite_yhigh)
    u8(WRAM.sprite_y_low + id, sprite_ylow)
end


--#############################################################################
-- MAIN --


-- Key presses:
Keys.registerkeypress("rightclick", right_click)
Keys.registerkeypress("leftclick", left_click)
Keys.registerkeypress(OPTIONS.hotkey_increase_opacity, increase_opacity)
Keys.registerkeypress(OPTIONS.hotkey_decrease_opacity, decrease_opacity)

-- Key releases:
Keys.registerkeyrelease("mouse_inwindow", function() Cheat.is_dragging_sprite = false end)
Keys.registerkeyrelease("leftclick", function() Cheat.is_dragging_sprite = false end)


-- Function that is called from the paint and video callbacks
local function main_paint_function(not_synth, from_paint)
    -- Initial values, don't make drawings here
    snes9x_status()
    
    -- Drawings are allowed now
    scan_smw()
    
    level_mode()
    overworld_mode()
    
    show_movie_info()
    show_misc_info()
    show_controller_data()
    
    Cheat.is_cheat_active()
    
    snes9x_buttons()
end


gui.register(main_paint_function)

emu.registerbefore(function()
    get_joypad()
    
    if OPTIONS.allow_cheats then
        Cheat.is_cheating = false
        
        Cheat.beat_level()
        Cheat.free_movement()
    else
        -- Cancel any continuous cheat
        Cheat.under_free_move = false
        
        Cheat.is_cheating = false
    end
end)

print("Lua script loaded successfully.")


while true do
    -- User input data
    Previous.User_input = copytable(User_input)
    local tmp = input.get()
    for entry, value in pairs(User_input) do
        User_input[entry] = tmp[entry] or false
    end
    User_input.mouse_inwindow = mouse_onregion(0, 0, Buffer_width - 1, Buffer_height - 1) and 1 or 0 -- Snes9x, custom field
    
    -- Detect if a key was just pressed or released
    for entry, value in pairs(User_input) do
        if (value ~= false) and (Previous.User_input[entry] == false) then Keys.pressed[entry] = true
            else Keys.pressed[entry] = false
        end
        if (value == false) and (Previous.User_input[entry] ~= false) then Keys.released[entry] = true
            else Keys.released[entry] = false
        end
    end
    
    -- Key presses/releases execution:
    for entry, value in pairs(Keys.press) do
        if Keys.pressed[entry] then
            value()
        end
    end
    for entry, value in pairs(Keys.release) do
        if Keys.released[entry] then
            value()
        end
    end
    
    -- Lag-flag is accounted correctly only inside this loop
    Is_lagged = emu.lagged()
    
    emu.frameadvance()
end
