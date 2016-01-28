--Duby: Sounds lol, lets have some. I mean why not right!?

local sounds = {}

sounds	["burp"] = { Sound("mrgreen/burp.wav") }
sounds	["ok"] = { Sound("vo/npc/female01/ok01.wav"), Sound("vo/npc/female01/ok02.wav") }
sounds	["hack"] = { Sound("vo/npc/female01/hacks01.wav"), Sound("vo/npc/female01/hacks02.wav") }
sounds	["headcrab"] = { Sound("vo/npc/female01/headcrabs01.wav"), Sound("vo/npc/female01/headcrabs02.wav") }
sounds	["incoming"] = { Sound("vo/npc/female01/incoming02.wav") }
sounds	["help"] = { Sound("vo/npc/female01/help01.wav") }
sounds	["s go"] = { Sound("vo/npc/female01/letsgo01.wav"), Sound("vo/npc/female01/letsgo02.wav") }
sounds	["run"] = { Sound("vo/npc/female01/runforyourlife01.wav"), Sound("vo/npc/female01/runforyourlife02.wav") }
sounds	["watch out"] = { Sound("vo/npc/female01/watchout.wav"), Sound("vo/npc/female01/headsup01.wav") }
sounds	["nice"] = { Sound("vo/npc/female01/nice01.wav"), Sound("vo/npc/female01/nice02.wav") }
sounds	["get down"] = { Sound("vo/npc/female01/getdown02.wav") }
sounds	["oh shi"] = { Sound("vo/npc/female01/uhoh.wav"), Sound("vo/npc/female01/ohno.wav") }
sounds	["zombie"] = { Sound("vo/npc/female01/zombies01.wav"), Sound("vo/npc/female01/zombies02.wav") }
sounds	["get out"] = { Sound("vo/npc/female01/gethellout.wav") }

sounds[ "hi" ] = { "vo/npc/male01/hi01.wav", "vo/npc/male01/hi02.wav" }
sounds[ "hello" ] = sounds[ "hi" ]
sounds[ "hey" ] = sounds[ "hi" ]

sounds[ "over9000" ] = {"mrgreen/9000.wav"}

sounds[ "leeroy" ] = {"mrgreen/leeroy.mp3"}

sounds[ "sparta" ] = {"mrgreen/sparta.wav"}

sounds[ "follow" ] = { "vo/coast/odessa/male01/stairman_follow01.wav", "vo/npc/male01/squad_follow02.wav", "vo/coast/cardock/le_followme.wav" }

sounds[ "wait" ] = { "vo/trainyard/man_waitaminute.wav" }
sounds[ "get in" ] = { "vo/canals/gunboat_getin.wav" }

sounds[ "not good" ] = { "vo/trainyard/male01/cit_window_use01.wav" }
sounds[ "isn't good" ] = sounds[ "not good" ]
sounds[ "isnt good" ] = sounds[ "not good" ]

sounds[ "stop it" ] = { "vo/trainyard/male01/cit_hit01.wav", "vo/trainyard/male01/cit_hit02.wav", "vo/trainyard/male01/cit_hit03.wav", "vo/trainyard/male01/cit_hit04.wav", "vo/trainyard/male01/cit_hit05.wav" }
sounds[ "cut it" ] = sounds[ "stop it" ]
sounds[ "stop that" ] = sounds[ "stop it" ]

sounds[ "same here" ] = { "vo/npc/male01/answer07.wav" }

sounds[ "shut up" ] = { "vo/npc/male01/answer17.wav" }

sounds[ "you never know" ] = { "vo/npc/male01/answer22.wav" }
sounds[ "wanna bet" ] = { "vo/npc/male01/answer27.wav" }

sounds[ "you sure" ] = { "vo/npc/male01/answer37.wav" }

sounds[ "i'm busy" ] = { "vo/npc/male01/busy02.wav" }
sounds[ "im busy" ] = sounds[ "i'm busy" ]

sounds[ "excuse me" ] = { "vo/npc/male01/excuseme01.wav", "vo/npc/male01/excuseme02.wav" }

sounds[ "fantastic" ] = { "vo/npc/male01/fantastic01.wav", "vo/npc/male01/fantastic02.wav" }

sounds[ "good god" ] = { "vo/npc/male01/goodgod.wav", "vo/npc/male01/gordead_ans04.wav" }
sounds[ "oh my god" ] = sounds[ "good god" ]
sounds[ "gosh" ] = sounds[ "good god" ]
sounds[ "omg" ] = sounds[ "good god" ]
sounds[ "omfg" ] = sounds[ "good god" ]

sounds[ "oh no" ] = { "vo/npc/male01/gordead_ans05.wav" }

sounds[ "sorry" ] = { "vo/npc/male01/sorry01.wav", "vo/npc/male01/sorry02.wav", "vo/npc/male01/sorry03.wav" }

sounds[ "uhoh" ] = { "vo/npc/male01/uhoh.wav" }
sounds[ "uh oh" ]  = sounds[ "uhoh" ]

sounds[ "oops" ] = { "vo/npc/male01/whoops01.wav" }
sounds[ "whoops" ] = sounds[ "oops" ]

sounds[ "yeah" ] = { "vo/npc/male01/yeah02.wav" }
sounds[ "yes" ] = sounds[ "yeah" ]


CreateClientConVar( "chatsounds", "1", true, false)

local function CheckChat( pl, text )
	
	if GetConVarNumber( "chatsounds" ) == 0 then return end
	
	local prefix = string.sub( text, 0, 1 )

	if prefix ~= "/" and prefix ~= "!" and prefix ~= "@" then -- should cover most chat commands for various mods/addons

                for k, v in pairs( sounds ) do

                        local res1, res2 = string.find( string.lower( text ), k )
                        if res1 and ( not text[ res1 - 1 ] or text[ res1 - 1 ] == "" or text[ res1 - 1 ] == " " ) and ( not text[ res2 + 1 ] or text[ res2 + 1 ] == "" or text[ res2 + 1 ] == " " ) then

                                pl:EmitSound( table.Random( v ), 80, 100 )
                                break
                        end

                end

        end

end

hook.Add( "PlayerSay", "ChatSounds", CheckChat )