class WeaponStationAmmoGrenadePickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=ONSWeapons-SM.usx

defaultproperties
{
    InventoryType=class'ONSGrenadeLauncher'
    PickupMessage="You got the Grenade Launcher."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'ONSWeapons-SM.GrenadeLauncherPickup'
    DrawScale=0.25
}
