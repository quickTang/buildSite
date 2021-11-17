--线上beta配置
local config_prod = {
    redis_home = { -- your connection name
        host = '127.0.0.1',
        port = 6379,
        pass = '51+0h%#$CYR3',
        timeout = 1500, -- watch out this value
        database = 0,
    },
    redis_video= { -- your connection name
        host = '127.0.0.1',
        port = 6379,
        pass = '51+0h%#$CYR3',
        timeout = 1500, -- watch out this value
        database = 1,
    },
    redis_user= { -- your connection name
        host = '127.0.0.1',
        port = 6379,
        pass = '51+0h%#$CYR3',
        timeout = 1500, -- watch out this value
        database = 2,
    },
    redis_token= { -- your connection name
        host = '127.0.0.1',
        port = 6379,
        pass = '51+0h%#$CYR3',
        timeout = 1500, -- watch out this value
        database = 4,
    },
    redis_like= { -- your connection name
        host = '127.0.0.1',
        port = 6389,
        pass = '51+0h%#$CYR3',
        timeout = 1500, -- watch out this value
        database = 3,
    },
    redis_tongji= { -- your connection name
        host = '127.0.0.1',
        port = 6389,
        pass = '51+0h%#$CYR3',
        timeout = 1500, -- watch out this value
        database = 5,
     }
}
return config_prod;
