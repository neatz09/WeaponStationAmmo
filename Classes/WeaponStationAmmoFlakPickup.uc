class WeaponStationAmmoFlakPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=WeaponStaticMesh.usx

defaultproperties
{
    InventoryType=class'FlakCannon'
    PickupMessage="You got the Flak Cannon."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.FlakCannonPickup'
    DrawScale=0.55
}
