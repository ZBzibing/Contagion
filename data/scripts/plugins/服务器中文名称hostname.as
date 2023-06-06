string PluginVersion = "1.0";
string PluginAuthor = "紫冰ZB";
string PluginName = "服务器中文名";

void OnPluginInit()
{
    PluginData::SetVersion( PluginVersion );
	PluginData::SetAuthor( PluginAuthor );
	PluginData::SetName( PluginName );
    ThePresident.InfoFeed("插件:"+PluginName+"| 版本:"+PluginVersion+"| 更新:"+Globals.GetCurrentTime(),false);

	SetSName();
}

void ThePresident_OnMapStart()
{
	SetSName();
}

void ThePresident_OnRoundStart()
{
	SetSName();
}

void SetSName()
{
	CASConVarRef@ zb_hostname = ConVar::Find( "hostname" );
	zb_hostname.SetValue( "【紫冰】自娱自乐系列(随机玩法)" );
}