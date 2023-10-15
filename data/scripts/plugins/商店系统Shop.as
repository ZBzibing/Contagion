string PluginVersion = "1.0";
string PluginAuthor = "紫冰ZB";
string PluginName = "商店菜单";

int mysterypoint = 100;
int point;
int mul =10*5;
int iMaxPlayers = Globals.GetMaxClients();
int i = 0;
uint n = 0;
array<int> wj;
array<int> kill_inf;

void OnPluginInit()
{
     PluginData::SetVersion( PluginVersion );
	PluginData::SetAuthor( PluginAuthor );
	PluginData::SetName( PluginName );
    ThePresident.InfoFeed("插件:"+PluginName+"| 版本:"+PluginVersion+"| 更新:"+Globals.GetCurrentTime(),false);

    Events::Player::OnPlayerConnected.Hook( @OnPlayerConnected_GG );    //玩家已经连接服务器
	Events::Player::OnMenuExecuted.Hook( @OnMenuExecuted );	//玩家使用菜单
    Events::Player::PlayerSay.Hook( @OnPlayerSay ); //玩家使用对话框
	Events::Infected::OnInfectedSpawned.Hook( @OnInfectedSpawned ); //感染者出生
    Events::Infected::OnInfectedKilled.Hook( @OnInfectedKilled );	//感染者死亡

    
	Engine.EnableCustomSettings( true );
	
}

void ThePresident_OnMapStart()
{
	Engine.PrecacheFile( model, "models/survivors/male/sebastian.mdl" );	//白土匪
}

void ThePresident_OnRoundStart()
{
	Engine.PrecacheFile( model, "models/survivors/male/sebastian.mdl" );	//白土匪
}

CBaseEntity@ ToBaseEntity( CTerrorPlayer@ pPlayer )
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CBaseEntity@ pEntityPlayer = pBasePlayer.opCast();
	return pEntityPlayer;
}

//玩家已连接服务器
HookReturnCode OnPlayerConnected_GG(CTerrorPlayer@ pPlayer)
{
	// CBaseEntity @pAttacker = DamageInfo.GetAttacker();
    CBaseEntity @pBase = ToBaseEntity( pPlayer );
	if ( pBase is null ) return HOOK_CONTINUE;
	int iIndex = pBase.entindex();
	return HOOK_CONTINUE;
}

//-----------------------------------------------------------玩家使用对话框-------------------------------------------------------------//
HookReturnCode OnPlayerSay( CTerrorPlayer@ pPlayer, CASCommand@ pArgs )
{
		string arg1 = pArgs.Arg( 1 );   //0,管理员使用.1,玩家使用
	if ( Utils.StrEql( arg1, "!sur" ) || Utils.StrEql( arg1, "/s" ))
	{
		CBaseEntity @pBase = ToBaseEntity( pPlayer );
		// CheckStatus( pBase.entindex(), true );

		Chat.PrintToChat(pPlayer,"{default}等级{white}: {gold}" );
		return HOOK_HANDLED;
	}
	if ( Utils.StrEql( arg1, "!b" ) || Utils.StrEql( arg1, "!buy" ) || Utils.StrEql( arg1, "!m" ) || Utils.StrEql( arg1, "!shop" ))
	{
		CTerrorWeapon@ pWeapon = pPlayer.GetCurrentWeapon();
		CBasePlayer@ pBasePlayer = pPlayer.opCast();
		// if (pPlayer.GetScore() >= 20)
		// {
			

		// 	// pPlayer.GiveWeapon( "scythe" );
		// 	pWeapon.UpgradeModule( SET, k_eDissolve );
		// 	pPlayer.AddScore(-20);
		// }
		// else
		// 	Chat.PrintToChat(pPlayer,"{default}需要50点,当前击杀点不足{white}: {gold}"+pPlayer.GetScore() );

		shopmenu(pPlayer);
		Chat.PrintToChat(pPlayer,"{purple}[紫冰] {red}注意:{green}选购武器&弹药需要保持3号格子为空.");
		return HOOK_CONTINUE;
	}
    if ( Utils.StrEql( arg1, "!p" ) && pPlayer.GetTeamNumber()==TEAM_SURVIVOR)    //统计当前存活的玩家点数
	{
		
		pPlayer.AddScore(1000);
		Chat.PrintToChat(all,pPlayer.GetPlayerName()+"点数"+pPlayer.GetScore());
		// for(int i = 1;i<=Globals.GetMaxClients();i++)
		// {
		// 	CTerrorPlayer@ pBasePlayer = ToTerrorPlayer(i);
		// 	pBasePlayer.AddScore(100);
			// Chat.PrintToChat(all,pBasePlayer.GetPlayerName()+"点数"+pBasePlayer.GetScore());
		// }
		
		return HOOK_HANDLED;
	}
	return HOOK_CONTINUE;
}

