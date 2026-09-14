class MutWeaponStationAmmo extends Mutator
    config (WeaponStationAmmo);

var() config float PerPawnCooldown;
var() config int AssaultRifleSecondaryAmmo;
var() config int BioRifleSecondaryAmmo;
var() config int ShockRifleSecondaryAmmo;
var() config int LinkGunSecondaryAmmo;
var() config int MinigunSecondaryAmmo;
var() config int FlakCannonSecondaryAmmo;
var() config int RocketLauncherSecondaryAmmo;
var() config int LightningGunSecondaryAmmo;
var() config int AvrilSecondaryAmmo;
var() config int ONSGrenadeLauncherSecondaryAmmo;
var() config int ONSMineLayerSecondaryAmmo;
var() config int ClassicSniperRifleSecondaryAmmo;

function PostBeginPlay()
{
    local WeaponStationAmmoRules Rules;

    Super.PostBeginPlay();
    StaticSaveConfig();
    AddToPackageMap("WeaponStaticMesh");
    AddToPackageMap("NewWeaponPickups");
    AddToPackageMap("ONSWeapons-SM");
    AddToPackageMap("VMWeaponsSM");
    AddToPackageMap("NewWeaponStatic");
    SetTimer(0.100000, false);

    if (PerPawnCooldown > 0.0)
    {
        Rules = Spawn(class'WeaponStationAmmoRules');
        if (Rules != None)
        {
            Rules.CooldownSeconds = PerPawnCooldown;
            Rules.AssaultRifleSecondaryAmmo = AssaultRifleSecondaryAmmo;
            Rules.BioRifleSecondaryAmmo = BioRifleSecondaryAmmo;
            Rules.ShockRifleSecondaryAmmo = ShockRifleSecondaryAmmo;
            Rules.LinkGunSecondaryAmmo = LinkGunSecondaryAmmo;
            Rules.MinigunSecondaryAmmo = MinigunSecondaryAmmo;
            Rules.FlakCannonSecondaryAmmo = FlakCannonSecondaryAmmo;
            Rules.RocketLauncherSecondaryAmmo = RocketLauncherSecondaryAmmo;
            Rules.LightningGunSecondaryAmmo = LightningGunSecondaryAmmo;
            Rules.AvrilSecondaryAmmo = AvrilSecondaryAmmo;
            Rules.ONSGrenadeLauncherSecondaryAmmo = ONSGrenadeLauncherSecondaryAmmo;
            Rules.ONSMineLayerSecondaryAmmo = ONSMineLayerSecondaryAmmo;
            Rules.ClassicSniperRifleSecondaryAmmo = ClassicSniperRifleSecondaryAmmo;
            if (Level.Game.GameRulesModifiers == None)
                Level.Game.GameRulesModifiers = Rules;
            else
                Level.Game.GameRulesModifiers.AddGameRules(Rules);
        }
    }
}

function Timer()
{
    local WeaponPickup WeaponItem;

    ForEach AllActors(class'WeaponPickup', WeaponItem)
        if (WeaponItem.PickupBase != None && !WeaponItem.bDropped
            && !IsStockGlobalWeapon(WeaponItem)
            && WeaponStationAmmoPickup(WeaponItem) == None)
            ReplaceWeaponPickup(WeaponItem);
}

function bool IsStockGlobalWeapon(WeaponPickup WeaponItem)
{
    return WeaponItem.InventoryType != None
        && (WeaponItem.InventoryType.Name == 'Painter'
            || WeaponItem.InventoryType.Name == 'Redeemer');
}

