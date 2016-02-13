function RandChiev_OnEvent()
	if(event == "ADDON_LOADED" and arg1 == "RandChiev") then
		RandChiev_Init();
	end
end

function RandChiev_OnLoad()
	this:RegisterEvent("ADDON_LOADED");
	
	SLASH_RANDCHIEV1 = "/randchiev";
	SLASH_RANDCHIEV2 = "/rc";

	SlashCmdList["RANDCHIEV"] = RandChiev_SlashCommand;
end

function checkAchievementFlags(flags)
	-- Flags 1 = Statistic
	-- Flags 256 and 768 are Realm Firsts
	if(bit.band(flags) == 0x00000001 or bit.band(flags) == 0x00000100 or bit.band(flags) == 0x00000300) then
		return true;
	else
		return false;
	end
end

function checkAchievementParameters(achievementId)
	local id, name, _, completed, _, _, _, _, flags = GetAchievementInfo(achievementId);

	-- No Id found, means no achievement/statistic present
	if(id == nil) then
		return false;
	end
	
	if(checkAchievementFlags(flags)) then
		return false;
	end

	-- TODO: Check this
	local categoryId = GetAchievementCategory(achievementId);	
	
	local parentId = getParentCategory(categoryId);

	if not(RandChievOptions[parentId]) then
		return false;
	end
	
	-- Check if already completed
	if (completed) then
		return false;
	end	
	
	return true;
end	

function RandChiev_FindAchievement()
	local i = 0;
	while i < 100000 do
		x = math.random(1,10000)
		if(checkAchievementParameters(x)) then
			print (GetAchievementLink(x));

			--TODO: Add option in config to enable/disable tracking
			--AddTrackedAchievement(x);
			return true;
		end
		i = i + 1;
	end
	return false;
end

function RandChiev_SlashCommand(msg)
	if(msg == "config") then
		InterfaceOptionsFrame_OpenToCategory("RandChiev");
	elseif(msg == "help") then
		print("RandChiev help:\n/rc or /randchiev: Gets an achievement to do.\n/rc config: Opens the config screen.\n/rc help: This help text.");
	elseif not(msg == "") then
		print("|cffff0000Hey, that's not a correct command, run |cff145912/rc help |cffff0000to get more help.|r");
	else
		local anySelected = false;

		--TODO: Check for categories (all done)
		for _, value in pairs(RandChievOptions) do
			if(value) then
				anySelected = true;
				--TODO: Maybe check count here
				break;
			end
		end

		if not(anySelected) then
			print("|cffec1919No categories selected, how could I give you an achievement to do now?|r");
		else 
			if not(RandChiev_FindAchievement()) then
				print("Oops, it seems RandChiev could not find any achievements to do, you probably have done a lot already, congratulations!! (Running RandChiev again might give better results)");
			end
		end	
	end
end

function RandChiev_Init()
	if (RandChievOptions == nil) then
		RandChiev_FreshOptions();
	end
	
	RandChievOptions_Init();
end

function getParentCategory(id)
	local _, parentId = GetCategoryInfo(id);
	
	if(parentId == -1) then
		return id;
	else
		return getParentCategory(parentId);
	end
end

function checkCategory(id) 
	local _, parentId = GetCategoryInfo(id);
	
	if(parentId == -1) then
		return id;
	else 
		return nil;
	end
end

function RandChiev_FreshOptions()
	RandChievOptions = {};
	
	for key, value in pairs(GetCategoryList()) do
		if (checkCategory(value)) then
			RandChievOptions[value] =  true;
		end
	end
end

function pairsByKeys (t, f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0      -- iterator variable
      local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
end