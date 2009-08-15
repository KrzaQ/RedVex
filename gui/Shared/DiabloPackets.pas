unit DiabloPackets;

interface

uses RedVexTypes, Classes;

type
TPlayerInformationType = (pitDroppedFromGame, pitJoinedGame, pitLeftGame,
  pitNotInGame, pitPlayerSlain, pitPlayerRelation);
TPlayerRelationActionType = (pratUnknown1, pratUnknown2, pratAllowLoot,
  pratHostile,	pratUnhostile, pratInvitedYou, pratCanceledInvite,
  pratJoinedParty, pratJoinedYourParty, pratLeftParty, pratUnknown3,
  pratCanceledLootPermission);

TUnitType = (utPlayer, utNPC, utGameObject, utMissile, utItem,
  utWarp, utInvalid);

TItemActionType = (iatAddToGround, iatGroundToCursor, iatDropToGround,
  iatOnGround, iatPutInContainer, iatRemoveFromContainer, iatEquip,
  iatIndirectlySwapBodyItem, iatUnequip, iatSwapBodyItem, iatAddQuantity,
  iatAddToShop, iatRemoveFromShop, iatSwapInContainer, iatPutInBelt,
  iatRemoveFromBelt, iatSwapInBelt, iatAutoUnequip, iatRemoveFromHireling,
  iatItemInSocket, iatUNKNOWN1, iatUpdateStats, iatUNKNOWN2, iatWeaponSwitch);

TCharacterClass = (ccAmazon, ccSorceress, ccNecromancer, ccPaladin, ccBarbarian,
  ccDruid, ccAssassin);

TGameMessageType = (gmtUnused01, gmtGameMessage, gmtGameWhisper, gmtUnused02,
  gmtUnused03, gmtOverheadMessage, gmtGameWhisperReceipt);


const

//Item Version
ItemVersionClassic	= 2;
ItemVersionLoD			= $65;


//Realm
//From Client
R2C_CreateGameRequest = $03;
R2C_JoinGameRequest = $04;
R2C_GameListRequest = $05;
//From Server
R2S_CreateGame = $03;
R2S_JoinGame = $04;
R2S_GameList = $05;
R2S_GameInfo = $06;
//EndRealm



// From Client
D2C_WALK = $01;
D2C_WalkToObject = $02;
D2C_RUN = $03;
D2C_RunToObject = $04;
D2C_CHAT = $15;
D2C_PICKITEM = $16;
D2C_GAME_LOGON = $68;
D2C_UPDATEPOS = $5F;
D2C_PING = $6D;
D2C_DOITEMDROP = $17;

D2C_WaypointInteract = $49;
D2C_UnitInteract = $13;

D2C_SELECTSKILL = $3c;

D2C_USERIGHT = $0C;

D2C_EXITGAME = $69;

D2C_GoToTownFolk = $59;
D2C_TownFolkInteract = $2F;

D2C_TownFolkCancelInteract = $30;


// From Server

D2S_Chat = $26;

D2S_GameObjectAssignment = $51;

D2S_GameQuestLog = $29;


D2S_OpenWaypoint = $63;
D2S_LoadAct = $03;
D2S_MAPADD				= $07;
D2S_MAPREMOVE				= $08;
D2S_NPCAssignment = $AC;

D2S_QuestUpdate = $29;

D2S_NPCMove = $67;
D2S_NPCStop = $6D;


D2S_PortalInfo = $60;

D2S_PlayerLifeManaChange = $95;
D2S_PlayerInfomation = $5a;

D2S_PlayerMove = $0F;
D2S_REASSIGN = $15;

D2S_UPDATESKILL				= $21;
D2S_SKILLSLOG				= $94;
D2S_ASSIGNSKILL = $23;

D2S_NEWPLAYER = $59;

D2S_ITEMACTION = $9c;
D2S_OWNEDITEMACTION = $9D;
D2S_INVENTORYFULL = $2c;

D2S_PLAYERJOIN = $5B;
D2S_WALKVERIFY = $96;
D2S_REMOVEGROUND = $0a;
D2S_PONG = $8F;
D2S_TRIGGERSOUND = $2c;

D2S_ATTRIBUTEBYTE = $1D;
D2S_ATTRIBUTEWORD = $1E;
D2S_ATTRIBUTEDWORD = $1F;

