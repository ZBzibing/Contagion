string PluginVersion = "1.0";
string PluginAuthor = "紫冰ZB";
string PluginName = "死亡导航";

CASConVar@ zb_switch = null;    //1.定义开关
Vector Location;
int m_BeamSprite;
int m_HaloSprite;
string gravename = "";
array<string> gravemdl = {"models/halloween/halloween_gravestone01.mdl",
"models/halloween/halloween_gravestone02.mdl",
"models/halloween/halloween_gravestone03.mdl",
"models/halloween/halloween_gravestone04.mdl"
};

bool zbswitch(){ return zb_switch.GetBool(); }  //3.定义一个判断指令参数条件
// int ispeed() { return rz_speed.GetInt(); }

void OnPluginInit()
{
    PluginData::SetVersion( PluginVersion );
	PluginData::SetAuthor( PluginAuthor );
	PluginData::SetName( PluginName );
    ThePresident.InfoFeed("插件:"+PluginName+"| 版本:"+PluginVersion+"| 更新:"+Globals.GetCurrentTime(),true);

	Events::Weapons::Melee.Hook( @Melee );  //玩家近身攻击
    Events::Trigger::OnStartTouch.Hook( @OnStartTouch );    //触发按钮
    Events::Player::OnPlayerKilled.Hook( @OnPlayerKilled ); //玩家死亡
    // Events::Infected::OnInfectedSpawned.Hook( @OnInfectedSpawned ); //感染者出生
    Events::Infected::OnInfectedKilled.Hook( @OnInfectedKilled );	//感染者死亡

    Console(); //指令加载
    Entities::RegisterUse( "button_a" );

    RegisterEntities(); //注册实体output
}
void ThePresident_OnMapStart()
{
	Console(); //指令加载
}

void ThePresident_OnRoundStart()
{
	Console(); //指令加载
}

void Console()
{
    @zb_switch = ConVar::Create( "zb_nav_switch", "1", "插件开关.0:禁用,1:启用", true, 0, true, 1 );   //2.设置指令参数

    m_BeamSprite = Engine.PrecacheFile( model, "sprites/laserbeam.vmt" );
	m_HaloSprite = Engine.PrecacheFile( model, "sprites/light_glow01.vmt" );
}

//-----------------------------------------------------------玩家近身攻击-------------------------------------------------------------//
HookReturnCode Melee(CTerrorPlayer@ pOwner, bool &in bMeleeBash, bool &in bHeavy, CBaseEntity@ pHit)
{
   
    string strClassname = "weapon_phone";
    CBaseEntity @pEnt = FindEntityByClassname( null, strClassname );
    while( pEnt !is null )
    {
        @pEnt = FindEntityByClassname(pEnt, strClassname );
    }
    // if( Utils.StrEql(pEnt,"Phone"))
    // {
        // Chat.PrintToChat(all,""+pOwner.GetPlayerName()+"推了" );
    // }
    return HOOK_CONTINUE;
}

//-----------------------------------------------------------感染者死亡-------------------------------------------------------------//
HookReturnCode OnInfectedKilled(Infected@ pInfected, CTakeDamageInfo &in DamageInfo)
{
    return HOOK_CONTINUE;
}

//-----------------------------------------------------------玩家死亡-------------------------------------------------------------//
HookReturnCode OnPlayerKilled(CTerrorPlayer@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	Location = pPlayer.GetAbsOrigin();
    gravename = pPlayer.GetPlayerName();
    Entities::RegisterUse( gravename ); //以玩家名称注册墓碑实体名

	CEntityData@ grave = EntityCreator::EntityData();
	grave.Add( "model", "models/halloween/halloween_gravestone01.mdl" );
    grave.Add( "targetname",gravename);
    grave.Add( "use_time","5");
    grave.Add( "use_string","救救我...help me");
    grave.Add( "OnTimeUp","Kill");
    EntityCreator::Create( "prop_button_timed", Location, QAngle( 0, 0, 0 ), grave );    

    Color clr = Color( 255, 75, 75, 255 );
	if ( pPlayer.GetTeamNumber() == TEAM_SURVIVOR )
    {
		clr = Color( 75, 75, 255, 255 );
        Utils.CreateBeamRingPoint( 0.0f, Location, Color( 128, 128, 128, 255 ), 10.0f, 2375.0f, m_BeamSprite, m_HaloSprite, 0, 15, 0.5f, 5.0f, 0.0f, 10.0, 0, 0 );
	    Utils.CreateBeamRingPoint( 0.0f, Location,                          clr, 10.0, 1375.0f, m_BeamSprite, m_HaloSprite, 0, 10, 0.6, 10.0, 0.5, 10, 0, 0 );
    }
    ThePresident.OnObjectiveTarget( "{azure}"+pPlayer.GetPlayerName()+":\n"+gravename+"{white}发送了呼救信号!找到他,或许还有救!发送了呼救信号! \nDistress signal, need rescue!", Location );
    return HOOK_CONTINUE;
}

