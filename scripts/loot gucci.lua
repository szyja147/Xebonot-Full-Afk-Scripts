local CONFIG = {
    {BP = 'zaoan chess box', -- BP name or index
    LIST = 
        {'primatic armor', '', 'soft boots', 'dept lorica', 'butcher/s axe',
        'prismatic legs', 'firesoul tabard', 'crystal coin', 'crystal coin/s', '',
        'frostsoul tabard', 'thundersoul tabard',
        'crossbow of mayhem', 'bow of mayhem', 'umbral master bow', 'rift lance', 'skullcracker armor',
        'underworld rod', 'golden legs', 'rift shield', 'golden armor', 'magic plate armor', 'wand of voodoo', 'demon shield', 'mastermind shield', 'terra mantle', 'dreaded cleaver', 'skull staff', 'dreaded cleaver', 'Spellweaver/s robe', 'dragonbone staff', 'knight armor','mercenary sword'}},
    {BP = 'camouflage backpack', -- BP name or index
    LIST = 
        {'platinum coin', 'gold coin', 'demonic essence', 'cluster of solace', 'vexclaw talon', 'small sapphire', 'gold ingot', 'fur boots', 'unholy bone', 'small topaz', 'small emerald', 'small ruby', 'white pearl', 'black pearl', 'necromantic rust', 'giant shimmering pearl', 'boots of haste'}}
}
  
for i = 1, #CONFIG do
    for j = 1, #CONFIG[i]['LIST'] do
        CONFIG[i]['LIST'][j] = Item.GetItemIDFromDualInput(CONFIG[i]['LIST'][j])
    end
end
  
local bodies = {'The', 'Demonic', 'Dead', 'Slain', 'Dissolved', 'Remains', 'Wooden floor', 'Wooden', 'Floor', 'Browse', 'Browse Field', 'Field', 'Elemental'}
 
function Container:isFull(id)
    for spot = 0, self:ItemCount()-1 do
        local data = self:GetItemData(spot)
        if (isItemStackable(id) and data.id == id and data.count ~= 5) then
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
    wait(5)
end