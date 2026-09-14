class WeaponStationAmmoMinigunPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=WeaponStaticMesh.usx

defaultproperties
{
    InventoryType=class'Minigun'
    PickupMessage="You got the Minigun."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.MinigunPickup'
    DrawScale=0.5
}