void shopmenu(CTerrorPlayer@ pPlayer)
{
	Menu pMenu;
	pMenu.SetID("zb_menu");	//菜单ID
	pMenu.SetTitle("商店菜单 ShopMenu "+PluginVersion+"\n程序制作:紫冰\nQQ群:208327622");
	pMenu.AddItem("武器选购 Weapon");
	pMenu.AddItem("配件组装 Attach");
	pMenu.AddItem("弹药补给 AMMO");
	pMenu.AddItem("属性升级 Upgrade");
	if(mysterypoint>=1)
	{
		pMenu.AddItem("神秘商店(需解锁) Mystery(Lock)");
	}
	else
	{
		pMenu.AddItem("神秘商店 Mystery");
	}
	//菜单超过数量显示下一页
	pMenu.SetExit(false,"zb_menu");
	pMenu.Display(pPlayer, 20);
}

void menu_wp(CTerrorPlayer@ pPlayer)
{
	Menu pMenu;
	pMenu.SetID("wp_menu");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n-------------------------\n武器菜单 Weapon");
	pMenu.AddItem("近战 Melee");
	pMenu.AddItem("远程 Longrange");
	pMenu.AddItem("手枪 Pistols");
	pMenu.AddItem("微冲 MSG");
	pMenu.AddItem("霰弹 ShotGuns");
	pMenu.AddItem("步枪 Rifles");
	pMenu.AddItem("猎枪 Hunting");
	pMenu.SetBack( true );
	// pMenu.SetExit( false, "wp_menu");
	pMenu.Display(pPlayer, 20);
}

void menu_wp_Melee1(CTerrorPlayer@ pPlayer)	//近战武器1
{
	Menu pMenu;
	pMenu.SetID("wp_Melee1");
	pMenu.SetTitle("近战武器 Melee($"+pPlayer.GetScore()+")");
	pMenu.AddItem("匕首 $"+150/mul+" Kabar");
	pMenu.AddItem("木棍 $"+150/mul+" Baseballbat");
	pMenu.AddItem("键盘 $"+150/mul+" Keyboard");
	pMenu.AddItem("球杆 $"+160/mul+" Golfclub");
	pMenu.AddItem("铁棍 $"+160/mul+" Baseball_metal");
	pMenu.AddItem("吉他 $"+170/mul+" Guitar");
	pMenu.AddItem("扳手 $"+170/mul+" Wrench");
	pMenu.SetBack( true );
	pMenu.SetNext( true );
	// pMenu.SetExit( false ,"wp_Melee1" );
	
	pMenu.Display(pPlayer, 20);
}

