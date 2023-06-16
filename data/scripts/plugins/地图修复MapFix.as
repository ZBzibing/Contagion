void OnPluginInit()
{
    PluginData::SetVersion( "1.4" );
	PluginData::SetAuthor( "紫冰ZB" );
	PluginData::SetName( "地图修复 MapFix" );
	IsMapFix();
}

void ThePresident_OnMapStart()
{
	IsMapFix();

	Engine.PrecacheFile( model, "models/props_downtown/building_props/subway_wallad05.mdl" );	//广告牌
	Engine.PrecacheFile( model, "models/props_downtown/building_props/subway_wallad06.mdl" );
	Engine.PrecacheFile( model, "models/props_suburbs/fence_modular_short01.mdl" );	//木栅栏
	Engine.PrecacheFile( model, "models/props_downtown/downtown_fence01a.mdl" );	//铁丝网
	Engine.PrecacheFile( model, "models/props_trap/fence01.mdl" );	//铁丝网
}

void ThePresident_OnRoundStart()
{
	Schedule::Task( 3.0, IsMapFix );
}

// ----------地图BUG修复
void IsMapFix()
{
//巴洛克广场
	if ( Globals.IsCurrentMap( "ce_barlowesquare" ) )
	{
		CEntityData@ roof_fence1 = EntityCreator::EntityData();
		roof_fence1.Add( "model", "models/props_trap/fence01.mdl" );
		roof_fence1.Add( "solid", "6" );
		EntityCreator::Create( "prop_dynamic", Vector( 6450, 4155, -2054 ), QAngle( 0, 0, 0 ), roof_fence1 );

		Chat.PrintToChat(all,"{purple}[紫冰] {white}当前地图:"+Globals.GetCurrentMapName()+"部分BUG已修复!");
		return;
	}
//警察局
    if ( Globals.IsCurrentMap( "ce_roanokepd_halloween" ) || Globals.IsCurrentMap( "ce_roanokepd" ))
	{
		CEntityData@ inputdata = EntityCreator::EntityData();
		inputdata.Add( "maxs","50 15 80" );
		inputdata.Add( "mins", "-50 -15 -80" );
		inputdata.Add( "BlockType", "1" );
		EntityCreator::Create( "env_player_blocker", Vector( 188.362,3712,513 ), QAngle( 0, 0, 0 ), inputdata );
		CEntityData@ roof_fence = EntityCreator::EntityData();
		roof_fence.Add( "model", "models/props_suburbs/fence_modular_short01.mdl" );
		roof_fence.Add( "solid", "6" );
		EntityCreator::Create( "prop_dynamic", Vector( 702, 3447, 397 ), QAngle( 0, 90, 0 ), roof_fence );
		EntityCreator::Create( "prop_dynamic", Vector( 1475, 3433, 397 ), QAngle( 0, 90, 0 ), roof_fence );
		CEntityData@ roof_fence1 = EntityCreator::EntityData();
		roof_fence1.Add( "model", "models/props_downtown/downtown_fence01a.mdl" );
		roof_fence1.Add( "solid", "6" );
		EntityCreator::Create( "prop_dynamic", Vector( 145, 3729, 433 ), QAngle( 0, 0, 0 ), roof_fence1 );
	}
//生物实验室
	if ( Globals.IsCurrentMap( "ce_biotec" ) || Globals.IsCurrentMap("ce_biotec_christmas"))
	{
		string ce_bio = "vaccine_secure_door";
		CBaseEntity @ce_bio_pEnt = FindEntityByName( null, ce_bio );
		while( ce_bio_pEnt !is null)
		{
			ce_bio_pEnt.SUB_Remove();
			@ce_bio_pEnt = FindEntityByName( ce_bio_pEnt, ce_bio );
		}

		Chat.PrintToChat(all,"{purple}[紫冰] {white}当前地图:"+Globals.GetCurrentMapName()+"部分BUG已修复!");
		return;
	}
//终点站
	if ( Globals.IsCurrentMap( "ce_laststop_03" ))
	{
		CreatePhysProps();
		Chat.PrintToChat(all,"{purple}[紫冰] {white}当前地图:"+Globals.GetCurrentMapName()+"部分BUG已修复!");
		return;
	}

	if ( Globals.IsCurrentMap( "ce_laststop_05b" ))
	{
		CEntityData@ inputdata = EntityCreator::EntityData();
		inputdata.Add( "model", "models/props_downtown/building_props/subway_wallad06.mdl" );
		inputdata.Add( "solid", "6" );
		EntityCreator::Create( "prop_dynamic", Vector( -6394,370,10837 ), QAngle( 0, 0, 0 ), inputdata );
	}
}

void CreatePhysProps()
{
	CreateHalloweenPhysProp( Vector( 8265, -2573, -154 ), QAngle( 0, 0, 0 ) );
	CreateHalloweenPhysProp( Vector( 7955, -2580, -87 ), QAngle( 0, 180, 0 ) );
}
void CreateHalloweenPhysProp( Vector &in vec, QAngle &in ang )
{
	CEntityData@ inputdata = EntityCreator::EntityData();
	inputdata.Add( "model", "models/props_downtown/building_props/subway_wallad05.mdl" );
	inputdata.Add( "solid", "6" );
	EntityCreator::Create( "prop_dynamic", vec, ang, inputdata );
}

void Celast05b( Vector &in vec, QAngle &in ang )
{
	CEntityData@ inputdata = EntityCreator::EntityData();
	inputdata.Add( "model", "models/props_downtown/building_props/subway_wallad06.mdl" );
	inputdata.Add( "solid", "6" );
	EntityCreator::Create( "prop_dynamic", vec, ang, inputdata );
}

// ----------
CBaseEntity@ ToBaseEntity( CTerrorPlayer@ pPlayer )
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CBaseEntity@ pEntityPlayer = pBasePlayer.opCast();
	return pEntityPlayer;
}