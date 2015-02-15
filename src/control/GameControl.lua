require "src/data/GameModel.lua"
local GameControl = class("GameControl")

function GameControl:ctor(GameModel,col,row)
    self.gm = GameModel
    self.grid = GameModel.grid
    self.col = col
    self.row = row
end

function GameControl:lookForMatches(isSingle)
    --获取水平匹配
    local function getMatchHoriz(col,row)
        local match = {}
        match[#match + 1] = self.grid[col][row]
        --table.insert(match,self.grid[col][row])
        for i=1,self.col do
            if col+i> self.col then
                break;
            end
            if self.grid[col][row].type == self.grid[col+i][row].type then
                --table.insert(match,self.grid[col+i][row])
                 match[#match + 1] = self.grid[col+i][row]
            else return match
            end
        end
        return match
    end
    --获取垂直匹配
    local function getMatchVert(col,row)
        local match = {}
        --table.insert(match,self.grid[col][row])
        match[#match + 1] = self.grid[col][row]
        for i=1,self.row do
            if row+i > self.row then
                break
            end
            if self.grid[col][row].type == self.grid[col][row+i].type then
                --table.insert(match,self.grid[col][row+i])
                match[#match + 1] = self.grid[col][row+i]
            else return match
            end
        end
        return match
    end

    local matchList = {}
    local match = nil

    for row=1, self.row do
        local col = 1
        while col<self.col do
            match = getMatchHoriz(col,row)
            if #match > 2 then
                --table.insert(matchList,match)
                matchList[#matchList + 1] = match
                col = col + #match - 1
            else
                col = col + 1
            end
            if isSingle and #matchList >= 1 then
                --print("----------------------------------------")
                return matchList
            end
        end
    end

    for col =1,self.col do
        local row = 1
        while row<self.row do
            match = getMatchVert(col,row)
            if #match > 2 then
                --table.insert(matchList,match)
                matchList[#matchList + 1] = match
                row = row + #match - 1
            else
                row = row+1
            end
            if isSingle and #matchList >= 1 then
            --print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                return matchList
            end
        end
    end
    return matchList
end

function GameControl:lookForPossibles()
    
    local function matchType(col,row,type)
        if col<1 or col>self.col or row < 1 or row > self.row then
            return false
         end
        return self.grid[col][row].type == type
    end
    
    --获取匹配列表
    local function matchPattern(col,row,mustHave,needOne)
        local ele = self.grid[col][row]
        local type = ele.type
        local matchList = {}
        for i = 1,#mustHave do
            if not matchType(col+mustHave[1][1],row+mustHave[1][2],type) then
                return matchList
            else
                matchList[#matchList + 1] = self.grid[col+mustHave[1][1]][row+mustHave[1][2]]
            end
        end
        
        matchList[#matchList + 1] = ele
    	for j=1,#needOne do
    	   if matchType(col+needOne[j][1],row+needOne[j][2],type) then
                matchList[#matchList + 1] = self.grid[col+needOne[j][1]][row+needOne[j][2]]
                if #matchList >=3 then return matchList  end
    	   end
    	end
        return matchList;
    end
    
    local matchList = {}
    for col=1,self.col do
        for row=1,self.row do
        
--          1.水平方向上,2+1模式
            local m1 = {{1,0}};--基于col,row点第二个匹配
            local arr1 = {{-2,0},{-1,-1},{-1,1},{2,-1},{2,1},{3,0}};
            local match1 =  matchPattern(col,row,m1,arr1)
            if(#match1>=3) then
                match1.col = col - 1
                match1.row = row
               matchList[#matchList+1] = match1
            end  
--
--          2.水平方向上,中间空缺
            local m2 = {{2,0}};
            local arr2 = {{1,-1},{1,1}};
            local match2 = matchPattern(col,row,m2,arr2)
            if #match2>=3 then
                match2.col = col + 1
                match2.row = row
                matchList[#matchList+1] = match2
            end    
            
--          3.垂直方面上,2+1模式
            local m3 = {{0,1}}
            local arr3 = {{0,-2},{-1,-1},{1,-1},{-1,2},{1,2},{0,3}}
            local match3 = matchPattern(col,row,m3,arr3)
            if #match3>=3 then
                match3.col = col
                match3.row = row+2
                matchList[#matchList+1] = match3
            end
--            
--          4.垂直方面上,中间空缺
            local m4 = {{0,2}};--基于col,row点第二个匹配
            local arr4 = {{-1,1},{1,1}};
            local match4 = matchPattern(col,row,m4,arr4)
            if #match4>=3 then
                match3.col = col
                match3.row = row+1
                matchList[#matchList+1] = match4
            end
        end
    end
    return matchList
end

function GameControl:affectAbove(element)
    for row=element.row,self.row do
        if self.grid[element.col][row] ~= false then
            self.grid[element.col][row].row = self.grid[element.col][row].row-1
            self.grid[element.col][row-1] = self.grid[element.col][row]
            self.grid[element.col][row] = false
        end
    end
end

return GameControl