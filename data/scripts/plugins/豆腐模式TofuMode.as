
void OnPluginInit()
{
    PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "紫冰ZB" );
	PluginData::SetName( "豆腐模式 tofu Mode" );

	Events::Player::OnPlayerSpawn.Hook( @OnPlayerSpawn );
	Events::Player::PlayerSay.Hook( @OnPlayerSay );
	Events::Player::OnPlayerDamaged.Hook( @OnPlayerDamaged );

	// SetPlayerRules();
}

void ThePresident_OnMapStart()
{
	Schedule::Task( 8.0, SetGameRules );
}

// void ThePresident_OnRoundStart()
// {
	// SetGameRules();
	// SetPlayerRules();
// }

// ----------设定游戏规则
void SetGameRules()
{
	Engine.EnableCustomSettings( true );
	CASConVarRef@ infinite_stamina = ConVar::Find( "sv_infinite_stamina" );
	infinite_stamina.SetValue("0");
	CASConVarRef@ zb_z_attack_damage = ConVar::Find( "z_attack_damage" );
	zb_z_attack_damage.SetValue("5.5");
	CASConVarRef@ zb_cg_grapple_damage_nightmare = ConVar::Find( "cg_grapple_damage_nightmare" );
	zb_cg_grapple_damage_nightmare.SetValue("1");

	string w_ammo = "item_ammo_*";
	CBaseEntity @pEnt = FindEntityByClassname( null, w_ammo );
	while( pEnt !is null)
	{
		pEnt.SUB_Remove();
		@pEnt = FindEntityByClassname( pEnt, w_ammo );
	}

	string w_1911 = "weapon_1911";
	CBaseEntity @pEnt1 = FindEntityByClassname( null, w_1911 );
	while( pEnt1 !is null)
	{
		pEnt1.SUB_Remove();
		@pEnt1 = FindEntityByClassname( pEnt1, w_1911 );
	}

	string w_357 = "weapon_357";
	CBaseEntity @pEnt2 = FindEntityByClassname( null, w_357 );
	while( pEnt2 !is null)
	{
		pEnt2.SUB_Remove();
		@pEnt2 = FindEntityByClassname( pEnt2, w_357 );
	}

	string w_acr = "weapon_acr";
	CBaseEntity @pEnt3 = FindEntityByClassname( null, w_acr );
	while( pEnt3 !is null)
	{
		pEnt3.SUB_Remove();
		@pEnt3 = FindEntityByClassname( pEnt3, w_acr );
	}

	string w_ak74 = "weapon_ak74";
	CBaseEntity @pEnt4 = FindEntityByClassname( null, w_ak74 );
	while( pEnt4 !is null)
	{
		pEnt4.SUB_Remove();
		@pEnt4 = FindEntityByClassname( pEnt4, w_ak74 );
	}

	string w_ar15 = "weapon_ar15";
	CBaseEntity @pEnt5 = FindEntityByClassname( null, w_ar15 );
	while( pEnt5 !is null)
	{
		pEnt5.SUB_Remove();
		@pEnt5 = FindEntityByClassname( pEnt5, w_ar15 );
	}

	string w_scar = "weapon_scar";
	CBaseEntity @pEnt6 = FindEntityByClassname( null, w_scar );
	while( pEnt6 !is null)
	{
		pEnt6.SUB_Remove();
		@pEnt6 = FindEntityByClassname( pEnt6, w_scar );
	}

	string w_autoshotgun  = "weapon_autoshotgun";
	CBaseEntity @pEnt7 = FindEntityByClassname( null, w_autoshotgun );
	while( pEnt7 !is null)
	{
		pEnt7.SUB_Remove();
		@pEnt7 = FindEntityByClassname( pEnt7, w_autoshotgun );
	}

	string w_baseballbat = "weapon_baseballbat";
	CBaseEntity @pEnt8 = FindEntityByClassname( null, w_baseballbat );
	while( pEnt8 !is null)
	{
		pEnt8.SUB_Remove();
		@pEnt8 = FindEntityByClassname( pEnt8, w_baseballbat );
	}

	string w_blr = "weapon_blr";
	CBaseEntity @pEnt9 = FindEntityByClassname( null, w_blr );
	while( pEnt9 !is null)
	{
		pEnt9.SUB_Remove();
		@pEnt9 = FindEntityByClassname( pEnt9, w_blr );
	}

	string w_compbow = "weapon_compbow";
	CBaseEntity @pEnt10 = FindEntityByClassname( null, w_compbow );
	while( pEnt10 !is null)
	{
		pEnt10.SUB_Remove();
		@pEnt10 = FindEntityByClassname( pEnt10, w_compbow );
	}

	string w_crossbow = "weapon_crossbow";
	CBaseEntity @pEnt11 = FindEntityByClassname( null, w_crossbow );
	while( pEnt11 !is null)
	{
		pEnt11.SUB_Remove();
		@pEnt11 = FindEntityByClassname( pEnt11, w_crossbow );
	}

	string w_doublebarrel = "weapon_doublebarrel";
	CBaseEntity @pEnt12 = FindEntityByClassname( null, w_doublebarrel );
	while( pEnt12 !is null)
	{
		pEnt12.SUB_Remove();
		@pEnt12 = FindEntityByClassname( pEnt12, w_doublebarrel );
	}

	string w_grenadelauncher = "weapon_grenadelauncher";
	CBaseEntity @pEnt13 = FindEntityByClassname( null, w_grenadelauncher );
	while( pEnt13 !is null)
	{
		pEnt13.SUB_Remove();
		@pEnt13 = FindEntityByClassname( pEnt13, w_grenadelauncher );
	}

	string w_handcannon = "weapon_handcannon";
	CBaseEntity @pEnt14 = FindEntityByClassname( null, w_handcannon );
	while( pEnt14 !is null)
	{
		pEnt14.SUB_Remove();
		@pEnt14 = FindEntityByClassname( pEnt14, w_handcannon );
	}

	string w_kg9 = "weapon_kg9";
	CBaseEntity @pEnt15 = FindEntityByClassname( null, w_kg9 );
	while( pEnt15 !is null)
	{
		pEnt15.SUB_Remove();
		@pEnt15 = FindEntityByClassname( pEnt15, w_kg9 );
	}

	string w_m1garand = "weapon_m1garand";
	CBaseEntity @pEnt16 = FindEntityByClassname( null, w_m1garand );
	while( pEnt16 !is null)
	{
		pEnt16.SUB_Remove();
		@pEnt16 = FindEntityByClassname( pEnt16, w_m1garand );
	}

	string w_mac10 = "weapon_mac10";
	CBaseEntity @pEnt17 = FindEntityByClassname( null, w_mac10 );
	while( pEnt17 !is null)
	{
		pEnt17.SUB_Remove();
		@pEnt17 = FindEntityByClassname( pEnt17, w_mac10 );
	}

	string w_mossberg = "weapon_mossberg";
	CBaseEntity @pEnt18 = FindEntityByClassname( null, w_mossberg );
	while( pEnt18 !is null)
	{
		pEnt18.SUB_Remove();
		@pEnt18 = FindEntityByClassname( pEnt18, w_mossberg );
	}

	string w_mp5k = "weapon_mp5k";
	CBaseEntity @pEnt19 = FindEntityByClassname( null, w_mp5k );
	while( pEnt19 !is null)
	{
		pEnt19.SUB_Remove();
		@pEnt19 = FindEntityByClassname( pEnt19, w_mp5k );
	}

	string w_overunder = "weapon_overunder";
	CBaseEntity @pEnt20 = FindEntityByClassname( null, w_overunder );
	while( pEnt20 !is null)
	{
		pEnt20.SUB_Remove();
		@pEnt20 = FindEntityByClassname( pEnt20, w_overunder );
	}

	string w_remington870 = "weapon_remington870";
	CBaseEntity @pEnt21 = FindEntityByClassname( null, w_remington870 );
	while( pEnt21 !is null)
	{
		pEnt21.SUB_Remove();
		@pEnt21 = FindEntityByClassname( pEnt21, w_remington870 );
	}

	string w_revolver = "weapon_revolver";
	CBaseEntity @pEnt22 = FindEntityByClassname( null, w_revolver );
	while( pEnt22 !is null)
	{
		pEnt22.SUB_Remove();
		@pEnt22 = FindEntityByClassname( pEnt22, w_revolver );
	}

	string w_sig = "weapon_sig";
	CBaseEntity @pEnt23 = FindEntityByClassname( null, w_sig );
	while( pEnt23 !is null)
	{
		pEnt23.SUB_Remove();
		@pEnt23 = FindEntityByClassname( pEnt23, w_sig );
	}

	string w_sniper = "weapon_sniper";
	CBaseEntity @pEnt24 = FindEntityByClassname( null, w_sniper );
	while( pEnt24 !is null)
	{
		pEnt24.SUB_Remove();
		@pEnt24 = FindEntityByClassname( pEnt24, w_sniper );
	}

	Chat.PrintToChat( all, "{purple}[紫冰] {white}当前游戏:{green}豆腐模式(测试版)!");
	Chat.PrintToChat( all, "{purple}[紫冰] {azure}游戏规则:{white}开局一把刀,免伤靠身法.枪支稀又缺,存活需搏杀!");
	Schedule::Task( 45.0, SetGameRules );
}