function class<WeaponStationAmmoPickup> GetReplacementClass(WeaponPickup WeaponItem)
{
    if (WeaponItem.InventoryType == None)
        return class'WeaponStationAmmoPickup';

    switch (WeaponItem.InventoryType.Name)
    {
        case 'AssaultRifle': return class'WeaponStationAmmoAssaultPickup';
        case 'BioRifle': return class'WeaponStationAmmoBioPickup';
        case 'ShockRifle': return class'WeaponStationAmmoShockPickup';
        case 'LinkGun': return class'WeaponStationAmmoLinkPickup';
        case 'Minigun': return class'WeaponStationAmmoMinigunPickup';
        case 'FlakCannon': return class'WeaponStationAmmoFlakPickup';
        case 'RocketLauncher': return class'WeaponStationAmmoRocketPickup';
        case 'SniperRifle': return class'WeaponStationAmmoSniperPickup';
        case 'ONSAVRiL': return class'WeaponStationAmmoAvrilPickup';
        case 'ONSGrenadeLauncher': return class'WeaponStationAmmoGrenadePickup';
        case 'ONSMineLayer': return class'WeaponStationAmmoMinePickup';
        case 'ClassicSniperRifle': return class'WeaponStationAmmoClassicSniperPickup';
    }

    return class'WeaponStationAmmoPickup';
}

function bool ReplaceWeaponPickup(WeaponPickup WeaponItem)
{
    local WeaponStationAmmoPickup Replacement;
    local class<WeaponStationAmmoPickup> ReplacementClass;

    ReplacementClass = GetReplacementClass(WeaponItem);
    Replacement = Spawn(ReplacementClass, WeaponItem.Owner,
        WeaponItem.Tag, WeaponItem.Location, WeaponItem.Rotation);
    if (Replacement == None)
        return false;

    Replacement.InventoryType = WeaponItem.InventoryType;
    Replacement.AmmoAmount[0] = WeaponItem.AmmoAmount[0];
    Replacement.AmmoAmount[1] = WeaponItem.AmmoAmount[1];
    Replacement.RespawnTime = WeaponItem.RespawnTime;
    Replacement.bThrown = WeaponItem.bThrown;
    Replacement.bInstantRespawn = WeaponItem.bInstantRespawn;
    Replacement.bPredictRespawns = WeaponItem.bPredictRespawns;
    Replacement.bAmbientGlow = WeaponItem.bAmbientGlow;
    Replacement.PickupMessage = WeaponItem.PickupMessage;
    Replacement.PickupSound = WeaponItem.PickupSound;
    Replacement.PickupForce = WeaponItem.PickupForce;
    Replacement.bWeaponStay = true;
    Replacement.MaxDesireability = WeaponItem.MaxDesireability;
    Replacement.SetDrawScale(WeaponItem.DrawScale);
    Replacement.SetDrawScale3D(WeaponItem.DrawScale3D);
    Replacement.Texture = WeaponItem.Texture;
    Replacement.Style = WeaponItem.Style;
    Replacement.AmbientGlow = WeaponItem.AmbientGlow;
    Replacement.CullDistance = WeaponItem.CullDistance;
    Replacement.SetCollisionSize(WeaponItem.CollisionRadius,
        WeaponItem.CollisionHeight);
    Replacement.SetDrawType(WeaponItem.DrawType);
    if (WeaponItem.DrawType == DT_StaticMesh)
        Replacement.SetStaticMesh(WeaponItem.StaticMesh);
    Replacement.ReplicatedPickupClass = WeaponItem.Class;

    Replacement.InitializeReplacement();

    Replacement.PickupBase = WeaponItem.PickupBase;
    if (WeaponItem.MyMarker != None)
    {
        Replacement.MyMarker = WeaponItem.MyMarker;
        Replacement.MyMarker.markedItem = Replacement;
        WeaponItem.MyMarker = None;
    }
    Replacement.Event = WeaponItem.Event;
    Replacement.Tag = WeaponItem.Tag;
    WeaponItem.SetCollision(false, false, false);
    WeaponItem.bHidden = true;
    WeaponItem.Destroy();
    return true;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    local WeaponPickup WeaponItem;

    WeaponItem = WeaponPickup(Other);
    if (WeaponItem != None && WeaponItem.PickupBase != None
        && !WeaponItem.bDropped && !IsStockGlobalWeapon(WeaponItem)
        && WeaponStationAmmoPickup(Other) == None)
        bSuperRelevant = 1;

    return true;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
    Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting(default.RulesGroup, "PerPawnCooldown",
        "Per-Pawn Cooldown Seconds", 0, 1, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "AssaultRifleSecondaryAmmo",
        "Assault Rifle Secondary Ammo", 0, 2, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "BioRifleSecondaryAmmo",
        "Bio Rifle Secondary Ammo", 0, 3, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "ShockRifleSecondaryAmmo",
        "Shock Rifle Secondary Ammo", 0, 4, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "LinkGunSecondaryAmmo",
        "Link Gun Secondary Ammo", 0, 5, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "MinigunSecondaryAmmo",
        "Minigun Secondary Ammo", 0, 6, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "FlakCannonSecondaryAmmo",
        "Flak Cannon Secondary Ammo", 0, 7, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "RocketLauncherSecondaryAmmo",
        "Rocket Launcher Secondary Ammo", 0, 8, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "LightningGunSecondaryAmmo",
        "Lightning Gun Secondary Ammo", 0, 9, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "AvrilSecondaryAmmo",
        "AVRiL Secondary Ammo", 0, 10, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "ONSGrenadeLauncherSecondaryAmmo",
        "ONS Grenade Launcher Secondary Ammo", 0, 11, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "ONSMineLayerSecondaryAmmo",
        "ONS Mine Layer Secondary Ammo", 0, 12, "Text");
    PlayInfo.AddSetting(default.RulesGroup, "ClassicSniperRifleSecondaryAmmo",
        "Classic Sniper Rifle Secondary Ammo", 0, 13, "Text");
}

