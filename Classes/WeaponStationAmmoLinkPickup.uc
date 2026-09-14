class WeaponStationAmmoLinkPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=NewWeaponPickups.usx

defaultproperties
{
    InventoryType=class'LinkGun'
    PickupMessage="You got the Link Gun."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'NewWeaponPickups.LinkPickupSM'
    DrawScale=0.5
}
