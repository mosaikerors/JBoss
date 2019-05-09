drop function if exists winRate; # ok! but can the result be percent format?
DELIMITER //
create function getWinRate(id int)
returns double
	begin
		declare winCount int default 0;
		declare allCount int default 0;
		select count(*) into winCount 
			from battle
            where winner = id;
		select count(*) into allCount
			from battle
            where playerA = id or playerB = id;
        return winCount/allCount;
	end
	//
DELIMITER ;
select getWinRate(2);

drop procedure if exists history; # ok!
DELIMITER //
create procedure history(in id int)
	begin
		select * 
			from battle
			where playerA = id or playerB = id;
	end
	//
DELIMITER ;
call history(2);

drop procedure if exists oneMonthSummary;
DELIMITER //
create procedure oneMonthSummary(in id int)
	begin
		drop temporary table if exists tmpOneMonth;
		create temporary table tmpOneMonth(
            daysAgo int,
			ratio float
		);
		set @beginDate = date_sub(date(NOW()), interval 30 day);
        set @i = 0;
        while @i <= 30 do
			set @winCount = 0;
			set @allCount = 0;
			select count(*) into @winCount 
				from battle
				where winner = id and date(time) = date_add(@beginDate, interval @i day);
			select count(*) into @allCount
				from battle
				where (playerA = id or playerB = id) and date(time) = date_add(@beginDate, interval @i day);
			if (@allCount != 0) then
				insert into tmpOneMonth value(30 - @i, @winCount / @allCount);
			end if;
			set @i = @i + 1;
		end while;
        select * from tmpOneMonth;
	end
	//
DELIMITER ;

call oneMonthSummary(2);