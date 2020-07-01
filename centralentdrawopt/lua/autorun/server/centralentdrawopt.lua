------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any suggestion, contact me on my steam.
------------- GNU General Public License v3.0
------------- https://steamcommunity.com/id/Inj3/
------------- www.centralcityrp.fr/ --- Affiliated Website 
------------- https://steamcommunity.com/groups/CentralCityRoleplay --- Affiliated Group
util.AddNetworkString( "centralopticlient" )

hook.Add( "PlayerInitialSpawn", "Central_Improved_RenderInit", function(ply)
timer.Simple(5, function()
if !IsValid(ply) then return end
net.Start("centralopticlient") 
net.Send(ply)
end)
end)

MsgC( Color( 0, 250, 0 ), "Improved Object Render loaded.\n" )
