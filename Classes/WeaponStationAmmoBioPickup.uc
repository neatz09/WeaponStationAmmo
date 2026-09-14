class WeaponStationAmmoBioPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=WeaponStaticMesh.usx

defaultproperties
{
    InventoryType=class'BioRifle'
    PickupMessage="You got the Bio-Rifle"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.BioRiflePickup'
    DrawScale=0.6
}
