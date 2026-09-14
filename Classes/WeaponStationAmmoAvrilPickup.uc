class WeaponStationAmmoAvrilPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=VMWeaponsSM.usx

defaultproperties
{
    InventoryType=class'ONSAVRiL'
    PickupMessage="You got the AVRiL."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'VMWeaponsSM.AVRiLsm'
    DrawScale=0.05
}
