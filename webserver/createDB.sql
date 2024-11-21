CREATE TABLE `game` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player1` int(11) NOT NULL,
  `player2` int(11) NOT NULL,
  `matrix` text NOT NULL,
  `nextmoove` varchar(5) NOT NULL,
  `sequence` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(1023) DEFAULT NULL,
  `sender` varchar(25) NOT NULL,
  `id_certified_user` int(11) NOT NULL,
  `date_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=662 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pseudo` varchar(25) NOT NULL,
  `token` varchar(30) NOT NULL,
  `rank` int(11) NOT NULL,
  `eloncertification` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
