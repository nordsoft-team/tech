CREATE TABLE `login_info`  (
  `user_id` int(11) NULL DEFAULT NULL,
  `login_date` date NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;


SELECT
	k.user_id,
	CASE WHEN k.hastoday = 1 THEN DATEDIFF( '2019-01-07', max_login_date ) + 1 ELSE 0 END AS count 
FROM
	(
	SELECT
		c.user_id,
		max( c.login_date ) max_login_date,
		e.hastoday 
	FROM
		login_info c
		LEFT JOIN login_info d ON c.user_id = d.user_id  AND c.login_date = d.login_date + 1
		INNER JOIN (
			SELECT
			user_id,
			max(CASE WHEN login_date = '2019-01-07' THEN 1 ELSE 0 END) AS hastoday 
			FROM
				login_info a 
			GROUP BY user_id 
			) e ON c.user_id = e.user_id 
		WHERE
			d.user_id IS NULL 
		GROUP BY c.user_id 
		ORDER BY c.user_id 
	) k