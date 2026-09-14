class WeaponStationAmmoShockPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=NewWeaponPickups.usx

defaultproperties
{
    InventoryType=class'ShockRifle'
    PickupMessage="You got the Shock Rifle."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'NewWeaponPickups.ShockPickupSM'
    DrawScale=0.55
}
