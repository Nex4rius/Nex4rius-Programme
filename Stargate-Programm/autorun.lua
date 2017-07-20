-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

os.sleep(1)
print("ja zum weitermachen")
if io.read() ~= "ja" then
    os.exit()
end

local shell = shell or require("shell")
_G.shell = shell
local alterPfad
local args = ...

if require then
    alterPfad = shell.getWorkingDirectory()
    shell.setWorkingDirectory("/")
end

if type(args) ~= "string" then
    args = nil
end

local ergebnis, grund = pcall(loadfile("/stargate/check.lua"), args)
if not ergebnis then
    print("<Fehler> check.lua")
    print(grund)
    os.sleep(2)
    if require then
        if loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Stargate-Programm/installieren.lua", "/installieren.lua") then
            loadfile("/installieren.lua")()
        end
    else
        shell.run("pastebin run -f YVqKFnsP")
    end
end

if require then
    require("shell").setWorkingDirectory(alterPfad)
end
