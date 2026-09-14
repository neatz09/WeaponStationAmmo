class WeaponStationAmmoAssaultPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=NewWeaponPickups.usx

defaultproperties
{
    InventoryType=class'AssaultRifle'
    PickupMessage="You got the Assault Rifle."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'NewWeaponPickups.AssaultPickupSM'
    DrawScale=0.5
}
