class WeaponStationAmmoRocketPickup extends WeaponStationAmmoPickup;

#exec OBJ LOAD FILE=WeaponStaticMesh.usx

defaultproperties
{
    InventoryType=class'RocketLauncher'
    PickupMessage="You got the Rocket Launcher."
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.RocketLauncherPickup'
    DrawScale=0.45
}