D2S_GAMEOVER = $B0;
D2S_UnloadDone = $05;
D2S_GameLogoutSuccess = $06;

//Sounds
ts_InvFull = 23;  

//### Skills ###

//Sorceress
sk_Teleport = $36;
sk_FrozenArmor = $28;
sk_ShiverArmor = $32;
sk_ChillingArmor = $3C;
sk_EnergiShield = $3A;

sk_Blizzard = $3B;

//Paladin
sk_HolyShield = $75;

//Assasin
sk_BurstofSpeed = $0102;
sk_Fade = $010B;
sk_Venom = $0116;

//Neromancer
sk_BoneArmor = $44;

//Barbarian
sk_Shout = $8A;
sk_BattleOrders = $95;
sk_BattleCommand = $9B;

//Amazon
sk_Valkyrie = $20;

sk_LightningFury = $23;

//Other
sk_TownPortal = $DC;

//AreaLevels
al_RogueEncampment = 1;
al_LutGholein = 40;
al_KurastDocks = $4b;
al_PandemoniumFortress = $67;
al_Harrogath = $6d;



type

TStatType =( stStrength,
      stEnergy,
      stDexterity,
      stVitality,
      stStatPoints,
      stSkillPoints,
      stLife,
      stMaxLife,
      stMana,
      stMaxMana,
      stStamina,
      stMaxStamina,
      stLevel,
      stExperience,
      stGold,
      stGoldBank,
      stDefensePercent,
      stMaxDamagePercent,
      stMinDamagePercent,
      stToHit,
      stToBlock,
      stMinDamage,
      stMaxDamage,
      stSecondaryMinDamage,
      stSecondaryMaxDamage,
      stDamagePercent,
      stManaRecovery,
      stManaRecoveryBonus,
      stStaminaRecoveryBonus,
      stLastExperience,
      stNextExperience,
      stArmorClass,
      stArmorClassVsMissile,
      stArmorClassVsMelee,
      stDamageReduction,
      stMagicDamageReduction,
      stDamageResist,
      stMagicResist,
      stMaxMagicResist,
      stFireResist,
      stMaxFireResist,
      stLightResist,
      stMaxLightResist,
      stColdResist,
      stMaxColdResist,
      stPoisonResist,
      stMaxPoisonResist,
      stDamageAura,
      stFireMinDamage,
      stFireMaxDamage,
      stLightMinDamage,
      stLightMaxDamage,
      stMagicMinDamage,
      stMagicMaxDamage,
      stColdMinDamage,
      stColdMaxDamage,
      stColdLength,
      stPoisonMinDamage,
      stPoisonMaxDamage,
      stPoisonLength,
      stLifeDrainMinDamage,
      stLifeDrainMaxDamage,
      stManaDrainMinDamage,
      stManaDrainMaxDamage,
      stStamDrainMinDamage,
      stStamDrainMaxDamage,
      stStunLength,
      stVelocityPercent,
      stAttackRate,
      stOtherAnimRate,
      stQuantity,
      stValue,
      stDurability,
      stMaxDurability,
      stLifeRegen,
      stMaxDurabilityPercent,
      stMaxLifePercent,
      stMaxManaPercent,
      stAttackerTakesDamage,
      stGoldFind,
      stMagicFind,
      stKnockback,
      stTimeDuration,
      stClassSkillsBonus,
      stUnsentParam1,
      stAddExperience,
      stHealAfterKill,
      stReducedPrices,
      stDoubleHerbDuration,
      stLightRadius,
      stLightColor,
      stLowerRequirementsPercent,
      stLowerLevelRequirement,
      stFasterAttackRate,
      stLowerLevelRequirementPercent,
      stLastBlockFrame,
      stFasterMoveVelocity,
      stNonClassSkill,
      stState,
      stFasterHitRecovery,
      stMonsterPlayerCount,
      stSkillPoisonOverrideLength,
      stFasterBlockRate,
      stSkillBypassUndead,
      stSkillBypassDemons,
      stFasterCastRate,
      stSkillBypassBeasts,
      stSingleSkill,
      stRestInPeace,
      stCurseResistance,
      stPoisonLengthReduction,
      stNormalDamage,
      stHowl,
      stHitBlindsTarget,
      stDamageToMana,
      stIgnoreTargetDefense,
      stFractionalTargetAC,
      stPreventHeal,
      stHalffReezeDuration,
      stToHitPercent,
      stDamageTargetAC,
      stDemonDamagePercent,
      stUndeadDamagepercent,
      stDemonToHit,
      stUndeadToHit,
      stThrowable,
      stElementalSkillBonus,
      stAllSkillsBonus,
      stAttackerTakesLightingDamage,
      stIronMaidenLevel,
      stLifeTapLevel,
      stThornsPercent,
      stBoneArmor,
      stBoneArmorMax,
      stFreeze,
      stOpenWounds,
      stCrushingBlow,
      stKickDamage,
      stManaAfterKill,
      stHealAfterDemonKill,
      stExtraBlood,
      stDeadlyStrike,
      stAbsorbFirePercent,
      stAbsorbFire,
      stAbsorbLightingPercent,
      stAbsorbLight,
      stAbsorbMagicPercent,
      stAbsorbMagic,
      stAbsorbColdPercent,
      stAbsorbCold,
      stSlow,
      stAura,
      stIndesctructible,
      stCannotBeFrozen,
      stStaminaDrainPercent,
      stReanimate,
      stPierce,
      stMagicArrow,
      stExplosiveArrow,
      stThrowMinDamage,
      stThrowMaxDamage,
      stSkillHandOfAthena,
      stSkillStaminaPercent,
      stSkillPassiveStaminaPercent,
      stSkillConcentration,
      stSkillEnchant,
      stSkillPierce,
      stSkillConviction,
      stSkillChillingArmor,
      stSkillFrenzy,
      stSkillDecrepify,
      stSkillArmorPercent,
      stAlignment,
      stTarget0,
      stTarget1,
      stGoldLost,
      stConversionLevel,
      stConversionMaxHP,
      stUnitDoOverlay,
      stAttackVsMonsterType,
      stDamageVsMonsterType,
      stFade,
      stArmorOverridePercent,
      stUnused183,
      stUnused184,
      stUnused185,
      stUnused186,
      stUnused187,
      stSkillTabBonus,
      stUnused189,
      stUnused190,
      stUnused191,
      stUnused192,
      stUnused193,
      stSockets,
      stSkillOnAttack,
      stSkillOnKill,
      stSkillOnDeath,
      stSkillOnStriking,
      stSkillOnLevelUp,
      stUnused200,
      stSkillOnGetHit,
      stUnused202,
      stUnused203,
      stChargedSkill,
      stUnused204,
      stUnused205,
      stUnused206,
      stUnused207,
      stUnused208,
      stUnused209,
      stUnused210,
      stUnused211,
      stUnused212,
      stArmorPerLevel,
      stArmorPercentPerLevel,
      stLifePerLevel,
      stManaPerLevel,
      stMaxDamagePerLevel,
      stMaxDamagePercentPerLevel,
      stStrengthPerLevel,
      stDexterityPerLevel,
      stEnergyPerLevel,
      stVitalityPerLevel,
      stToHitPerLevel,
      stToHitPercentPerLevel,
      stColdDamageMaxPerLevel,
      stFireDamageMaxPerLevel,
      stLightningDamageMaxPerLevel,
      stPoisonDamageMaxPerLevel,
      stResistColdPerLevel,
      stResistFirePerLevel,
      stResistLightningPerLevel,
      stResistPoisonPerLevel,
      stAbsorbColdPerLevel,
      stAbsorbFirePerLevel,
      stAbsorbLightningPerLevel,
      stAbsorbPoisonPerLevel,
      stThornsPerLevel,
      stGoldFindPerLevel,
      stMagicFindPerLevel,
      stRegenStaminaPerLevel,
      stStaminaPerLevel,
      stDamageDemonPerLevel,
      stDamageUndeadPerLevel,
      stToHitDemonPerLevel,
      stToHitUndeadPerLevel,
      stCrushingBlowPerLevel,
      stOpenWoundsPerLevel,
      stKickDamagePerLevel,
      stDeadlyStrikePerLevel,
      stFindGemsPerLevel,
      stReplenishDurability,
      stReplenishQuantity,
      stExtraStack,
      stFindItem,
      stSlashDamage,
      stSlashDamagePercent,
      stCrushDamage,
      stCrushDamagePercent,
      stThrustDamage,
      stThrustDamagePercent,
      stAbsorbSlash,
      stAbsorbCrush,
      stAbsorbThrust,
      stAbsorbSlashPercent,
      stAbsorbCrushPercent,
      stAbsorbThrustPercent,
      stArmorByTime,
      stArmorPercentByTime,
      stLifeByTime,
      stManaByTime,
      stMaxDamageByTime,
      stMaxDamagePercentByTime,
      stStrengthByTime,
      stDexterityByTime,
      stEnergyByTime,
      stVitalityByTime,
      stToHitByTime,
      stToHitPercentByTime,
      stColdMaxDamageByTime,
      stFireMaxDamageByTime,
      stLightningMaxDamageByTime,
      stPoisonMaxDamageByTime,
      stResistColdByTime,
      stResistFireByTime,
      stResistLightningByTime,
      stResistPoisonByTime,
      stAbsorbColdByTime,
      stAbsorbFireByTime,
      stAbsorbLightningByTime,
      stAbsorbPoisonByTime,
      stFindGoldByTime,
      stFindMagicByTime,
      stRegenStaminaByTime,
      stStaminaByTime,
      stDamageDemonByTime,
      stDamageUndeadByTime,
      stToHitDemonByTime,
      stToHitUndeadByTime,
      stCrushingBlowByTime,
      stOpenWoundsByTime,
      stKickDamageByTime,
      stDeadlyStrikeByTime,
      stFindGemsByTime,
      stPierceCold,
      stPierceFire,
      stPierceLightning,
      stPiercePoison,
      stDamageVsMonster,
      stDamagePercentVsMonster,
      stToHitVsMonster,
      stToHitPercentVsMonster,
      stDefenseVsMonster,
      stDefensePercentVsMonster,
      stFireLength,
      stBurningMin,
      stBurningMax,
      stProgressiveDamage,
      stProgressiveSteal,
      stProgressiveOther,
      stProgressiveFire,
      stProgressiveCold,
      stProgressiveLightning,
      stExtraCharges,
      stProgressiveToHit,
      stPoisonCount,
      stDamageFramerate,
      stPierceIdx,
      stPassiveFireMastery,
      stPassiveLightningMastery,
      stPassiveColdMastery,
      stPassivePoisonMastery,
      stPassiveFirePierce,
      stPassiveLightningPierce,
      stPassiveColdPierce,
      stPassivePoisonPierce,
      stPassiveCriticalStrike,
      stPassiveDodge,
      stPassiveAvoid,
      stPassiveEvade,
      stPassiveWarmth,
      stPassiveMasteryMeleeToHit,
      stPassiveMasteryMeleeDamage,
      stPassiveMasteryMeleeCritical,
      stPassiveMasteryThrowToHit,
      stPassiveMasteryThrowDamage,
      stPassiveMasteryThrowCritical,
      stPassiveWeaponBlock,
      stPassiveSummon_resist,
      stModifierListSkill,
      stModifierListLevel,
      stLastSentLifePercent,
      stSourceUnitType,
      stSourceUnitID,
      stShortParam1,
      stQuestItemDifficulty,
      stPassiveMagicMastery,
      stPassiveMagicPierce);


