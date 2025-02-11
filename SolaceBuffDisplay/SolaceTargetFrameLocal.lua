SOLACE_SHOWBUFFS_HELP="Sets the number of buffs to show on your target.  Valid numbers are 0-32.";
SOLACE_SHOWBUFFS="Visible buffs now set to ";
SOLACE_SHOWDEBUFFS_HELP="Sets the number of debuffs to show on your target.  Valid numbers are 0-40.";
SOLACE_SHOWDEBUFFS="Visible debuffs now set to ";
SOLACE_SHOWOWNON="Player-cast buffs and debuffs are shown bigger than those cast by others."
SOLACE_SHOWOWNOFF="Player-cast buffs and debuffs are shown the same size as those cast by others."
SOLACE_SHOWOWN_HELP="Toggles whether player-cast buffs are shown bigger than those cast by others. ( on | off)";
SOLACE_NUMROW="Number of buffs or debuffs in a full row set to ";
SOLACE_NUMROW_HELP="Sets the number of buffs or debuffs should appear in a full row.  Valid numbers are 1-32."
SOLACE_SHOWOWNCURRENT="Currently ";
SOLACETARGETFRAME_WELCOME="SBD::SolaceTargetFrame-".._G["SolaceTargetFrame"].version.." loaded.  Type /solace for help.";

if ( GetLocale() == "zhTW" ) then
	SOLACE_SHOWBUFFS_HELP="設定目標可顯示的BUFF數量. ( 0-32 )";
	SOLACE_SHOWBUFFS="可顯示的BUFF數量設定為 ";
	SOLACE_SHOWDEBUFFS_HELP="設定目標可顯示的DEBUFF數量. ( 0-40 )";
	SOLACE_SHOWDEBUFFS="可顯示的DEBUFF數量設定為 ";
	SOLACE_SHOWOWNON="放大自己施放的BUFF/DEBUFF圖示."
	SOLACE_SHOWOWNOFF="不放大自己施放的BUFF/DEBUFF圖示."
	SOLACE_SHOWOWN_HELP="設定是否放大顯示自己施放的BUFF/DEBUFF. ( on | off)";
	SOLACE_NUMROW="設定可顯示BUFF/DEBUFF的數量為 ";
	SOLACE_NUMROW_HELP="設定可顯示的BUFF/DEBUFF數量.  ( 1-32 )"
	SOLACE_SHOWOWNCURRENT="目前 ";
	SOLACETARGETFRAME_WELCOME="SBD::SolaceTargetFrame 已載入.  輸入 /solace 顯示說明.";
end

if ( GetLocale() == "frFR" ) then
	--Please add localizations for the variables above if you speak French!
elseif ( GetLocale() == "deDE" ) then
	--Please add localizations for the variables above if you speak German!
elseif ( GetLocale() == "esES" ) then
	--Please add localizations for the variables above if you speak Spanish!
end
