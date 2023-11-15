string PluginVersion = "1.0";
string PluginAuthor = "紫冰ZB";
string PluginName = "无限弹夹 unlimited clip";

CASConVar@ zb_switch = null;    //1.定义开关

bool zbswitch(){ return zb_switch.GetBool(); }  //3.定义一个判断指令参数条件

void OnPluginInit()
{
    PluginData::SetVersion( PluginVersion );
	PluginData::SetAuthor( PluginAuthor );
	PluginData::SetName( PluginName );
    ThePresident.InfoFeed("插件:"+PluginName+"| 版本:"+PluginVersion+"| 更新:"+Globals.GetCurrentTime(),true);

    Console(); //指令加载
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
    CASConVarRef@ infinite_collected_ammo = ConVar::Find( "sv_infinite_collected_ammo" );
    if ( infinite_collected_ammo is null ) return;
    infinite_collected_ammo.SetValue( "1" );
}
