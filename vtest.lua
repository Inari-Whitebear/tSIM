--dofile("log")
dofile("virtualTerm")
local t = vTerm.makeTerm("abc")
vTerm.setActiveTerm("abc")
t:setCursorPos(1,1)
t:write("Welcome!")
t:setCursorPos(1,3)
t:write("MEWO")
sleep(3)
local w,h = term.getSize()
local p  =vTerm.makeTerm("abcc",w,h,false)
p:setBackgroundColor(colors.red)
p:setTextColor(colors.blue)
p:clear()
p:setCursorPos(5,3)
p:write("MEOW!!!")
sleep(2)
vTerm.setActiveTerm("abcc")
sleep(2)
--logClose()