// void SetPlayerRules()
// {
// 	for ( int i = 1; i <= Globals.GetMaxClients(); i++ )
// 	{
// 		CTerrorPlayer @pPlayer = ToTerrorPlayer( i );
// 		pPlayer.StripEquipment( true );
// 		pPlayer.GiveWeapon( "phone" );
// 		pPlayer.GiveWeapon( "kabar" );
// 		pPlayer.GiveWeapon( "firstaid" );
// 		pPlayer.GiveWeapon( "plight" );
// 	}
// }

// ----------玩家生成
HookReturnCode OnPlayerSpawn(CTerrorPlayer@ pPlayer)
{
	if(pPlayer !is null && pPlayer.GetTeamNumber() == TEAM_SURVIVOR) //|| !pPlayer.IsBot()
	{
		DropWeapons( pPlayer );
		pPlayer.GiveWeapon( "phone" );
		pPlayer.GiveWeapon( "kabar" );
		pPlayer.GiveWeapon( "firstaid" );
		pPlayer.GiveWeapon( "plight" );
		Chat.PrintToChat( pPlayer, "{gold}[紫冰] {azure}"+pPlayer.GetPlayerName()+"{white}已经获得了{green}豆腐套装");
	}
	else
	Chat.PrintToChat( pPlayer, "{gold}[紫冰] {azure}"+pPlayer.GetPlayerName()+"{white}你现在是{red}丧尸");
	
	// Schedule::Task( 3.0f, pPlayer.entindex(), SetNewHPAfterSpawn );
	return HOOK_CONTINUE;
}

