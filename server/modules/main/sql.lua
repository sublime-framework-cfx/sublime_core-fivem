Citizen.CreateThreadNow(function()

    local databaseName <const> = MySQL.scalar.await('SELECT DATABASE()')
    sl.databaseName = databaseName ---@type string utils to recover the database name later

    if sl.databaseName then
        local config <const> = {
            { ---@class profils
                exist = "SELECT 1 FROM `profils`",
                create = [[
                    CREATE TABLE IF NOT EXISTS `profils` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `user` varchar(100) NOT NULL,
                        `password` varchar(20) DEFAULT NULL,
                        `permission` varchar(30) NOT NULL DEFAULT 'player',
                        `identifiers` longtext NOT NULL DEFAULT '[]',
                        `createdBy` longtext NOT NULL,
                        `stats` longtext DEFAULT NULL,
                        `lastUpdate` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                        `previousId` varchar(255) DEFAULT NULL,
                        `metadata` LONGTEXT NULL DEFAULT '[]',
                        PRIMARY KEY (`id`) USING BTREE,
                        UNIQUE INDEX `user` (`user`) USING BTREE
                    )
                ]],
            },
            { ---@class characters
                exist = "SELECT 1 FROM `characters`",
                create = ([[
                    CREATE TABLE IF NOT EXISTS `characters` (
                        `charid` int(11) NOT NULL AUTO_INCREMENT,
                        `user` int(11) NOT NULL,
                        `firstname` varchar(100) NOT NULL,
                        `lastname` varchar(100) NOT NULL,
                        `dateofbirth` varchar(100) NOT NULL,
                        `sex` varchar(100) NOT NULL,
                        `height` varchar(100) NOT NULL,
                        `inventory` longtext NOT NULL DEFAULT '[]',
                        `lastUpdate` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                        `x` float NOT NULL DEFAULT 0,
                        `y` float NOT NULL DEFAULT 0,
                        `z` float NOT NULL DEFAULT 0,
                        `w` float NOT NULL DEFAULT 0,
                        `status` longtext NOT NULL DEFAULT '[]',
                        `instance` int(11) NOT NULL DEFAULT 0,
                        `skin` longtext NOT NULL DEFAULT '[]',
                        `isDead` tinyint(1) NOT NULL DEFAULT 0,
                        `metadata` longtext NOT NULL DEFAULT '[]',
                        PRIMARY KEY (`charid`) USING BTREE,
                        INDEX `FK_characters_profils` (`user`) USING BTREE,
                        CONSTRAINT `FK_characters_profils` FOREIGN KEY (`user`) REFERENCES `%s`.`profils` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
                    )
                ]]):format(sl.databaseName),
            }
        }

        for i = 1, #config do
            local sql = config[i]
            local exist = pcall(MySQL.scalar.await, sql.exist)
            if not exist then
                MySQL.query.await(sql.create)
            end
        end return
    end

    error('Database not found', 3)
end)
