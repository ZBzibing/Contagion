//修复一些BUG和服务器提供客户端下载,服务器需要设置sv_allowdownload "1"
//联机会起客户端崩溃
class CScriptWeaponGlock : ScriptBase_Weapon
{
	void GetWeaponInformation( WeaponInfo& out info )
	{
		info.szResFile				= "weapon_glock";											// Our weapon resource file
		info.szPrintName			= "GLOCK 18C";												// Our weapon name
		info.szIconName				= "glock18c";												// Our weapon icon (read from the res file)
		info.szIconNameSB			= "glock18c_sb";											// Our weapon icon for Scoreboard (read from the res file)
		info.szWeaponModel_V		= "models/weapons/v_glock18c/v_glock18c.mdl";				// Our weapon model (view)
		info.szWeaponModel_W		= "models/weapons/w_models/w_glock18c/w_glock18c.mdl";		// Our weapon model (world)
		// Particles
		info.szMuzzleFlash_V		= "weapon_muzzle_flash_pistol_FP";
		info.szMuzzleFlash_W		= "weapon_muzzle_flash_pistol";
		info.szEjectBrass			= "weapon_shell_casing_9mm";
		// Melee sound events
		info.szSndMelee				= "Weapon_M1911_MeleeMiss";
		info.szSndMeleeHit			= "Weapon_M1911_MeleeHit";
		info.szSndMeleeHitWorld		= "Weapon_M1911_MeleeHitWorld";
	}

	void Spawn()
	{
		self.SetMeleeDamage( 25 );
		self.SetClipSize( 17 );
		self.SetAmmoType( AMMO_PISTOL );
		self.SetAllowUnderWater( false );
		self.SetIsHeavy( false );
		// Allow attachments
		self.SetAllowAttachmentDrop( true );
		// The model has a silencer attachment, so let's make sure we register it.
		self.SetAttachment( k_eSilencer, false );	// false = no silencer by default
		self.SetAttachment( k_eFlashlight, true );
	}

	// Precache the files, so we don't crash the server,
	// and so that clients can download these.
	void Precache()
	{
		// Wwise uses soundbank, Steam Audio uses sound
		Engine.PrecacheFile( soundbank, "auto/zps_glock18c.txt" );
		Engine.PrecacheFile( soundbank, "zps_glock18c.bnk" );
		// Engine.PrecacheFile( soundbank, "soundbanks/zps_glock18c.txt" );
		

		// Reads from data/weapons
		Engine.PrecacheFile( hud, "weapon_glock.txt" );
		Engine.PrecacheFile( hud, "scripts/weapon_glock.txt" );	
		

		// We just need the .mdl path.
		Engine.PrecacheFile( model, "models/weapons/v_glock18c/v_glock18c.mdl" );
		Engine.PrecacheFile( model, "models/weapons/v_glock18c/v_glock18c.vvd" );
		Engine.PrecacheFile( model, "models/weapons/v_glock18c/v_glock18c.dx90.vtx" );
		Engine.PrecacheFile( model, "models/weapons/w_models/w_glock18c/w_glock18c.mdl" );
		Engine.PrecacheFile( model, "models/weapons/w_models/w_glock18c/w_glock18c.vvd" );
		Engine.PrecacheFile( model, "models/weapons/w_models/w_glock18c/w_glock18c.phy" );
		Engine.PrecacheFile( model, "models/weapons/w_models/w_glock18c/w_glock18c.dx90.vtx" );
		

		// Ditto, It's the same for .vmt files.
		Engine.PrecacheFile( material, "materials/custom/glock18c.vtf" );
		Engine.PrecacheFile( material, "materials/weapons/v_glock18c/frame.vtf" );
		Engine.PrecacheFile( material, "materials/weapons/v_glock18c/slide.vtf" );
	}
	// {
	// 	// Wwise uses soundbank, Steam Audio uses sound
	// 	Engine.PrecacheFile( soundbank, "auto/zps_glock18c.txt" );
	// 	Engine.PrecacheFile( soundbank, "zps_glock18c.bnk" );

	// 	// Reads from data/weapons
	// 	Engine.PrecacheFile( hud, "weapon_glock.txt" );
	// 	Engine.PrecacheFile( hud, "scripts/weapon_glock.txt" );	

	// 	// We just need the .mdl path.
	// 	Engine.PrecacheFile( model, "models/weapons/v_glock18c/v_glock18c.mdl" );
	// 	Engine.PrecacheFile( model, "models/weapons/w_models/w_glock18c/w_glock18c.mdl" );