void DropWeapons( CTerrorPlayer@ pPlayer )
{
	pPlayer.StripEquipment( true );	
}

// void SetNewHPAfterSpawn( int client )
// {
// 	NetProp::SetPropInt( client, "m_iMaxHealth", 200 );
// }

// ----------聊天框信息
HookReturnCode OnPlayerSay( CTerrorPlayer@ pPlayer, CASCommand@ pArgs )
{
	string arg1 = pArgs.Arg( 1 );
	if ( Utils.StrEql( arg1, "!s" ) || Utils.StrEql( arg1, "/s" ))
	{
		Cmd_switch( pPlayer );   //跳转执行
		return HOOK_HANDLED;
	}
	return HOOK_CONTINUE;
}
void Cmd_switch( CTerrorPlayer@ pPlayer)
{
	RemoveMapItem();
	DropWeapons( pPlayer );
	pPlayer.GiveWeapon( "phone" );
	pPlayer.GiveWeapon( "kabar" );
	pPlayer.GiveWeapon( "firstaid" );
	pPlayer.GiveWeapon( "plight" );
	
}
//移除地图物品指令
void RemoveMapItem()
{
	string strClassname = "item_ammo_*";
	CBaseEntity @pEnt = FindEntityByClassname( null, strClassname );
	while( pEnt !is null)
	{
		pEnt.SUB_Remove();
		@pEnt = FindEntityByClassname( pEnt, strClassname );
	}

	string w_weapon = "weapon_*";
	CBaseEntity @wpEnt = FindEntityByClassname( null, w_weapon );
	while( wpEnt !is null)
	{
		wpEnt.SUB_Remove();
		@wpEnt = FindEntityByClassname( wpEnt, w_weapon );
	}
}

// ----------玩家受到伤害
HookReturnCode OnPlayerDamaged(CTerrorPlayer@ pPlayer, CTakeDamageInfo &in DamageInfo)
{
	CBaseEntity @pEntityPlayer = ToBaseEntity( pPlayer );
	int iHealthMax = pEntityPlayer.GetMaxHealth();
	int iHealth = pEntityPlayer.GetHealth();
	// pEntityPlayer.SetHealth( Math::clamp( iHealth, 0, iHealthMax ) );
	Chat.PrintToChat( pPlayer, "{purple}[紫冰] {azure}"+pPlayer.GetPlayerName() +"{white}受到伤害,当前剩余血量:{green}"+ pEntityPlayer.GetHealth()+"{white}/"+ iHealthMax);
	return HOOK_CONTINUE;
}

CBaseEntity@ ToBaseEntity( CTerrorPlayer@ pPlayer )
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CBaseEntity@ pEntityPlayer = pBasePlayer.opCast();
	return pEntityPlayer;
}
