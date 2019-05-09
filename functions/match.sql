drop function if exists `match`;
delimiter //
create function `match`(id int)
returns varchar(45)
begin
    declare numOfMatching int;
    declare targetPlayer int;
    declare myRank int default (select `rank` from player where userId = id);
    declare winner, loser int;
    declare myStreak int default (select streak from player where userId = id);
   
    drop temporary table if exists playersMatching;
    create temporary table playersMatching (
		select playerA
			from battle
            where playerA = playerB
    );
    
    select count(*) into numOfMatching
		from playersMatching;
	if (numOfMatching = 0) then
		insert battle values(id, id, now(), 0);
		return "No player is matching.";
	end if;
   
    drop temporary table if exists rankDiff;
    if (myStreak > -5) then
		create temporary table rankDiff (
			select userId, abs(`rank` - myRank) as diff
				from player
				where userId in (select * from playersMatching)
		);
    else
		create temporary table rankDiff (
			select userId, abs(`rank` - myRank - 5) as diff
				from player
				where userId in (select * from playersMatching) 
					and streak > -5
		);
	end if;
		
	select userId into targetPlayer
		from rankDiff
		order by diff
		limit 1;
    
    if (rand() < 0.5) then
		set winner = id;
        set loser = targetPlayer;
	else
		set winner = targetPlayer;
        set loser = id;
    end if;
    
    update player
		set `rank` = if (`rank` = 1, 1, `rank` - 1),
			streak = if (streak > 0, streak + 1, 1)
		where userId = winner;
	update player
		set `rank` = if (`rank` = 25, 25, `rank` + 1),
			streak = if (streak < 0, streak - 1, -1)
		where userId = loser;
        
	# insert result into battle records
	update battle
		set playerB = id,
			time = now(),
			winner = winner
		where playerA = targetPlayer and playerB = targetPlayer;
    return "Found";
end//
delimiter ;

select `match`(3);

select `match`(4);