procedure Client_GameChat(Proxy: IProxy; Owner: IModule; Name:String; Whisper:boolean; Text: String); stdcall;
procedure Client_ReassignPlayer(Proxy: IProxy; Owner: IModule; ID:Cardinal; X, Y:Word); stdcall;

procedure Server_WalkToObject(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal; Run:Boolean); stdcall;
procedure Server_Walk(Proxy: IProxy; Owner: IModule; X, Y:Word; Run:Boolean); stdcall;
procedure Server_Sync(Proxy: IProxy; Owner: IModule; X, Y:Word); stdcall;
procedure Server_GameChat(Proxy: IProxy; Owner: IModule; Text: String; WhisperTo: String; Kind: TGameMessageType); stdcall;


procedure Server_GoToTownFolk(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal; X, Y: Word); stdcall;
procedure Server_TownFolkInteract(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal); stdcall;

procedure Server_UnitInteract(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal); stdcall;

procedure Server_WaypointInteract(Proxy: IProxy; Owner: IModule; ID: Cardinal; Destination: Byte); stdcall;

procedure Server_TownFolkCancelInteract(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal); stdcall;

procedure Server_SelectSkill(Proxy: IProxy; Owner: IModule; Skill:Word); stdcall;
procedure Server_UseSkill(Proxy: IProxy; Owner: IModule; x, y:Word); stdcall;

