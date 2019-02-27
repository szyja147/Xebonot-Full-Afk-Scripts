local manaBp = 'golden backpack'
local supplies = {'club ring'}

Module.New('move items', function()
	local mainBp = Container.GetFirst()
	for spot, item in mainBp:iItems() do
		if table.contains(supplies, Item.GetName(item.id)) then
			mainBp:MoveItemToContainer(spot, Container.New(manaBp):Index(), 0)
			break
		end
	end
end)