static event string GetDescriptionText(string PropName)
{
    switch (PropName)
    {
        case "PerPawnCooldown":
            return "Seconds before the same pawn can collect this weapon station again.";
        case "AssaultRifleSecondaryAmmo":
            return "Grenade ammo granted when the player already owns the Assault Rifle.";
        case "BioRifleSecondaryAmmo":
            return "Ammo granted when the player already owns the Bio Rifle.";
        case "ShockRifleSecondaryAmmo":
            return "Ammo granted when the player already owns the Shock Rifle.";
        case "LinkGunSecondaryAmmo":
            return "Ammo granted when the player already owns the Link Gun.";
        case "MinigunSecondaryAmmo":
            return "Ammo granted when the player already owns the Minigun.";
        case "FlakCannonSecondaryAmmo":
            return "Ammo granted when the player already owns the Flak Cannon.";
        case "RocketLauncherSecondaryAmmo":
            return "Ammo granted when the player already owns the Rocket Launcher.";
        case "LightningGunSecondaryAmmo":
            return "Ammo granted when the player already owns the Lightning Gun.";
        case "AvrilSecondaryAmmo":
            return "Ammo granted when the player already owns the AVRiL.";
        case "ONSGrenadeLauncherSecondaryAmmo":
            return "Ammo granted when the player already owns the ONS Grenade Launcher.";
        case "ONSMineLayerSecondaryAmmo":
            return "Ammo granted when the player already owns the ONS Mine Layer.";
        case "ClassicSniperRifleSecondaryAmmo":
            return "Ammo granted when the player already owns the Classic Sniper Rifle.";
    }

    return Super.GetDescriptionText(PropName);
}

defaultproperties
{
    bAddToServerPackages=True
    PerPawnCooldown=30.000000
    AssaultRifleSecondaryAmmo=4
    BioRifleSecondaryAmmo=20
    ShockRifleSecondaryAmmo=10
    LinkGunSecondaryAmmo=50
    MinigunSecondaryAmmo=50
    FlakCannonSecondaryAmmo=10
    RocketLauncherSecondaryAmmo=9
    LightningGunSecondaryAmmo=10
    AvrilSecondaryAmmo=5
    ONSGrenadeLauncherSecondaryAmmo=5
    ONSMineLayerSecondaryAmmo=8
    ClassicSniperRifleSecondaryAmmo=10
    GroupName="WeaponStationAmmo"
    FriendlyName="Weapon Station Ammo"
    Description="Adjusts weapon station ammunition behavior."
    IconMaterialName="MutatorArt.nosym"
}
