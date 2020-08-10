k = {}
hook.Add("Initialize","SetupArrays", function()

	print([[
		
		NLR System By Kaslan.
		]])

		k.PlayersWithNLR = {}
		k.curtime = CurTime()

end)

hook.Add("PlayerDeath", "SetNewNLR", function(victim)

	table.RemoveByValue(k.PlayersWithNLR, victim)
	table.insert(k.PlayersWithNLR, victim)

	victim:SetNWInt("NLRTimer", 180)
	victim:SetNWBool("NLRStatus", true)

end)

hook.Add("Think", "CountDownNLR", function()
	if CurTime() - 1 > k.curtime then
		k.curtime = CurTime()	

			for key,ply in pairs(k.PlayersWithNLR) do

				local CurrentNLRTime = ply:GetNWInt("NLRTimer")
				local NewNLRTime     = CurrentNLRTime - 1

				if NewNLRTime > 0 then
					ply:SetNWString("NLRTimer", NewNLRTime)
				else
					ply:SetNWInt("NLRTimer", 0)
					ply:SetNWBool("NLRStatus", false)
					table.RemoveByValue(k.PlayersWithNLR, ply)
				end
			end
	end
end)
