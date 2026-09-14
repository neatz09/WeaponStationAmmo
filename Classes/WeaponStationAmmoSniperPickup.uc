class WeaponStationAmmoSniperPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=WeaponStaticMesh.usx

defaultproperties
{
    InventoryType=class'SniperRifle'
    PickupMessage="You got the Lightning Gun."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.SniperRiflePickup'
    DrawScale=0.45
}
