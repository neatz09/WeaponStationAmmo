class WeaponStationAmmoClassicSniperPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=NewWeaponStatic.usx

defaultproperties
{
    InventoryType=class'ClassicSniperRifle'
    PickupMessage="You got the Sniper Rifle."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'NewWeaponStatic.NewSniperPickup'
    DrawScale=0.21
}
                            