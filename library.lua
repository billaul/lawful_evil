print("Library Loaded !")

ItemTable = {
  [193] = 'Desc_OreIron_C',     
  [194] = 'Desc_IronIngot_C',     
  [198] = 'Desc_OreCopper_C',   
  [199] = 'Desc_OreBauxite_C',
  [200] = 'Desc_OreGold_C',
  [203] = 'Desc_Sulfur_C',     
  [204] = 'Desc_Stone_C',     
  [205] = 'Desc_Coal_C',    
  [206] = 'Desc_RawQuartz_C',     
  [207] = 'Desc_IronPlateReinforced_C',
  [208] = 'Desc_Cable_C',
  [209] = 'Desc_Wire_C',
  [210] = 'Desc_CopperIngot_C',     
  [211] = 'Desc_Cement_C',     
  [218] = 'Desc_QuartzCrystal_C',
  [219] = 'Desc_SteelPlate_C',
  [220] = 'Desc_CopperSheet_C',
  [221] = 'Desc_SteelPlateReinforced_C',
  [222] = 'Desc_Rubber_C',
  [223] = 'Desc_Motor_C',
  [224] = 'Desc_Plastic_C',
  [225] = 'Desc_ModularFrameHeavy_C',
  [226] = 'Desc_HighSpeedConnector_C',
  [227] = 'Desc_AluminumPlate_C',
  [228] = 'Desc_AluminumCasing_C',
  [229] = 'Desc_ModularFrameLightweight_C',
  [230] = 'Desc_CircuitBoardHighSpeed_C',
  [232] = 'Desc_Rotor_C',
  [233] = 'Desc_ModularFrame_C',
  [237] = 'Desc_SteelIngot_C',
  [243] = 'Desc_CircuitBoard_C',
  [245] = 'Desc_GoldIngot_C',
  [247] = 'Desc_Stator_C',
  [256] = 'Desc_SteelPipe_C',
  [265] = 'Desc_ModularFrameFused_C',
  [267] = 'Desc_ComputerSuper_C',
  [270] = 'Desc_CrystalOscillator_C',   
  [271] = 'Desc_Computer_C',
  [274] = 'Desc_HighSpeedWire_C',
  [275] = 'Desc_Silica_C',  
}

function ItemCode(desc)
  for key, value in pairs(ItemTable) do
    if value == desc then 
      return(key)
    end
  end
  print(desc, 'Not found in ItemTable')
  error("Not found in ItemTable") 
end

function ItemDesc( code )
	  for key, value in pairs(ItemTable) do
    if key == code then 
      return(value)
    end
  end
  print(code, 'Not found in ItemTable')
  error("Not found in ItemTable") 
end

function ItemFromSign(sign)
  return(sign:getPrefabSignData():getIconElement('Icon'))
end


function ItemCodeFromItem(item)
  return(ItemCode(item.type.internalName))
end

function GetAllRequestedItems()
  requests = setmetatable({}, {__index = table})
  for _,proxy in pairs(component.findComponent(classes.Build_StandAloneWidgetSign_Small_C)) do
    sign = component.proxy(proxy)
    desc = ItemDescFromSign(sign)
    requests[desc] = requests[desc] or 0
    requests[desc] = requests[desc] + sign:getPrefabSignData():getTextElement('Name')
  end
  return requests
end

function GetAllAvaillableItems()
  availlables = setmetatable({}, {__index = table})
  for _,proxy in pairs(component.findComponent(classes.Build_StorageCOntainerMk1_C)) do
    storage = component.proxy(proxy)
    for _,inventory in pairs(storage:getInventories()) do
      print(inventory.itemCount)
      if (inventory.itemCount > 0) then
        desc = inventory:getStack(0).item.type.internalName
        availlables[desc] = availlables[desc] or 0
        availlables[desc] = availlables[desc] + inventory.itemCount
      end
    end
  end
  return availlables
end