procedure SetDword(Data: PChar; index: Cardinal; Value: Cardinal); inline;
procedure SetWord(Data: PChar; index: Cardinal; Value: Word); inline;

implementation

uses Windows, SysUtils;

procedure SetDword(Data: PChar; index: Cardinal; Value: Cardinal);
begin
  Cardinal((@Data[index])^) := Value;
end;

procedure SetWord(Data: PChar; index: Cardinal; Value: Word);
begin
  Cardinal((@Data[index])^) := Value;
end;


procedure Server_SelectSkill(Proxy: IProxy; Owner: IModule; Skill:Word);
var Packet: IPacket;
    SelectSkillPacket: array[0..8] of Byte;
begin
  SelectSkillPacket[0] := D2C_SELECTSKILL;
  Word((@SelectSkillPacket[1])^) := Skill;
  SelectSkillPacket[3] := 0;
  SelectSkillPacket[4] := 0;
  Cardinal((@SelectSkillPacket[5])^) := $FFFFFFFF;
	Packet := Proxy.CreatePacket(@SelectSkillPacket[0], 9);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;   
end;

procedure Server_UseSkill(Proxy: IProxy; Owner: IModule; x, y:Word);
var Packet: IPacket;
    SkillPacket: array[0..4] of Byte;
begin
  SkillPacket[0] := D2C_USERIGHT;
  Word((@SkillPacket[1])^) := x;
  Word((@SkillPacket[3])^) := y;
	Packet := Proxy.CreatePacket(@SkillPacket[0], 5);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;


