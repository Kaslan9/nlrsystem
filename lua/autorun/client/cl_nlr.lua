surface.CreateFont( "TestFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
kclient = {}

hook.Add("Initialize","SetUpClient", function()

	print([[

		NLR System By Kaslan.
		]])

		kclient.curtime = CurTime()
		kclient.localcurtime = CurTime()
		kclient.TargetNLRStatus = nil
end)

function kboard.CheckForAdmin()
	return table.HasValue({"owner", "headadmin", "admin", "developer","superadmin"}, LocalPlayer():GetNWString("usergroup"))
end

hook.Add("PostPlayerDraw", "DrawNLRTime", function(ply)

	if ( !IsValid(ply) || ply == LocalPlayer() || !ply:Alive() ) then return end
	if !kboard.CheckForAdmin() then return end

	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	if ( !trace.HitNonWorld ) then return end

	if CurTime() - 1 > kclient.curtime then
		kclient.curtime = CurTime()

		if trace.Entity:IsPlayer() then 
			targetply = trace.Entity
			local targetNLRTime = targetply:GetNWInt("NLRTimer")
			kclient.TargetNLRStatus = targetply:GetNWBool("NLRStatus")
		end
	end
	if !kclient.TargetNLRStatus then return end

	if ply == targetply then
		local dist = LocalPlayer():GetPos():Distance( ply:GetPos() )
		if dist > 200 then return end 
		

		local offset = Vector( 0, 0, 85 )
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:EyePos()
			  pos.z = pos.z + 30

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90)


		cam.Start3D2D( pos, ang, 0.1 )
			draw.DrawText( "NLR: "..targetply:GetNWInt("NLRTimer"), "TestFont", 2, 2, Color(255,0,0), TEXT_ALIGN_CENTER )
		cam.End3D2D()

	end
end)

hook.Add("HUDPaint", "DrawHUDNLR", function()

	if CurTime() - 1 > kclient.localcurtime then
		kclient.localcurtime = CurTime()
		kclient.PlayerNLRStatus = LocalPlayer():GetNWBool("NLRStatus")
		kclient.PlayerNLRTimer  = LocalPlayer():GetNWInt("NLRTimer")

	end

	if !kclient.PlayerNLRStatus then return end

	local scrH = ScrH()
	local scrW = ScrW()
	local xwidth  = 196
	local yheight = 64
	surface.SetDrawColor( 64,64,64, 255 )
	surface.DrawRect( ScrW()/2 - xwidth/2, 30, xwidth, yheight )

	surface.SetFont( "TestFont" )
		local text = "NLR: "..kclient.PlayerNLRTimer
		local textwidth = surface.GetTextSize(text)

	surface.SetTextColor( 255, 0, 0 )
	surface.SetTextPos( scrW/2 - textwidth/2 , 38 )
	surface.DrawText( "NLR: "..kclient.PlayerNLRTimer)
end)