void RegisterEntities()
{
    Entities::RegisterOutput( "OnTimeUp", "grave04" );
    Entities::RegisterUse( "prop_button_time" );
}

HookReturnCode OnStartTouch(CBaseEntity@ pTrigger, const string &in strEntityName, CBaseEntity@ pEntity)
{
    string ce_bio = "grave04";
    CBaseEntity @ce_bio_pEnt = FindEntityByName( null, ce_bio );
    while( ce_bio_pEnt !is null)
    {
        // ce_bio_pEnt.SetOutline( 2, use, both, Color(255, 0, 0), true, 150.0f ); //设置轮廓
        // ce_bio_pEnt.SetGlow(true, Color(255, 0, 0, 255), 10.0f);    //设置轮廓光辉
        ce_bio_pEnt.SUB_StartFadeOut(1.0,false);   //多少秒消失后,删除实体
        @ce_bio_pEnt = FindEntityByName( ce_bio_pEnt, ce_bio );
    }
    // Chat.PrintToChat(all,"触发按钮"+strEntityName);
    return HOOK_CONTINUE;
}

//-----------------------------------------------------------按钮被触发-------------------------------------------------------------//
void OnButtonUsed( CTerrorPlayer@ pPlayer, CBaseEntity@ pEntity )
{
	if ( pPlayer is null ) return;
	if ( pEntity is null ) return;

    CBasePlayer@ pBasePlayer = pPlayer.opCast();
    for(int i=1;i<=Globals.GetMaxClients();i++)
    {
        CTerrorPlayer @pTerror = ToTerrorPlayer( i );
        // Chat.PrintToConsole(all,"[紫冰_DEBUG] "+pTerror.GetPlayerName()+"|"+gravename);
        if ( Utils.StrEql(pTerror.GetPlayerName() , pEntity.GetEntityName()) && pTerror.GetTeamNumber()!=TEAM_SURVIVOR)   //
        {
            // Chat.PrintToChat(all,"{purple}[紫冰_DEBUG] "+pPlayer.GetPlayerName()+"触发了按钮"+pEntity.GetEntityName()+"复活"+pTerror.GetPlayerName());

            CBaseEntity @ce_bio_pEnt = FindEntityByName( null, pEntity.GetEntityName());
            while( ce_bio_pEnt !is null)
            {
                ce_bio_pEnt.SUB_StartFadeOut(5.0,false);   //多少秒消失后,删除实体
                @ce_bio_pEnt = FindEntityByName( ce_bio_pEnt, pEntity.GetEntityName());
                Chat.PrintToChat(all,"{purple}[紫冰] {azure}"+pPlayer.GetPlayerName()+"{white}找到了{azure}"+pEntity.GetEntityName()+"{white}的墓碑{azure}"+pTerror.GetPlayerName()+"{green}30秒{white}后重生.");
            }

            Schedule::Task( 30.0, pTerror.entindex(),revive );
        }
        // else
        // {
        //     CBaseEntity @ce_bio_pEnt = FindEntityByName( null, pEntity.GetEntityName());
        //     while( ce_bio_pEnt !is null)
        //     {
        //         ce_bio_pEnt.SUB_StartFadeOut(5.0,false);   //多少秒消失后,删除实体
        //         @ce_bio_pEnt = FindEntityByName( ce_bio_pEnt, pEntity.GetEntityName());
        //     }
        //     // Chat.PrintToChat(all,"{black}[紫冰_DEBUG] "+pPlayer.GetPlayerName()+"触"+pEntity.GetEntityName());
        // }
    }
}

void revive(int i)
{
    CTerrorPlayer@ pTerrorPlayer = ToTerrorPlayer( i );
    pTerrorPlayer.ChangeTeam(TEAM_SURVIVOR);
    pTerrorPlayer.Respawn();
    Chat.PrintToChat(all,"{purple}[紫冰] {azure}"+pTerrorPlayer.GetPlayerName()+"{white}被队友救活了.");
}