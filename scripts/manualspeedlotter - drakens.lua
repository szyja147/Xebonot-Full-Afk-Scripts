local CONFIG = {
    {BP = 'golden backpack', -- BP name or index
    LIST = 
        {'zaoan legs', 'zaoan armor', 'zaoan shoes', 'ring of the sky', 'focus cape',
        'drakinata', 'weavers wandwip',
        'purple robe', 'small topaz',
        'poisoned fang', 'minotaur horn', 'zaoan robe', 'knight armor',
        'stone skin amulet', 'titan axe', 'mooh\'tah shell', 'mooh\'tah plate', 'small sapphire', 'mino shield'}},
    {BP = 'brocade backpack', -- BP name or index
    LIST = 
        {'platinum coin', 'gold coin', 'warmasters wristguardss.', 'small emerald', 'draken sulphur', 'small sapphire', 'winged tail', 'life crystal'}}
}
  
for i = 1, #CONFIG do
    for j = 1, #CONFIG[i]['LIST'] do
        CONFIG[i]['LIST'][j] = Item.GetItemIDFromDualInput(CONFIG[i]['LIST'][j])
    end
end
  
local bodies = {'The', 'Demonic', 'Dead', 'Slain', 'Dissolved', 'Remains', 'Elemental'}
 
function Container:isFull(id)
    for spot = 0, self:ItemCount()-1 do
        local data = self:GetItemData(spot)
        if (isItemStackable(id) and data.id == id and data.count ~= 100) then
            return false
        elseif not isItemStackable(id) then
            return getContainerItemCount(self._index) == getContainerItemCapacity(self._index)
        end
    end
end
 
while (true) do
    for i = #Container.GetAll()-1, 0, -1 do
        local c = Container.New(i)
        if (c:isOpen() and table.contains(bodies, string.match(c:Name(), '%a+'))) then
            for j = 1, #CONFIG do
                for spot = c:ItemCount()-1, 0, -1 do
                    local spotData = c:GetItemData(spot)
                    if table.contains(CONFIG[j]['LIST'], spotData.id) then
                        local desti = Container.New(CONFIG[j]['BP'])
                        if (Self.Cap() > (Item.GetWeight(spotData.id)*spotData.count) and not desti:isFull(spotData.id)) then
                            if isItemStackable(spotData.id) then
                                c:MoveItemToContainer(spot, desti:Index(), 0)
                            else
                                c:MoveItemToContainer(spot, desti:Index(), desti:ItemCount())
                            end
                        elseif (desti:isFull(spotData.id) and Item.isContainer(desti:GetItemData(desti:ItemCount()-1).id)) then
                            desti:UseItem(desti:ItemCount()-1, true)
                        end
                    end
                end
            end
        end
    end
    wait(10)
end