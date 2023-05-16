void OnPluginInit()
{
    PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "紫冰ZB" );
	PluginData::SetName( "第三人称" );

	Events::Player::PlayerSay.Hook( @OnPlayerSay );
}

void ThePresident_OnMapStart()
{
	Schedule::Task( 5.0, "SendMsg" );
}

void ThePresident_OnRoundStart()
{
	Schedule::Task( 5.0, "SendMsg" );

}

HookReturnCode OnPlayerSay( CTerrorPlayer@ pPlayer, CASCommand@ pArgs )
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CTerrorWeapon@ self = pBasePlayer.opCast();
	string arg1 = pArgs.Arg( 1 );
    if ( Utils.StrEql( arg1, "!3" ) || Utils.StrEql( arg1, "/3" ))
	{
		NetProp::SetPropFloat( pPlayer.entindex(), "m_TimeForceExternalView", 99999.3 );
	}
	else  if ( Utils.StrEql( arg1, "!1" ) || Utils.StrEql( arg1, "/1" ))
	{
		NetProp::SetPropFloat( pPlayer.entindex(), "m_TimeForceExternalView", 0 );
	}
	return HOOK_CONTINUE;
}
void SendMsg()
{
	for(int i = 1;i<=Globals.GetMaxClients();i++)
	{
		CTerrorPlayer @pTerror = ToTerrorPlayer( i );
		CBasePlayer@ pPlayer = pTerror.opCast();
		ThePresident.OnObjective( "你好!"+ pPlayer.GetPlayerName() +"\n游戏指令操作:\n第三人称指令:!3\n第一人称指令:!1");
	}
}