	// 	// Ditto, It's the same for .vmt files.
	// 	Engine.PrecacheFile( material, "weapons/v_glock18c/frame" );
	// 	Engine.PrecacheFile( material, "weapons/v_glock18c/slide" );
	// }

	// Override PrimaryAttack with our own function
	void PrimaryAttack()
	{
		if ( self.m_iClip <= 0 )
		{
			self.WeaponSound( "Weapon_M1911_FireEmpty" );
			// self.SendWeaponAnim( ACT_VM_DRYFIRE );
			self.m_flNextPrimaryAttack = Globals.GetCurrentTime() + 0.8;
			self.SetWeaponIdleTime( self.m_flNextPrimaryAttack );
			return;
		}
		self.m_iClip--;

		// Our amount of bullets to decrease
		self.FireBullets();
		// If silencer, use this: Weapon_Glock18c_Fire_Silencer
		bool bSilencer = false;
		self.HasAttachment( k_eSilencer, bSilencer );
		self.WeaponSound( bSilencer ? "Weapon_Glock18c_Fire_Silencer" : "Weapon_Glock18c_Fire" );
		// self.SendWeaponAnim( PLAYERANIMEVENT_ATTACK_PRIMARY, ACT_VM_PRIMARYATTACK );

		// Set the new timer
		self.m_flNextPrimaryAttack = Globals.GetCurrentTime() + self.GetFireRate();
		self.SetWeaponIdleTime( self.m_flNextPrimaryAttack );
	}

	// New method.
	// false = STOP (does not call base reload function)
	// true = CONTINUE (will use default reload function)
	bool Reload(bool &in bEmpty)
	{
		if ( self.GetAmmoCount() <= 0 ) return false;
		if ( bEmpty )
			self.WeaponSound( "Weapon_Sig_ReloadEmpty" );
		else
			self.WeaponSound( "Weapon_Sig_Reload" );
		return true;
	}

	void GetAnimationEvent( int &in event )
	{
	}
}

void OnPluginInit()
{
	RegisterGlock();
}

void ThePresident_OnMapStart()
{
	RegisterGlock();
}

void RegisterGlock()
{
	// Register our weapon
	EntityCreator::RegisterCustomWeapon( "weapon_glock", "CScriptWeaponGlock" );
	download();
}

void download()
{
	//sound
	Engine.AddToDownloadTable("soundbanks/auto/zps_glock18c.txt" );
	Engine.AddToDownloadTable("soundbanks/zps_glock18c.bnk" );
	Engine.AddToDownloadTable("soundbanks/zps_glock18c.txt" );
	//data
	Engine.AddToDownloadTable( "data/weapons/weapon_glock.txt" );
	Engine.AddToDownloadTable( "data/weapons/scripts/weapon_glock.txt" );
	//model
	Engine.AddToDownloadTable("models/weapons/v_glock18c/v_glock18c.mdl" );
	Engine.AddToDownloadTable("models/weapons/v_glock18c/v_glock18c.vvd" );
	Engine.AddToDownloadTable("models/weapons/v_glock18c/v_glock18c.dx90.vtx" );
	Engine.AddToDownloadTable("models/weapons/w_models/w_glock18c/w_glock18c.mdl" );
	Engine.AddToDownloadTable("models/weapons/w_models/w_glock18c/w_glock18c.vvd" );
	Engine.AddToDownloadTable("models/weapons/w_models/w_glock18c/w_glock18c.phy" );
	Engine.AddToDownloadTable("models/weapons/w_models/w_glock18c/w_glock18c.dx90.vtx" );
	//vtf
	Engine.AddToDownloadTable("materials/custom/glock18c.vtf" );
	Engine.AddToDownloadTable("materials/custom/glock18c.vmt" );
	Engine.AddToDownloadTable("materials/custom/glock18c_sb.vtf" );
	Engine.AddToDownloadTable("materials/custom/glock18c_sb.vmt" );
	Engine.AddToDownloadTable("materials/weapons/v_glock18c/frame.vtf" );
	Engine.AddToDownloadTable("materials/weapons/v_glock18c/frame.vmt" );
	Engine.AddToDownloadTable("materials/weapons/v_glock18c/slide.vtf" );
	Engine.AddToDownloadTable("materials/weapons/v_glock18c/slide.vmt" );
	Engine.AddToDownloadTable("materials/weapons/v_glock18c/frame_normal.vtf" );
	Engine.AddToDownloadTable("materials/weapons/v_glock18c/slide_normal.vtf" );

}