-- PT 1 & 2

CREATE TABLE IF NOT EXISTS `tw_fishing` (
    `citizen_id` varchar(255) NOT NULL,
    `rep` float NOT NULL DEFAULT 0,
    `fish_caught` int NOT NULL DEFAULT 0,
    `score` float NOT NULL DEFAULT 0,
    PRIMARY KEY (`citizen_id`)
);

INSERT INTO `tw_fishing` (`citizen_id`, `rep`, `score`, `fish_caught`) 
VALUES 
('AM5ZJA20', 0, 0, 0),
('GJ4FHN7A', 0, 0, 0),
('P7281920', 0, 0, 0);