class WeaponStationAmmoPickup extends UTWeaponPickup;

#exec OBJ LOAD FILE=..\StaticMeshes\WeaponStaticMesh.usx
#exec OBJ LOAD FILE=..\StaticMeshes\NewWeaponPickups.usx
#exec OBJ LOAD FILE=..\StaticMeshes\ONSWeapons-SM.usx
#exec OBJ LOAD FILE=..\StaticMeshes\VMWeaponsSM.usx
#exec OBJ LOAD FILE=..\StaticMeshes\NewWeaponStatic.usx

var bool bHiddenForOwner;
var EDrawType SavedDrawType;
var bool bSavedDrawType;
var EDrawType ReplicatedPickupDrawType;
var StaticMesh ReplicatedPickupStaticMesh;
var byte ReplicatedVisualType;
var class<WeaponPickup> ReplicatedPickupClass;
var bool bPickupVisualApplied;

function PostBeginPlay()
{
}

function InitializeReplacement()
{
    Super.PostBeginPlay();
    bWeaponStay = true;
    ReplicatedPickupDrawType = DrawType;
    ReplicatedPickupStaticMesh = StaticMesh;
    ReplicatedVisualType = GetVisualType();
    NetUpdateTime = Level.TimeSeconds - 1.0;
}

function byte GetVisualType()
{
    switch (InventoryType.Name)
    {
        case 'AssaultRifle': return 1;
        case 'BioRifle': return 2;
        case 'ShockRifle': return 3;
        case 'LinkGun': return 4;
        case 'Minigun': return 5;
        case 'FlakCannon': return 6;
        case 'RocketLauncher': return 7;
        case 'SniperRifle': return 8;
        case 'ONSAVRiL': return 9;
        case 'ONSGrenadeLauncher': return 10;
        case 'ONSMineLayer': return 11;
        case 'ClassicSniperRifle': return 12;
    }

    return 0;
}

replication
{
    reliable if (Role == ROLE_Authority && bNetOwner)
        bHiddenForOwner;
    reliable if (Role == ROLE_Authority)
        ReplicatedPickupDrawType, ReplicatedPickupStaticMesh, ReplicatedVisualType,
        ReplicatedPickupClass;
}

simulated function ApplyReplicatedPickupVisuals()
{
    if (ReplicatedVisualType > 0)
    {
        SetDrawType(DT_StaticMesh);
        switch (ReplicatedVisualType)
        {
            case 1: SetStaticMesh(class'AssaultRiflePickup'.default.StaticMesh); break;
            case 2: SetStaticMesh(class'BioRiflePickup'.default.StaticMesh); break;
            case 3: SetStaticMesh(class'ShockRiflePickup'.default.StaticMesh); break;
            case 4: SetStaticMesh(class'LinkGunPickup'.default.StaticMesh); break;
            case 5: SetStaticMesh(class'MinigunPickup'.default.StaticMesh); break;
            case 6: SetStaticMesh(class'FlakCannonPickup'.default.StaticMesh); break;
            case 7: SetStaticMesh(class'RocketLauncherPickup'.default.StaticMesh); break;
            case 8: SetStaticMesh(class'SniperRiflePickup'.default.StaticMesh); break;
            case 9: SetStaticMesh(class'ONSAVRiLPickup'.default.StaticMesh); break;
            case 10: SetStaticMesh(class'ONSGrenadePickup'.default.StaticMesh); break;
            case 11: SetStaticMesh(class'ONSMineLayerPickup'.default.StaticMesh); break;
            case 12: SetStaticMesh(class'ClassicSniperRiflePickup'.default.StaticMesh); break;
        }
        bPickupVisualApplied = (StaticMesh != None);
    }
    else if (ReplicatedPickupClass != None
        && ReplicatedPickupClass.default.StaticMesh != None)
    {
        SetDrawType(ReplicatedPickupClass.default.DrawType);
        SetStaticMesh(ReplicatedPickupClass.default.StaticMesh);
        bPickupVisualApplied = true;
    }
    else if (ReplicatedPickupStaticMesh != None)
    {
        SetDrawType(ReplicatedPickupDrawType);
        SetStaticMesh(ReplicatedPickupStaticMesh);
        bPickupVisualApplied = true;
    }
}

simulated function UpdateOwnerVisibility()
{
    local PlayerController LocalPlayer;

    if (Level.NetMode == NM_DedicatedServer)
        return;

    LocalPlayer = Level.GetLocalPlayerController();
    if (bHiddenForOwner && LocalPlayer != None
        && (Owner == LocalPlayer || Owner == LocalPlayer.Pawn))
    {
        if (!bSavedDrawType)
        {
            SavedDrawType = DrawType;
            bSavedDrawType = true;
        }
        SetDrawType(DT_None);
    }
    else if (bSavedDrawType)
    {
        SetDrawType(SavedDrawType);
        bSavedDrawType = false;
    }
}

simulated event PostNetReceive()
{
    Super.PostNetReceive();
    ApplyReplicatedPickupVisuals();
    UpdateOwnerVisibility();
}

simulated event Tick(float DeltaTime)
{
    if (Level.NetMode != NM_DedicatedServer
        && !bHiddenForOwner && !bSavedDrawType
        && (!bPickupVisualApplied || DrawType != DT_StaticMesh
            || StaticMesh == None))
    {
        ApplyReplicatedPickupVisuals();
    }
    if (bHiddenForOwner || bSavedDrawType)
        UpdateOwnerVisibility();
}

function HideForPawn(Pawn Other)
{
    if (Other.Controller != None)
        SetOwner(Other.Controller);
    else
        SetOwner(Other);
    bHiddenForOwner = true;
    NetUpdateTime = Level.TimeSeconds - 1.0;
}

function RestoreForOwner()
{
    bHiddenForOwner = false;
    SetOwner(None);
    NetUpdateTime = Level.TimeSeconds - 1.0;
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bOnlyRelevantToOwner=False
    bAlwaysRelevant=True
    bAlwaysTick=True
    bNetNotify=True
}