procedure Server_TownFolkCancelInteract(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal); stdcall;
var Packet: IPacket;
    PacketData: array[0..8] of Byte;
begin
  PacketData[0] := D2C_TownFolkCancelInteract;

  SetDword(@PacketData[0], 1, Byte(UnitType));

  SetDword(@PacketData[0], 5, ID);

	Packet := Proxy.CreatePacket(@PacketData[0], 9);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;



procedure Server_WaypointInteract(Proxy: IProxy; Owner: IModule; ID: Cardinal; Destination: Byte); stdcall;
var Packet: IPacket;
    PacketData: array[0..8] of Byte;
begin
  PacketData[0] := D2C_WaypointInteract;


  SetDword(@PacketData[0], 1, ID);

  SetDword(@PacketData[0], 5, Byte(Destination));

	Packet := Proxy.CreatePacket(@PacketData[0], 9);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;

procedure Server_UnitInteract(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal); stdcall;
var Packet: IPacket;
    PacketData: array[0..8] of Byte;
begin
  PacketData[0] := D2C_UnitInteract;

  SetDword(@PacketData[0], 1, Byte(UnitType));

  SetDword(@PacketData[0], 5, ID);

	Packet := Proxy.CreatePacket(@PacketData[0], 9);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;

procedure Server_GoToTownFolk(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal; X, Y: Word); stdcall;
var Packet: IPacket;
    PacketData: array[0..16] of Byte;
begin
  ZeroMemory(@PacketData[0], 17);
  PacketData[0] := D2C_GoToTownFolk;
  SetDword(@PacketData[0], 1, Byte(UnitType));
  //2, 3, 4
  SetDword(@PacketData[0], 5, ID);
  //6, 7, 8
  Word((@PacketData[9])^) := X;
  //10, 11, 12
  Word((@PacketData[13])^) := Y;
  //14, 15, 16
	Packet := Proxy.CreatePacket(@PacketData[0], 17);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;

procedure Server_GameChat(Proxy: IProxy; Owner: IModule; Text: String; WhisperTo: String; Kind: TGameMessageType); stdcall;
var Packet: IPacket;
    Buffer:TMemoryStream;
    Data:Byte;
    MessageType: Word;
begin
  Buffer := TMemoryStream.Create;

  Data := D2C_CHAT;
  Buffer.Write(Data, 1);

  MessageType := Word(Kind);
  Buffer.Write(MessageType, 2);

  Buffer.Write(PChar(Text)^, Length(Text)+1);

	Packet := Proxy.CreatePacket(Buffer.Memory, Buffer.Size);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;

	Buffer.Free;
