-- 此文件工具自动生成，不要修改
---@class cfg_equip_gem_column
---道具id
---@field id number @id column=1 A
---策划用
---@field gemName string @宝石名称 column=2 B
---所属组#宝石等级
---1 火 2 水 3冰 4风 5 雷 6 土
---@field gemBelong IntList @宝石归属 column=3 C
---属性#数值|属性#数值
---@field gemAtt IntListList @宝石属性 column=4 D
---引用strpart
---@field wearbarPos IntList @可镶嵌的穿戴部位 column=5 E
---对应萤石镶嵌在装备里的位置
---@field wearbar IntList @萤石位置 column=6 F
---在穿戴栏显示的颜色，填图片命名
---@field gemColorImg string @宝石颜色 column=7 G

local local_wearbarPos = {
    wearbarPos_1={1,2,3},
    wearbarPos_2={4,5,6,7,8},

}

local local_wearbar = {
    wearbar_1={1,2,3},

}

local cfg_equip_gem =
{
	{id=50031101, gemName="荧光宝石1级(火)", gemBelong={1,1}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031102, gemName="荧光宝石2级(火)", gemBelong={1,2}, gemAtt={{200031,1},{213021,8},{200021,32},{200011,22},{314023,22},{302042,4100}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031103, gemName="荧光宝石3级(火)", gemBelong={1,3}, gemAtt={{200031,1},{213021,9},{200021,35},{200011,25},{314023,25},{302042,4200}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031104, gemName="荧光宝石4级(火)", gemBelong={1,4}, gemAtt={{200031,1},{213021,10},{200021,40},{200011,30},{314023,30},{302042,4300}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031105, gemName="荧光宝石5级(火)", gemBelong={1,5}, gemAtt={{200031,2},{213021,11},{200021,45},{200011,35},{314023,35},{302042,4400}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031106, gemName="荧光宝石6级(火)", gemBelong={1,6}, gemAtt={{200031,2},{213021,12},{200021,50},{200011,40},{314023,40},{302042,4500}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031107, gemName="荧光宝石7级(火)", gemBelong={1,7}, gemAtt={{200031,2},{213021,13},{200021,55},{200011,45},{314023,45},{302042,4600}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031108, gemName="荧光宝石8级(火)", gemBelong={1,8}, gemAtt={{200031,2},{213021,14},{200021,61},{200011,51},{314023,51},{302042,4700}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031109, gemName="荧光宝石9级(火)", gemBelong={1,9}, gemAtt={{200031,2},{213021,15},{200021,67},{200011,57},{314023,57},{302042,4800}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031110, gemName="荧光宝石10级(火)", gemBelong={1,10}, gemAtt={{200031,2},{213021,16},{200021,73},{200011,63},{314023,63},{302042,4900}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031111, gemName="荧光宝石11级(火)", gemBelong={1,11}, gemAtt={{200031,2},{213021,17},{200021,83},{200011,73},{314023,73},{302042,5000}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031112, gemName="荧光宝石12级(火)", gemBelong={1,12}, gemAtt={{200031,2},{213021,18},{200021,93},{200011,83},{314023,83},{302042,5100}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031113, gemName="荧光宝石13级(火)", gemBelong={1,13}, gemAtt={{200031,3},{213021,19},{200021,103},{200011,93},{314023,93},{302042,5200}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031114, gemName="荧光宝石14级(火)", gemBelong={1,14}, gemAtt={{200031,3},{213021,20},{200021,113},{200011,103},{314023,103},{302042,5300}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031115, gemName="荧光宝石15级(火)", gemBelong={1,15}, gemAtt={{200031,3},{213021,21},{200021,123},{200011,113},{314023,113},{302042,5400}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031116, gemName="荧光宝石16级(火)", gemBelong={1,16}, gemAtt={{200031,4},{213021,22},{200021,136},{200011,126},{314023,126},{302042,5500}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031117, gemName="荧光宝石17级(火)", gemBelong={1,17}, gemAtt={{200031,4},{213021,23},{200021,149},{200011,139},{314023,139},{302042,5600}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031118, gemName="荧光宝石18级(火)", gemBelong={1,18}, gemAtt={{200031,5},{213021,24},{200021,162},{200011,152},{314023,152},{302042,5700}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031119, gemName="荧光宝石19级(火)", gemBelong={1,19}, gemAtt={{200031,5},{213021,25},{200021,175},{200011,165},{314023,165},{302042,5800}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031120, gemName="荧光宝石20级(火)", gemBelong={1,20}, gemAtt={{200031,6},{213021,26},{200021,188},{200011,178},{314023,178},{302042,5900}}, wearbarPos=local_wearbarPos.wearbarPos_1},
	{id=50031201, gemName="荧光宝石1级(水)", gemBelong={2,1}, gemAtt={{211011,1000},{206011,30},{206022,10000},{314015,400},{314012,500}}, gemColorImg="gem_shui"},
	{id=50031202, gemName="荧光宝石2级(水)", gemBelong={2,2}, gemAtt={{211011,1100},{206011,33},{206022,15000},{314015,500},{314012,600}}, gemColorImg="gem_shui"},
	{id=50031203, gemName="荧光宝石3级(水)", gemBelong={2,3}, gemAtt={{211011,1200},{206011,36},{206022,25000},{314015,600},{314012,700}}, gemColorImg="gem_shui"},
	{id=50031204, gemName="荧光宝石4级(水)", gemBelong={2,4}, gemAtt={{211011,1300},{206011,39},{206022,30000},{314015,700},{314012,800}}, gemColorImg="gem_shui"},
	{id=50031205, gemName="荧光宝石5级(水)", gemBelong={2,5}, gemAtt={{211011,1400},{206011,41},{206022,35000},{314015,800},{314012,900}}, gemColorImg="gem_shui"},
	{id=50031206, gemName="荧光宝石6级(水)", gemBelong={2,6}, gemAtt={{211011,1500},{206011,44},{206022,40000},{314015,900},{314012,1000}}, gemColorImg="gem_shui"},
	{id=50031207, gemName="荧光宝石7级(水)", gemBelong={2,7}, gemAtt={{211011,1600},{206011,47},{206022,45000},{314015,1000},{314012,1100}}, gemColorImg="gem_shui"},
	{id=50031208, gemName="荧光宝石8级(水)", gemBelong={2,8}, gemAtt={{211011,1700},{206011,51},{206022,50000},{314015,1100},{314012,1200}}, gemColorImg="gem_shui"},
	{id=50031209, gemName="荧光宝石9级(水)", gemBelong={2,9}, gemAtt={{211011,1800},{206011,55},{206022,55000},{314015,1200},{314012,1300}}, gemColorImg="gem_shui"},
	{id=50031210, gemName="荧光宝石10级(水)", gemBelong={2,10}, gemAtt={{211011,1900},{206011,60},{206022,60000},{314015,1300},{314012,1400}}, gemColorImg="gem_shui"},
	{id=50031211, gemName="荧光宝石11级(水)", gemBelong={2,11}, gemAtt={{211011,2000},{206011,65},{206022,65000},{314015,1400},{314012,1500}}, gemColorImg="gem_shui"},
	{id=50031212, gemName="荧光宝石12级(水)", gemBelong={2,12}, gemAtt={{211011,2100},{206011,71},{206022,70000},{314015,1500},{314012,1600}}, gemColorImg="gem_shui"},
	{id=50031213, gemName="荧光宝石13级(水)", gemBelong={2,13}, gemAtt={{211011,2200},{206011,77},{206022,75000},{314015,1600},{314012,1700}}, gemColorImg="gem_shui"},
	{id=50031214, gemName="荧光宝石14级(水)", gemBelong={2,14}, gemAtt={{211011,2300},{206011,84},{206022,80000},{314015,1700},{314012,1800}}, gemColorImg="gem_shui"},
	{id=50031215, gemName="荧光宝石15级(水)", gemBelong={2,15}, gemAtt={{211011,2400},{206011,91},{206022,85000},{314015,1800},{314012,1900}}, gemColorImg="gem_shui"},
	{id=50031216, gemName="荧光宝石16级(水)", gemBelong={2,16}, gemAtt={{211011,2500},{206011,99},{206022,90000},{314015,1900},{314012,2000}}, gemColorImg="gem_shui"},
	{id=50031217, gemName="荧光宝石17级(水)", gemBelong={2,17}, gemAtt={{211011,2600},{206011,107},{206022,95000},{314015,2000},{314012,2100}}, gemColorImg="gem_shui"},
	{id=50031218, gemName="荧光宝石18级(水)", gemBelong={2,18}, gemAtt={{211011,2700},{206011,117},{206022,100000},{314015,2100},{314012,2200}}, gemColorImg="gem_shui"},
	{id=50031219, gemName="荧光宝石19级(水)", gemBelong={2,19}, gemAtt={{211011,2800},{206011,125},{206022,105000},{314015,2200},{314012,2300}}, gemColorImg="gem_shui"},
	{id=50031220, gemName="荧光宝石20级(水)", gemBelong={2,20}, gemAtt={{211011,2900},{206011,135},{206022,110000},{314015,2300},{314012,2400}}, gemColorImg="gem_shui"},
	{id=50031301, gemName="荧光宝石1级(冰)", gemBelong={3,1}, gemAtt={{207042,250},{208042,400},{320011,37},{209011,25},{1053,3000}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031302, gemName="荧光宝石2级(冰)", gemBelong={3,2}, gemAtt={{207042,280},{208042,450},{320011,40},{209011,27},{1053,3200}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031303, gemName="荧光宝石3级(冰)", gemBelong={3,3}, gemAtt={{207042,310},{208042,500},{320011,45},{209011,30},{1053,3400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031304, gemName="荧光宝石4级(冰)", gemBelong={3,4}, gemAtt={{207042,340},{208042,550},{320011,50},{209011,35},{1053,3600}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031305, gemName="荧光宝石5级(冰)", gemBelong={3,5}, gemAtt={{207042,372},{208042,601},{320011,57},{209011,42},{1053,4000}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031306, gemName="荧光宝石6级(冰)", gemBelong={3,6}, gemAtt={{207042,404},{208042,652},{320011,64},{209011,49},{1053,4400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031307, gemName="荧光宝石7级(冰)", gemBelong={3,7}, gemAtt={{207042,436},{208042,703},{320011,71},{209011,56},{1053,4900}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031308, gemName="荧光宝石8级(冰)", gemBelong={3,8}, gemAtt={{207042,471},{208042,755},{320011,80},{209011,65},{1053,5400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031309, gemName="荧光宝石9级(冰)", gemBelong={3,9}, gemAtt={{207042,506},{208042,807},{320011,89},{209011,74},{1053,6000}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031310, gemName="荧光宝石10级(冰)", gemBelong={3,10}, gemAtt={{207042,541},{208042,859},{320011,100},{209011,83},{1053,6600}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031311, gemName="荧光宝石11级(冰)", gemBelong={3,11}, gemAtt={{207042,578},{208042,914},{320011,113},{209011,94},{1053,7300}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031312, gemName="荧光宝石12级(冰)", gemBelong={3,12}, gemAtt={{207042,615},{208042,969},{320011,126},{209011,105},{1053,8000}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031313, gemName="荧光宝石13级(冰)", gemBelong={3,13}, gemAtt={{207042,652},{208042,1024},{320011,139},{209011,116},{1053,8800}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031314, gemName="荧光宝石14级(冰)", gemBelong={3,14}, gemAtt={{207042,689},{208042,1079},{320011,152},{209011,127},{1053,9600}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031315, gemName="荧光宝石15级(冰)", gemBelong={3,15}, gemAtt={{207042,726},{208042,1134},{320011,165},{209011,138},{1053,10500}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031316, gemName="荧光宝石16级(冰)", gemBelong={3,16}, gemAtt={{207042,766},{208042,1191},{320011,180},{209011,153},{1053,11400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031317, gemName="荧光宝石17级(冰)", gemBelong={3,17}, gemAtt={{207042,806},{208042,1248},{320011,195},{209011,168},{1053,12400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031318, gemName="荧光宝石18级(冰)", gemBelong={3,18}, gemAtt={{207042,846},{208042,1305},{320011,210},{209011,186},{1053,13400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031319, gemName="荧光宝石19级(冰)", gemBelong={3,19}, gemAtt={{207042,886},{208042,1362},{320011,225},{209011,204},{1053,14500}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031320, gemName="荧光宝石20级(冰)", gemBelong={3,20}, gemAtt={{207042,926},{208042,1419},{320011,240},{209011,222},{1053,16500}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_bing"},
	{id=50031401, gemName="荧光宝石1级(风)", gemBelong={4,1}, gemAtt={{207063,8},{207011,100},{208011,150},{208052,7},{302021,70},{302051,5}}, gemColorImg="gem_feng"},
	{id=50031402, gemName="荧光宝石2级(风)", gemBelong={4,2}, gemAtt={{207063,10},{207011,115},{208011,165},{208052,14},{302021,82},{302051,7}}, gemColorImg="gem_feng"},
	{id=50031403, gemName="荧光宝石3级(风)", gemBelong={4,3}, gemAtt={{207063,13},{207011,130},{208011,180},{208052,21},{302021,95},{302051,9}}, gemColorImg="gem_feng"},
	{id=50031404, gemName="荧光宝石4级(风)", gemBelong={4,4}, gemAtt={{207063,16},{207011,145},{208011,195},{208052,28},{302021,110},{302051,11}}, gemColorImg="gem_feng"},
	{id=50031405, gemName="荧光宝石5级(风)", gemBelong={4,5}, gemAtt={{207063,21},{207011,165},{208011,215},{208052,37},{302021,126},{302051,13}}, gemColorImg="gem_feng"},
	{id=50031406, gemName="荧光宝石6级(风)", gemBelong={4,6}, gemAtt={{207063,26},{207011,185},{208011,235},{208052,46},{302021,143},{302051,15}}, gemColorImg="gem_feng"},
	{id=50031407, gemName="荧光宝石7级(风)", gemBelong={4,7}, gemAtt={{207063,31},{207011,205},{208011,255},{208052,55},{302021,162},{302051,17}}, gemColorImg="gem_feng"},
	{id=50031408, gemName="荧光宝石8级(风)", gemBelong={4,8}, gemAtt={{207063,38},{207011,235},{208011,285},{208052,66},{302021,182},{302051,19}}, gemColorImg="gem_feng"},
	{id=50031409, gemName="荧光宝石9级(风)", gemBelong={4,9}, gemAtt={{207063,45},{207011,265},{208011,315},{208052,77},{302021,203},{302051,21}}, gemColorImg="gem_feng"},
	{id=50031410, gemName="荧光宝石10级(风)", gemBelong={4,10}, gemAtt={{207063,52},{207011,295},{208011,345},{208052,88},{302021,226},{302051,23}}, gemColorImg="gem_feng"},
	{id=50031411, gemName="荧光宝石11级(风)", gemBelong={4,11}, gemAtt={{207063,61},{207011,335},{208011,385},{208052,101},{302021,250},{302051,25}}, gemColorImg="gem_feng"},
	{id=50031412, gemName="荧光宝石12级(风)", gemBelong={4,12}, gemAtt={{207063,70},{207011,375},{208011,425},{208052,114},{302021,275},{302051,27}}, gemColorImg="gem_feng"},
	{id=50031413, gemName="荧光宝石13级(风)", gemBelong={4,13}, gemAtt={{207063,79},{207011,415},{208011,465},{208052,127},{302021,302},{302051,29}}, gemColorImg="gem_feng"},
	{id=50031414, gemName="荧光宝石14级(风)", gemBelong={4,14}, gemAtt={{207063,88},{207011,455},{208011,505},{208052,140},{302021,330},{302051,31}}, gemColorImg="gem_feng"},
	{id=50031415, gemName="荧光宝石15级(风)", gemBelong={4,15}, gemAtt={{207063,97},{207011,495},{208011,545},{208052,153},{302021,359},{302051,33}}, gemColorImg="gem_feng"},
	{id=50031416, gemName="荧光宝石16级(风)", gemBelong={4,16}, gemAtt={{207063,110},{207011,545},{208011,595},{208052,171},{302021,3990},{302051,35}}, gemColorImg="gem_feng"},
	{id=50031417, gemName="荧光宝石17级(风)", gemBelong={4,17}, gemAtt={{207063,123},{207011,595},{208011,645},{208052,189},{302021,422},{302051,37}}, gemColorImg="gem_feng"},
	{id=50031418, gemName="荧光宝石18级(风)", gemBelong={4,18}, gemAtt={{207063,136},{207011,645},{208011,695},{208052,207},{302021,455},{302051,39}}, gemColorImg="gem_feng"},
	{id=50031419, gemName="荧光宝石19级(风)", gemBelong={4,19}, gemAtt={{207063,149},{207011,695},{208011,745},{208052,225},{302021,490},{302051,41}}, gemColorImg="gem_feng"},
	{id=50031420, gemName="荧光宝石20级(风)", gemBelong={4,20}, gemAtt={{207063,162},{207011,745},{208011,795},{208052,243},{302021,526},{302051,43}}, gemColorImg="gem_feng"},
	{id=50031501, gemName="荧光宝石1级(雷)", gemBelong={5,1}, gemAtt={{303072,15},{303012,1000},{305072,30},{305012,800}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031502, gemName="荧光宝石2级(雷)", gemBelong={5,2}, gemAtt={{303072,20},{303012,1100},{305072,32},{305012,900}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031503, gemName="荧光宝石3级(雷)", gemBelong={5,3}, gemAtt={{303072,25},{303012,1200},{305072,35},{305012,1000}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031504, gemName="荧光宝石4级(雷)", gemBelong={5,4}, gemAtt={{303072,30},{303012,1300},{305072,40},{305012,1100}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031505, gemName="荧光宝石5级(雷)", gemBelong={5,5}, gemAtt={{303072,36},{303012,1400},{305072,47},{305012,1200}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031506, gemName="荧光宝石6级(雷)", gemBelong={5,6}, gemAtt={{303072,43},{303012,1500},{305072,56},{305012,1300}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031507, gemName="荧光宝石7级(雷)", gemBelong={5,7}, gemAtt={{303072,51},{303012,1600},{305072,66},{305012,1400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031508, gemName="荧光宝石8级(雷)", gemBelong={5,8}, gemAtt={{303072,60},{303012,1700},{305072,77},{305012,1500}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031509, gemName="荧光宝石9级(雷)", gemBelong={5,9}, gemAtt={{303072,70},{303012,1800},{305072,89},{305012,1600}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031510, gemName="荧光宝石10级(雷)", gemBelong={5,10}, gemAtt={{303072,81},{303012,1900},{305072,102},{305012,1700}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031511, gemName="荧光宝石11级(雷)", gemBelong={5,11}, gemAtt={{303072,94},{303012,2000},{305072,117},{305012,1800}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031512, gemName="荧光宝石12级(雷)", gemBelong={5,12}, gemAtt={{303072,109},{303012,2100},{305072,134},{305012,1900}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031513, gemName="荧光宝石13级(雷)", gemBelong={5,13}, gemAtt={{303072,126},{303012,2200},{305072,153},{305012,2000}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031514, gemName="荧光宝石14级(雷)", gemBelong={5,14}, gemAtt={{303072,145},{303012,2300},{305072,174},{305012,2100}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031515, gemName="荧光宝石15级(雷)", gemBelong={5,15}, gemAtt={{303072,166},{303012,2400},{305072,197},{305012,2200}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031516, gemName="荧光宝石16级(雷)", gemBelong={5,16}, gemAtt={{303072,189},{303012,2500},{305072,223},{305012,2300}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031517, gemName="荧光宝石17级(雷)", gemBelong={5,17}, gemAtt={{303072,215},{303012,2600},{305072,252},{305012,2400}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031518, gemName="荧光宝石18级(雷)", gemBelong={5,18}, gemAtt={{303072,244},{303012,2700},{305072,284},{305012,2500}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031519, gemName="荧光宝石19级(雷)", gemBelong={5,19}, gemAtt={{303072,276},{303012,2800},{305072,319},{305012,2600}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031520, gemName="荧光宝石20级(雷)", gemBelong={5,20}, gemAtt={{303072,311},{303012,2900},{305072,357},{305012,2700}}, wearbarPos=local_wearbarPos.wearbarPos_1, gemColorImg="gem_lei"},
	{id=50031601, gemName="荧光宝石1级(土)", gemBelong={6,1}, gemAtt={{10001,6},{10002,1},{10004,30},{10003,10}}, gemColorImg="gem_tu"},
	{id=50031602, gemName="荧光宝石2级(土)", gemBelong={6,2}, gemAtt={{10001,8},{10002,2},{10004,32},{10003,12}}, gemColorImg="gem_tu"},
	{id=50031603, gemName="荧光宝石3级(土)", gemBelong={6,3}, gemAtt={{10001,9},{10002,3},{10004,34},{10003,13}}, gemColorImg="gem_tu"},
	{id=50031604, gemName="荧光宝石4级(土)", gemBelong={6,4}, gemAtt={{10001,10},{10002,4},{10004,36},{10003,15}}, gemColorImg="gem_tu"},
	{id=50031605, gemName="荧光宝石5级(土)", gemBelong={6,5}, gemAtt={{10001,11},{10002,5},{10004,38},{10003,17}}, gemColorImg="gem_tu"},
	{id=50031606, gemName="荧光宝石6级(土)", gemBelong={6,6}, gemAtt={{10001,13},{10002,7},{10004,41},{10003,20}}, gemColorImg="gem_tu"},
	{id=50031607, gemName="荧光宝石7级(土)", gemBelong={6,7}, gemAtt={{10001,15},{10002,9},{10004,44},{10003,23}}, gemColorImg="gem_tu"},
	{id=50031608, gemName="荧光宝石8级(土)", gemBelong={6,8}, gemAtt={{10001,18},{10002,12},{10004,48},{10003,27}}, gemColorImg="gem_tu"},
	{id=50031609, gemName="荧光宝石9级(土)", gemBelong={6,9}, gemAtt={{10001,20},{10002,15},{10004,52},{10003,31}}, gemColorImg="gem_tu"},
	{id=50031610, gemName="荧光宝石10级(土)", gemBelong={6,10}, gemAtt={{10001,24},{10002,18},{10004,57},{10003,36}}, gemColorImg="gem_tu"},
	{id=50031611, gemName="荧光宝石11级(土)", gemBelong={6,11}, gemAtt={{10001,27},{10002,21},{10004,62},{10003,41}}, gemColorImg="gem_tu"},
	{id=50031612, gemName="荧光宝石12级(土)", gemBelong={6,12}, gemAtt={{10001,31},{10002,25},{10004,68},{10003,47}}, gemColorImg="gem_tu"},
	{id=50031613, gemName="荧光宝石13级(土)", gemBelong={6,13}, gemAtt={{10001,35},{10002,29},{10004,74},{10003,53}}, gemColorImg="gem_tu"},
	{id=50031614, gemName="荧光宝石14级(土)", gemBelong={6,14}, gemAtt={{10001,40},{10002,34},{10004,81},{10003,60}}, gemColorImg="gem_tu"},
	{id=50031615, gemName="荧光宝石15级(土)", gemBelong={6,15}, gemAtt={{10001,44},{10002,39},{10004,88},{10003,67}}, gemColorImg="gem_tu"},
	{id=50031596, gemName="荧光宝石16级(土)", gemBelong={6,16}, gemAtt={{10001,50},{10002,44},{10004,96},{10003,75}}, gemColorImg="gem_tu"},
	{id=50031597, gemName="荧光宝石17级(土)", gemBelong={6,17}, gemAtt={{10001,55},{10002,49},{10004,104},{10003,83}}, gemColorImg="gem_tu"},
	{id=50031598, gemName="荧光宝石18级(土)", gemBelong={6,18}, gemAtt={{10001,61},{10002,55},{10004,113},{10003,92}}, gemColorImg="gem_tu"},
	{id=50031599, gemName="荧光宝石19级(土)", gemBelong={6,19}, gemAtt={{10001,67},{10002,51},{10004,122},{10003,101}}, gemColorImg="gem_tu"},
	{id=50031500, gemName="荧光宝石20级(土)", gemBelong={6,20}, gemAtt={{10001,75},{10002,68},{10004,132},{10003,110}}, gemColorImg="gem_tu"},
}

local defaults = {gemAtt={{200031,1},{213021,7},{200021,30},{200011,20},{314023,20},{302042,4000}}, wearbarPos={4,5,6,7,8}, wearbar={1,2,3}, gemColorImg="gem_huo"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_gem) do
	setmetatable(v, mt)
end

return cfg_equip_gem