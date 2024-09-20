-- LlamaFontSampler
--  Loads in a bunch of fonts and shows some sample text with them
--
--  Scott Lawrence - yorgle@gmail.com


-- version history
local app_version = "2.0 2022-05-28"
--  2.0 2022-05-28 - With amiga decorations, two views.
--  1.0 2022-03-06 - Initial version


-------------------------------------------------
-- standard stuffs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "CoreLibs/nineslice"

local gfx <const> = playdate.graphics

-- copy the system font to bold so we can use the chars
gfx.setFont( gfx.getSystemFont(), playdate.graphics.font.kVariantBold )


-- list of all fonts we're gonna load
-- this is relative to the Source directory,
-- and per Playdate SDK standards, no file extensions are used
local font_paths = {
    "Fonts/ammolite_10",
    "Fonts/diamond_12",
    "Fonts/diamond_20",
    "Fonts/dpaint_8",
    "Fonts/emerald_17",

    "Fonts/emerald_20",
    "Fonts/garnet_16",
    "Fonts/garnet_9",
    "Fonts/onyx_9",
    "Fonts/opal_12",

    "Fonts/opal_9",
    "Fonts/peridot_7",
    "Fonts/ruby_12",
    "Fonts/ruby_15",
    "Fonts/ruby_8",

    "Fonts/sapphire_14",
    "Fonts/sapphire_19",
    "Fonts/topaz_11",
    "Fonts/topaz_serif_8"
}

-- fonts is where we'll load in all of those
local fonts = { }

local fontheight = 0;

gfx.setColor(gfx.kColorBlack)


class('Wind').extends( Object )

function Wind:init( xx, yy, ww, hh )
    Wind.super.init( self )

    self.visible = false

    self.ix = 16
    self.iy = 12
    self.iw = 4
    self.ih = 9

    self.decorations = null
    self.x = xx
    self.y = yy
    self.w = ww
    self.h = hh

    self.title = ''

    self.drawcb = null

    self.decorations = gfx.nineSlice.new( "assets/decorations_amiga", 
            self.ix, self.iy, self.iw, self.ih )
end

function Wind:Show()
    self.visible = true
end

function Wind:Hide()
    self.visible = false
end

function Wind:ToggleHidden()
    if self.visible then 
        self.visible = false
    else
        self.visible = true
    end
end

function Wind:__innerDraw( x, y, w, h, cbfunc )
    -- adjust
    x=x-14
    y=y-1
    h=h+1
    w=w+16
    gfx.setClipRect(x, y, w, h)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect( x, y, w, h )

    gfx.setColor(gfx.kColorBlack)

    if cbfunc ~= null then
        cbfunc( x, y, w, h )
    end

    gfx.clearClipRect()
end

function Wind:draw( cbfunc )
    if self.visible == false then return end

    gfx.setImageDrawMode( playdate.graphics.kDrawModeCopy )


    self.decorations:drawInRect( self.x, self.y, self.w, self.h )
    self.decW,self.decH = self.decorations:getSize()

    -- outer box
    gfx.setColor(gfx.kColorBlack)
    gfx.drawRect( self.x-1, self.y-1, self.decW+2, self.decH+2 )

    -- title
    if title ~= '' and fonts ~= nil then
        gfx.setFont( fonts[ 4 ] )
        local ww = fonts[ 4 ]:getTextWidth( self.title )

        gfx.setColor( gfx.kColorWhite )
        gfx.fillRect( self.x + self.ix, self.y, ww + 2, 10 )
        fonts[ 4 ]:drawText( self.title, self.x + self.ix, self.y+1 )
    end

    -- inner fill
    gfx.setColor(gfx.kColorWhite)
    self:__innerDraw( self.x + self.ix, self.y + self.iy, 
        self.decW - self.decorations.minWidth,
        self.decH - self.decorations.minHeight,
        cbfunc
    )
    --[[
    gfx.drawRect( self.x + self.ix, self.y + self.iy, 
            self.decW - self.decorations.minWidth,
            self.decH - self.decorations.minHeight );
            --]]
end

win1 = Wind( 0,0, 400, 130 )
win2 = Wind( 0,120, 400, 119 )

win3 = Wind( 20, 20, 360, 204 )

-- myGameSetUp()
--  general init stuff
function myGameSetUp()
    --printTable( font_paths )

    win1.title = "LlamaFonts - v" .. app_version
    win1:Show()
    win2:Show()

    win3:Show()
    win3.title = "About LlamaFonts..."

    -- load in the fonts
    for i = 1, #font_paths do
        fonts[ i ] = playdate.graphics.font.new( font_paths[ i ] )
    end

    -- and start on the first one.
    mySetFont( 1 )

    --  local menu = playdate.getSystemMenu()
    -- local menuItem, error = menu:addMenuItem("Item 1", function()
    --     print("Item 1 selected")
    -- end)
    -- 
    -- local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("Item 2", true, function(value)
    --     print("Checkmark menu item value changed to: ", value)
    -- end)