end;

procedure Server_TownFolkInteract(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal); stdcall;
var Packet: IPacket;
    PacketData: array[0..8] of Byte;
begin
  PacketData[0] := D2C_TownFolkInteract;

  Cardinal((@PacketData[1])^) := 0;
  PacketData[1] := Byte(UnitType);

  Cardinal((@PacketData[5])^) := ID;

	Packet := Proxy.CreatePacket(@PacketData[0], 9);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;

procedure Server_WalkToObject(Proxy: IProxy; Owner: IModule; UnitType: TUnitType; ID: Cardinal; Run:Boolean); stdcall;
var Packet: IPacket;
    PacketData: array[0..8] of Byte;
begin
 if Run then
  PacketData[0] := D2C_RunToObject
 else
  PacketData[0] := D2C_WalkToObject;

  Cardinal((@PacketData[1])^) := 0;
  PacketData[1] := Byte(UnitType);

  Cardinal((@PacketData[5])^) := ID;

	Packet := Proxy.CreatePacket(@PacketData[0], 9);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;

procedure Server_Walk(Proxy: IProxy; Owner: IModule; X, Y:Word; Run:Boolean); stdcall;
var Packet: IPacket;
    PacketData: array[0..4] of Byte;
begin
 if Run then
  PacketData[0] := D2C_RUN
 else
  PacketData[0] := D2C_WALK;

  Word((@PacketData[1])^) := X;
  Word((@PacketData[3])^) := Y;
	Packet := Proxy.CreatePacket(@PacketData[0], 5);
  //Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;

procedure Server_Sync(Proxy: IProxy; Owner: IModule; X, Y:Word); stdcall;
var Packet: IPacket;
    PacketData: array[0..3] of Byte;
begin
  PacketData[0] := D2C_UPDATEPOS;
  Word((@PacketData[1])^) := X;
  Word((@PacketData[3])^) := Y;
	Packet := Proxy.CreatePacket(@PacketData[0], 4);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToServer(Packet, Owner);
  Packet.Delete;
end;

procedure Client_ReassignPlayer(Proxy: IProxy; Owner: IModule; ID:Cardinal; X, Y:Word);
var Packet: IPacket;
    PacketData: array[0..10] of Byte;
begin
  PacketData[0] := D2S_REASSIGN;
  PacketData[1] := Byte(utPlayer);
  Cardinal((@PacketData[2])^) := ID;
  Word((@PacketData[6])^) := X;
  Word((@PacketData[8])^) := Y;
  PacketData[10] := 1;
	Packet := Proxy.CreatePacket(@PacketData[0], 11);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToClient(Packet, Owner);
  Packet.Delete;
end;

procedure Client_GameChat(Proxy: IProxy; Owner: IModule; Name:String; Whisper:boolean; text:String);
var Packet: IPacket;
    Buffer:TMemoryStream;
    Data:Byte;
begin
  Buffer := TMemoryStream.Create;
  Buffer.Size := Length(text) + 1 + Length(name) + 1 + 10;

  Data := $26;
  Buffer.Write(Data, 1);

  if Whisper then
   begin
    Data := $02;
    Buffer.Write(Data, 1);
   end
  else
   begin
    Data := $01;
    Buffer.Write(Data, 1);
   end;
  Data := $00;
  Buffer.Write(Data, 1);
  Data := $02;
  Buffer.Write(Data, 1);
  Data := $00;
  Buffer.Write(Data, 1);
  Buffer.Write(Data, 1);
  Buffer.Write(Data, 1);
  Buffer.Write(Data, 1);
  Buffer.Write(Data, 1);

  if Whisper then
   begin
    Data := $01;
    Buffer.Write(Data, 1);
   end
  else
   begin
    Data := $05;
    Buffer.Write(Data, 1);
   end;

  Buffer.Write(PChar(Name)^, Length(Name)+1);
  Buffer.Write(PChar(Text)^, Length(Text)+1);

	Packet := Proxy.CreatePacket(Buffer.Memory, Buffer.Size);
  Packet.SetFlag(PacketFlag_Hidden);
	Proxy.RelayDataToClient(Packet, Owner);
  Packet.Delete;

	Buffer.Free;
end;

end.
