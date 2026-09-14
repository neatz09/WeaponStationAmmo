class WeaponStationAmmoRules extends GameRules;

struct WeaponCooldown
{
    var WeaponPickup Pickup;
    var Pawn Pawn;
    var float UnlockTime;
};

var float CooldownSeconds;
var int AssaultRifleSecondaryAmmo;
var int BioRifleSecondaryAmmo;
var int ShockRifleSecondaryAmmo;
var int LinkGunSecondaryAmmo;
var int MinigunSecondaryAmmo;
var int FlakCannonSecondaryAmmo;
var int RocketLauncherSecondaryAmmo;
var int LightningGunSecondaryAmmo;
var int AvrilSecondaryAmmo;
var int ONSGrenadeLauncherSecondaryAmmo;
var int ONSMineLayerSecondaryAmmo;
var int ClassicSniperRifleSecondaryAmmo;
var array<WeaponCooldown> Cooldowns;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(0.250000, true);
}

function int FindCooldown(Pawn Other, WeaponPickup Item)
{
    local int i;

    for (i = 0; i < Cooldowns.Length; i++)
        if (Cooldowns[i].Pawn == Other && Cooldowns[i].Pickup == Item)
            return i;

    return -1;
}

function AddCooldown(Pawn Other, WeaponPickup Item)
{
    local int Index;
    local WeaponStationAmmoPickup StationItem;

    Index = FindCooldown(Other, Item);
    if (Index < 0)
    {
        Index = Cooldowns.Length;
        Cooldowns.Length = Index + 1;
        Cooldowns[Index].Pawn = Other;
        Cooldowns[Index].Pickup = Item;

    }

    Cooldowns[Index].UnlockTime = Level.TimeSeconds + CooldownSeconds;
    StationItem = WeaponStationAmmoPickup(Item);
    if (StationItem != None)
        StationItem.HideForPawn(Other);
}

function Timer()
{
    local int i;
    local WeaponStationAmmoPickup StationItem;

    for (i = Cooldowns.Length - 1; i >= 0; i--)
        if (Level.TimeSeconds >= Cooldowns[i].UnlockTime)
        {
            StationItem = WeaponStationAmmoPickup(Cooldowns[i].Pickup);
            if (StationItem != None)
                StationItem.RestoreForOwner();
            Cooldowns.Remove(i, 1);
        }
}

function SetAmmoPickupAmounts(WeaponPickup WeaponItem, Weapon ExistingWeapon)
{
    local int i;
    local int ConfiguredAmount;
    local class<Ammo> AmmoPickupClass;

    ConfiguredAmount = -1;
    switch (WeaponItem.InventoryType.Name)
    {
        case 'AssaultRifle': ConfiguredAmount = AssaultRifleSecondaryAmmo; break;
        case 'BioRifle': ConfiguredAmount = BioRifleSecondaryAmmo; break;
        case 'ShockRifle': ConfiguredAmount = ShockRifleSecondaryAmmo; break;
        case 'LinkGun': ConfiguredAmount = LinkGunSecondaryAmmo; break;
        case 'Minigun': ConfiguredAmount = MinigunSecondaryAmmo; break;
        case 'FlakCannon': ConfiguredAmount = FlakCannonSecondaryAmmo; break;
        case 'RocketLauncher': ConfiguredAmount = RocketLauncherSecondaryAmmo; break;
        case 'SniperRifle': ConfiguredAmount = LightningGunSecondaryAmmo; break;
        case 'ONSAVRiL': ConfiguredAmount = AvrilSecondaryAmmo; break;
        case 'ONSGrenadeLauncher': ConfiguredAmount = ONSGrenadeLauncherSecondaryAmmo; break;
        case 'ONSMineLayer': ConfiguredAmount = ONSMineLayerSecondaryAmmo; break;
        case 'ClassicSniperRifle': ConfiguredAmount = ClassicSniperRifleSecondaryAmmo; break;
    }

    for (i = 0; i < 2; i++)
    {
        AmmoPickupClass = class<Ammo>(ExistingWeapon.AmmoPickupClass(i));
        if (AmmoPickupClass != None)
        {
            if (i == 1 && ConfiguredAmount >= 0)
                WeaponItem.AmmoAmount[i] = ConfiguredAmount;
            else
                WeaponItem.AmmoAmount[i] = AmmoPickupClass.default.AmmoAmount;
        }
    }
}

function bool OverridePickupQuery(Pawn Other, Pickup Item, out byte bAllowPickup)
{
    local WeaponPickup WeaponItem;
    local int Index;
    local Weapon ExistingWeapon;

    WeaponItem = WeaponPickup(Item);
    if (WeaponItem == None || WeaponItem.PickupBase == None)
        return Super.OverridePickupQuery(Other, Item, bAllowPickup);

    Index = FindCooldown(Other, WeaponItem);
    if (Index >= 0)
    {
        if (Level.TimeSeconds < Cooldowns[Index].UnlockTime)
        {
            bAllowPickup = 0;
            return true;
        }

        WeaponStationAmmoPickup(WeaponItem).RestoreForOwner();
        Cooldowns.Remove(Index, 1);
    }

    ExistingWeapon = Weapon(Other.FindInventoryType(WeaponItem.InventoryType));
    if (ExistingWeapon != None)
    {
        SetAmmoPickupAmounts(WeaponItem, ExistingWeapon);
        AddCooldown(Other, WeaponItem);
        bAllowPickup = 1;
        return true;
    }

    if (ExistingWeapon == None)
        AddCooldown(Other, WeaponItem);

    return Super.OverridePickupQuery(Other, Item, bAllowPickup);
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    local int i;

    for (i = Cooldowns.Length - 1; i >= 0; i--)
        if (Cooldowns[i].Pawn == Killed)
        {
            WeaponStationAmmoPickup(Cooldowns[i].Pickup).RestoreForOwner();
            Cooldowns.Remove(i, 1);
        }

    return Super.PreventDeath(Killed, Killer, DamageType, HitLocation);
}
