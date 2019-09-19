package = "lpack"
version = "1.0-1"

source = {
    url = "",
    tag = "1.0-1",
}

description = {
    summary = "lpack",
    detailed = [[
        - No dependencies on other libraries
    ]]
}

dependencies = {
    "lua >= 5.1"
}

build = {
    type = "builtin",
    modules = {
        pack = {
            sources = { "lpack.c" },
            defines = {
                "luaL_reg=luaL_Reg"
            }
        }
    },
    install = {
        lua = {
        },
        bin = {
        }
    }
}