end

--------------------------------------
-- Set the font to be one of the ones int he array

local current_font_index = 1

-- mySetFont
--  set the font to the specified index in the array
--  the value is constrained within valid values.
function mySetFont( idx )

    -- constrain top
    if idx > #font_paths then
        idx = 1
    end

    -- constrain bottom
    if idx < 1 then
        idx = #font_paths
    end

    -- set the font
    playdate.graphics.setFont( fonts[ idx ] )

    -- remember it
    current_font_index = idx

    -- store the name aside so we can print it out.
    fontname = font_paths[ idx ]:gsub( '_', '__' ):gsub( 'Fonts/', '' )
    
    -- and the size to be used in a few places
    fontheight = playdate.graphics.getFont():getHeight()
end


gfx.setFont( )

-- buttons up and down will change the selected font
function playdate.upButtonDown()
    mySetFont( current_font_index - 1 )

end
function playdate.downButtonDown()
    mySetFont( current_font_index + 1 )
end


-- drawTextBlock
--  draw an array of lines of text out
function drawTextBlock( lines, x, y )
    local dy = playdate.graphics.getFont():getHeight()

    for i = 1, #lines do
        playdate.graphics.drawText( lines[i], x, y + (dy * i ))
    end
end


-- update
--  the standard draw update routine
function playdate.update()

    if playdate.buttonJustPressed( playdate.kButtonA ) then
        win3:ToggleHidden()
    end

    if playdate.buttonJustPressed( playdate.kButtonB ) then
        win1:ToggleHidden()
        win2:ToggleHidden()
    end


    -- backfill
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)

    gfx.setColor(gfx.kColorBlack)
    playdate.graphics.setDitherPattern(0.5)
    gfx.fillRect(0, 0, 400, 240)
    --playdate.drawFPS(0,0)

    --playdate.graphics.drawText("Font: " .. fontname, 10, 10 )
    mySetFont( current_font_index )
    win1:draw( function( xx, yy, ww, hh ) 
        mySetFont( current_font_index )
        gfx.setColor(gfx.kColorBlack)
        drawTextBlock( {
            fontname,
            playdate.getCurrentTimeMilliseconds(),
            "The quick brown fox jumped over the lazy dogs.",
            "Lorem Ipsum sit dolor ahmet zappa.",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789",
            "abcdefghijklmnopqrstuvwxyz !@#$%^&**()",
            "MMMMZZmm  iiiiiiiiiiiii",
            "jftjftjft mmmmmmmmmmmmm",
            "MMMMZZmm"
        }, xx+2, yy-fontheight+2 )
    end)

    win2:draw( function( xx, yy, ww, hh ) 
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect( xx, yy, ww, hh )

        gfx.setColor(gfx.kColorBlack)
        gfx.setImageDrawMode( playdate.graphics.kDrawModeFillWhite )

        mySetFont( current_font_index )
        drawTextBlock( {
            fontname ,
            playdate.getCurrentTimeMilliseconds(),
            "The quick brown fox jumped over the lazy dogs.",
            "Lorem Ipsum sit dolor ahmet zappa.",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789",
            "abcdefghijklmnopqrstuvwxyz !@#$%^&**()",
            "MMMMZZmm  iiiiiiiiiiiii",
            "jftjftjft mmmmmmmmmmmmm",
            "MMMMZZmm"
        }, xx+2, yy-fontheight+2 )
    end)

    win3:draw( function( xx, yy, ww, hh ) 
        gfx.setColor(gfx.kColorBlack)
        gfx.setImageDrawMode( playdate.graphics.kDrawModeCopy )

        mySetFont( 18 )
        drawTextBlock( {
            "     Welcome!",
            "",
            "This app is meant to show off some fonts that",
            "I have converted.  Feel free to pull the font",
            "files from this project for use in yours!",
            "",
            "Give a shout out to this project or my itch page:",
            " https://bleullama.itch.io",
            "",
            "Thanks!",
            "   - Scott Lawrence",
            "     yorgle@gmail.com",
            "",
            "*⬆️* *⬇️* to change font             *Ⓐ* to continue"
        }, xx+10, yy-fontheight+5 )
    end)

   -- Ⓐ Ⓑ    🟨 ⊙ 🔒 🎣 ✛ ⬆️ ➡️ ⬇️ ⬅️


    -- and put app info at the bottom
    --[[
    drawTextBlock( 
        { "Font Sampler - yorgle@gmail.com  v" .. app_version},
        1,  playdate.display.getHeight() - 2* fontheight )
        --]]

    -- so... this -2*fontheight rather than just a single one is 
    -- probably wrong.  I think i have something set wrong in the font.
end


-- make sure it gets run!
myGameSetUp()
