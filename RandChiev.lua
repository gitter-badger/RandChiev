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

function checkAchievementParameters(achievementId)
	local id, name, _, completed, _, _, _, _, flags = GetAchievementInfo(achievementId);
	
	if(id == nil) then
		return nil;
	end
	
	
	
	-- Flags 1 = Statistic
	-- Flags 256 and 768 = Realm first
	if (bit.band(flags, 0x00000001) == 1) then
		return nil
	--elseif (completed) then	
	--	return nil;
	end
	
	local categoryId = GetAchievementCategory(achievementId);	
	
	local parentId = getParentCategory(categoryId);

	if not(RandChievOptions[parentId]) then
		return nil;
	end;
	
	print(flags);
	print (bit.band(flags, 0x00000768) == 1);
	
	
	return true;

	
	--if(not RandChievOptions[parentid]) then
	--	return nil;
	--elseif(completed) then
	--	return nil;
	--else
	--	return achievementId;
	--end
end	

function RandChiev_SlashCommand(msg)
	if(msg == "config") then
		InterfaceOptionsFrame_OpenToCategory("RandChiev");
	elseif(msg == "help") then
		print("Help list will come here, with possible commands");
	elseif not(msg == "") then
		print("Hey, that's not a correct command, run |cff145912/rc help|r to get more help");
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
			print("No categories selected, how could I give you an achievement to do now?");
		end


		--repeat x = math.random(1,10000)
	   --until checkAchievementParameters(x) ~= nil
	   --print (GetAchievementLink(x))
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