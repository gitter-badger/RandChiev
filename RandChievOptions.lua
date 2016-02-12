function RandChievOptions_OnLoad(panel)
	panel.name = "RandChiev";
	panel.default = RandChievOptions_Reset;
	InterfaceOptions_AddCategory(panel);
end

function RandChievOptions_Reset()
	RandChiev_FreshOptions();
end

function RandChievOptions_Init()
	local position = -40;

	for key,value in pairsByKeys(RandChievOptions, SortByNameFunction) do
		mybutton = CreateFrame("CheckButton", key, RandChievOptionsFrame, "InterfaceOptionsSmallCheckButtonTemplate");
		mybutton:SetPoint("TOPLEFT", 15, position);

		getglobal(mybutton:GetName().."Text"):SetText(GetCategoryInfo(key));
		
		mybutton:SetChecked(value);
		mybutton:SetAttribute("categoryId", key);
		mybutton:SetScript("OnClick", function(self, button)
			RandChievOptions[key] = not RandChievOptions[key];
		end)
		
		position = position - 25;
	end
end

function SortByNameFunction(a, b)
	local nameA = GetCategoryInfo(a);
	local nameB = GetCategoryInfo(b); 

	return nameA < nameB;
end