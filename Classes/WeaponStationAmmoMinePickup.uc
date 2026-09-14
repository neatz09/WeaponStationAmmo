class WeaponStationAmmoMinePickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=ONSWeapons-SM.usx

defaultproperties
{
    InventoryType=class'ONSMineLayer'
    PickupMessage="You got the Mine Layer."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'ONSWeapons-SM.MineLayerPickup'
    DrawScale=0.3
}