void menu_wp_Melee2(CTerrorPlayer@ pPlayer)	//近战武器2
{
	Menu pMenu;
	pMenu.SetID("wp_Melee2");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n-------------------------\n近战武器 Melee");
	pMenu.AddItem("班琴 $"+180/mul+" Banjo");
	pMenu.AddItem("弯刀 $"+200/mul+" Machete");
	pMenu.AddItem("撬棍 $"+200/mul+" Crowbar");
	pMenu.AddItem("斧头 $"+220/mul+" FireAxe");
	pMenu.AddItem("镰刀 $"+250/mul+" Scythe");
	pMenu.AddItem("大锤 $"+300/mul+" Hammer");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_wp_Longrange(CTerrorPlayer@ pPlayer)	//远程武器
{
	Menu pMenu;
	pMenu.SetID("wp_Longrange");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n远程武器 Longrange");
	pMenu.AddItem("十字弩 $"+500/mul+" Crossbow");
	pMenu.AddItem("复合弓 $"+900/mul+" Compbow");
	pMenu.AddItem("手榴弹 $"+150/mul+" Grenade");
	pMenu.AddItem("遥控雷 $"+600/mul+" Ied");
	pMenu.AddItem("榴弹炮 $"+2500/mul+" launcher");
	pMenu.AddItem("喷火器 $"+3000/mul+" Flame");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_wp_Pistols(CTerrorPlayer@ pPlayer)
{
	Menu pMenu;
	pMenu.SetID("wp_Pistols");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n-------------------------\n手枪系列 Pistols");
	pMenu.AddItem("西格绍 $"+150/mul+" Sig");
	pMenu.AddItem("柯尔特 $"+250/mul+" 1911");
	pMenu.AddItem("左轮枪 $"+300/mul+" Revolver");
	pMenu.AddItem("马格南 $"+400/mul+" Magnum");
	pMenu.AddItem("沙之鹰 $"+1500/mul+" Eagle");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_wp_MSG(CTerrorPlayer@ pPlayer)
{
	Menu pMenu;
	pMenu.SetID("wp_MSG");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n-------------------------\n微型冲锋枪 MSG");
	pMenu.AddItem("冲锋枪 $"+350/mul+" KG9");
	pMenu.AddItem("冲锋枪 $"+400/mul+" MP5K");
	pMenu.AddItem("冲锋枪 $"+500/mul+" MAC-10");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_wp_ShotGuns(CTerrorPlayer@ pPlayer)
{
	Menu pMenu;
	pMenu.SetID("wp_ShotGuns");	
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n霰弹枪 ShotGuns");
	pMenu.AddItem("复合枪 $"+580/mul+" Overunder");
	pMenu.AddItem("莫斯伯 $"+600/mul+" Mossberg");
	pMenu.AddItem("雷明顿 $"+800/mul+" Remington");
	pMenu.AddItem("伯奈利 $"+1000/mul+" Autoshotgun");
	pMenu.AddItem("双管枪 $"+3000/mul+" Doublebarrel");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_wp_Rifles(CTerrorPlayer@ pPlayer)
{
	Menu pMenu;
	pMenu.SetID("wp_Rifles");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n-------------------------\n步枪 Rifles");
	pMenu.AddItem("AK步枪  $"+700/mul+" AK74U");
	pMenu.AddItem("M16步枪 $"+800/mul+" AR15");
	pMenu.AddItem("雷明顿  $"+900/mul+" Acr");
	pMenu.AddItem("SCAR步枪	$"+1200/mul+" SCAR");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_wp_Hunting(CTerrorPlayer@ pPlayer)
{
	Menu pMenu;
	pMenu.SetID("wp_Hunting");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n-------------------------\n猎枪 Hunting");
	pMenu.AddItem("勃朗宁 $"+500/mul+" BLR");
	pMenu.AddItem("加兰德 $"+550/mul+" M1garand");
	pMenu.AddItem("雷明顿 $"+680/mul+" Sniper");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_attach(CTerrorPlayer@ pPlayer)	//武器配件
{
	Menu pMenu;
	pMenu.SetID("Attach");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n配件 Attach");
	pMenu.AddItem("手电 $"+1500/mul+" Flashlight");
	pMenu.AddItem("消音 $"+2000/mul+" Silencer");
	pMenu.AddItem("倍镜 $"+2800/mul+" Scope");
	pMenu.AddItem("红点 $"+3200/mul+" Reddot");
	pMenu.AddItem("全息 $"+3500/mul+" Holosight");
	pMenu.AddItem("导轨 $"+4000/mul+" Rail");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_ammo(CTerrorPlayer@ pPlayer)	//弹药补给
{
	Menu pMenu;
	pMenu.SetID("ammo_Resource");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n-------------------------\n弹药补给 Ammo&Supply");
	pMenu.AddItem("弹药 $"+100/mul+" Ammo");
	pMenu.AddItem("疫苗 $"+80/mul+" Inoculator");
	pMenu.AddItem("药包 $"+100/mul+" Firstaid");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_upgrade(CTerrorPlayer@ pPlayer)	//附魔属性
{
	Menu pMenu;
	pMenu.SetID("Upgrade");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n附魔属性 Upgrade");
	pMenu.AddItem("手电 $"+1000/mul+" Flashlight");
	pMenu.AddItem("双倍 $"+5500/mul+" DoubleDamage");
	pMenu.AddItem("火焰 $"+8500/mul+" FireDamage");
	pMenu.AddItem("溶解 $"+10000/mul+" Dissolve");
	pMenu.AddItem("爆炸 $"+12000/mul+" Explosive");
	pMenu.AddItem("奖励 $"+13000/mul+" MoneyBoost");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_mystery(CTerrorPlayer@ pPlayer)	//神秘商店
{
	Menu pMenu;
	pMenu.SetID("Mystery");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n神秘商店 Mystery");
	pMenu.AddItem("人物 Skin");
	pMenu.AddItem("帽子 Hat");
	pMenu.AddItem("武器 Weapon");
	pMenu.AddItem("能力 Skill");
	pMenu.AddItem("道具 Tools");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_mystery_wp(CTerrorPlayer@ pPlayer)	//神秘商店
{
	Menu pMenu;
	pMenu.SetID("Mystery_wp");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n神秘武器 Weapon");
	pMenu.AddItem("特殊人物 $"+1000/mul+" Skin");
	pMenu.AddItem("帽子装饰 $"+1000/mul+" Hat");
	pMenu.AddItem("神秘武器 $"+1000/mul+" Weapon");
	pMenu.AddItem("神秘能力 $"+1000/mul+" Skill");
	pMenu.AddItem("通关道具 $"+1000/mul+" Tools");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

void menu_mystery_lock(CTerrorPlayer@ pPlayer)	//神秘商店解锁
{
	Menu pMenu;
	pMenu.SetID("MysteryLock");
	pMenu.SetTitle("当前拥有: $"+pPlayer.GetScore()+" 点\n警告!此选项只为增加娱乐性\n如果不喜请勿开启\n-----解锁还需 "+ mysterypoint +" 点-----.");
	pMenu.AddItem("捐献 5点  5 Point");
	pMenu.AddItem("捐献10点 10 Point");
	pMenu.AddItem("捐献20点 20 Point");
	pMenu.AddItem("捐献50点 50 Point");
	pMenu.SetBack( true );
	pMenu.Display(pPlayer, 20);
}

//-----------------------------------------------------------菜单使用-------------------------------------------------------------//
HookReturnCode OnMenuExecuted(CTerrorPlayer@ pPlayer, const string &in szID, int &in iValue)
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CTerrorWeapon@ pWeapon = pPlayer.GetCurrentWeapon();
	CASCommand @pArgs = StringToArgSplit( szID, ";" );
	string arg0 = pArgs.Arg( 0 );	// MainID
	if ( Utils.StrEql( szID, "zb_menu" ) )	//判断szID,对应菜单所要执行的命令
	switch( iValue )
	{
		case 1:menu_wp(pPlayer);break;	//对照zb_menu列表中执行的命令
		case 2:menu_attach(pPlayer);break;
		case 3:menu_ammo(pPlayer);break;
		case 4:menu_upgrade(pPlayer);break;
		case 5:
		{
			if(mysterypoint>=1)
			menu_mystery_lock(pPlayer);
			else
			menu_mystery(pPlayer);
		}
		break;
	}

	else if ( Utils.StrEql( szID, "wp_menu" ) )
	switch( iValue )
	{
		case 1:menu_wp_Melee1(pPlayer);break;
		case 2:menu_wp_Longrange(pPlayer);break;
		case 3:menu_wp_Pistols(pPlayer);break;
		case 4:menu_wp_MSG(pPlayer);break;
		case 5:menu_wp_ShotGuns(pPlayer);break;
		case 6:menu_wp_Rifles(pPlayer);break;
		case 7:menu_wp_Hunting(pPlayer);break;
		case 8:shopmenu(pPlayer);break;
	}

	else if ( Utils.StrEql( szID, "wp_Melee1" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 150/mul;
			if(pPlayer.GetScore()>point)
			{
				pPlayer.GiveWeapon( "kabar" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 150/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Baseballbat" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 150/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Keyboard" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 150/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Golfclub" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 5:
		{
			point = 160/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Baseballbat_metal" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 6:
		{
			point = 170/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "guitar" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 7:
		{
			point = 170/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Wrench" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:menu_wp(pPlayer);break;
		case 9:menu_wp_Melee2(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "wp_Melee2" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 180/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "banjo" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 200/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "machete" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 200/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "crowbar" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 220/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Fireaxe" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 5:
		{
			point = 250/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "scythe" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 6:
		{
			point = 300/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "sledgehammer" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:menu_wp_Melee1(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "wp_Longrange" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "crossbow" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 900/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "compbow" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 150/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Grenade" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 600/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Ied" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 5:
		{
			point = 2500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "grenadelauncher" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 6:
		{
			point = 3000/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "flamethrower" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
	}

	if ( Utils.StrEql( szID, "wp_Pistols" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 150/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "sig" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 250/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "1911" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 300/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "357" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 400/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "revolver" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 5:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "handcannon" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:menu_wp(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "wp_MSG" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "kg9" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "mp5k" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "mac10" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:menu_wp(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "wp_ShotGuns" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 580/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Overunder" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 600/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Mossberg" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 800/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Remington870" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 1000/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Autoshotgun" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 5:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "Doublebarrel" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:menu_wp(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "wp_Rifles" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 700/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "ak74" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 800/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "ar15" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 900/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "acr" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 1200/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "scar" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:menu_wp(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "wp_Hunting" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "blr" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 550/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "m1garand" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 680/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "sniper" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:menu_wp(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "Attach" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}当前货源不足");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}当前货源不足");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}当前货源不足");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}当前货源不足");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 5:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}当前货源不足");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 6:
		{
			point = 1500/mul;
			if(pPlayer.GetScore()>=point)
			{
				Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}当前货源不足");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:shopmenu(pPlayer);break;
		
	}

	if ( Utils.StrEql( szID, "ammo_Resource" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 100/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "ammo" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 80/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "inoculator" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 100/mul;
			if(pPlayer.GetScore()>=point)
			{
				pPlayer.GiveWeapon( "firstaid" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:shopmenu(pPlayer);break;
	}

	

	if ( Utils.StrEql( szID, "Upgrade" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 1000/mul;
			if(pPlayer.GetScore()>=point)
			{
				pWeapon.UpgradeModule( SET, k_eFlashlight);
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		{
			point = 5500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pWeapon.UpgradeModule( SET, k_eDoubleDamage);
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 3:
		{
			point = 8500/mul;
			if(pPlayer.GetScore()>=point)
			{
				pWeapon.UpgradeModule( SET, k_eFireDamage);
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 4:
		{
			point = 10000/mul;
			if(pPlayer.GetScore()>=point)
			{
				pWeapon.UpgradeModule( SET, k_eDissolve);
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 5:
		{
			point = 12000/mul;
			if(pPlayer.GetScore()>=point)
			{
				pWeapon.UpgradeModule( SET, k_eExplosive);
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 6:
		{
			point = 13000/mul;
			if(pPlayer.GetScore()>=point)
			{
				pWeapon.UpgradeModule( SET, k_eMoneyBoost);
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:shopmenu(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "Mystery" ) )
	switch( iValue )
	{
		case 1:
		{
			point = 1000/mul;
			if(pPlayer.GetScore()>=point)
			{
				CBaseEntity @pEnt = ToBaseEntity( pPlayer );
				pEnt.SetModel( "models/survivors/male/sebastian.mdl" );
				pPlayer.AddScore(-point);
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		{
			if(pPlayer.GetScore()>=5)
				pPlayer.GiveWeapon( "fingergun" );
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.{red}"+pPlayer.GetScore()+"{green}/"+ point);
		}
		break;
		case 8:shopmenu(pPlayer);break;
	}

	if ( Utils.StrEql( szID, "MysteryLock" ) )
	switch( iValue )
	{
		case 1:
		{
			if(pPlayer.GetScore()>=5)
			{
				pPlayer.AddScore(-5);
				mysterypoint -= 5;
				Chat.PrintToChat(all,"{purple}[紫冰] {azure}"+pPlayer.GetPlayerName()+"{white}捐献了{gold} 5 {white}点数.解锁还需 {red}"+mysterypoint+" {white}点");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.当前:{red} "+pPlayer.GetScore()+" {white}点");
		}
		break;
		case 2:
		{
			if(pPlayer.GetScore()>=10)
			{
				pPlayer.AddScore(-10);
				mysterypoint -= 10;
				Chat.PrintToChat(all,"{purple}[紫冰] {azure}"+pPlayer.GetPlayerName()+"{white}捐献了{gold} 10 {white}点数.解锁还需 {red}"+mysterypoint+" {white}点");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.当前:{red} "+pPlayer.GetScore()+" {white}点");
		}
		break;
		case 3:
		{
			if(pPlayer.GetScore()>=20)
			{
				pPlayer.AddScore(-20);
				mysterypoint -= 20;
				Chat.PrintToChat(all,"{purple}[紫冰] {azure}"+pPlayer.GetPlayerName()+"{white}捐献了{gold} 20 {white}点数.解锁还需 {red}"+mysterypoint+" {white}点");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.当前:{red} "+pPlayer.GetScore()+" {white}点");
		}
		break;
		case 4:
		{
			if(pPlayer.GetScore()>=50)
			{
				pPlayer.AddScore(-50);
				mysterypoint -= 50;
				Chat.PrintToChat(all,"{purple}[紫冰] {azure}"+pPlayer.GetPlayerName()+"{white}捐献了{gold} 50 {white}点数.解锁还需 {red}"+mysterypoint+" {white}点");
			}
			else
			Chat.PrintToChat(pPlayer,"{purple}[紫冰] {white}点数不足.当前:{red} "+pPlayer.GetScore()+" {white}点");
		}
		break;
		case 8:shopmenu(pPlayer);break;
	}
	return HOOK_CONTINUE;
}

//-----------------------------------------------------------感染者出生-------------------------------------------------------------//
HookReturnCode OnInfectedSpawned(Infected@ pInfected)
{
	int iAnimSet = 2;
	pInfected.SetAnimationSet( iAnimSet );
	AddHalloweenCostume( pInfected );
    return HOOK_CONTINUE;
}
void AddHalloweenCostume( Infected@ pInfected )
{
	if ( pInfected is null ) return;
	Utils.CosmeticWear( pInfected, "models/halloween/w_head_pumpkin.mdl" );
}

//-----------------------------------------------------------感染者死亡-------------------------------------------------------------//
HookReturnCode OnInfectedKilled(Infected@ pInfected, CTakeDamageInfo &in DamageInfo)
{

    CBaseEntity @pAttacker = DamageInfo.GetAttacker();	//获取攻击者信息
    CTerrorPlayer @pTerror = ToTerrorPlayer(pAttacker);	//转换攻击者为玩家属性
	CBasePlayer@ pBasePlayer = pTerror.opCast();

	// if ( pTerror.GetScore() !=0 )
	// 		pTerror.AddScore(1);
	// 	else
	// 		//pTerror.AddScore(-1);
	int score = pTerror.GetScore();
	// score += 1000;
	pTerror.AddScore( 5 );
    // Chat.PrintToChat( all, "{purple}[紫冰] {white}玩家{azure}:"+ pTerror.GetPlayerName() +"{white}: {green}"+ pTerror.GetScore()+"{white} 点." );
	return HOOK_CONTINUE;
}

int kills;
bool melee;