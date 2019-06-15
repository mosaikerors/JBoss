CREATE DEFINER=`root`@`localhost` FUNCTION `buildDeck_after`(id int, cards varchar(20000)) RETURNS varchar(45) CHARSET utf8
begin
	declare cur_card_id int;
    declare cur_card_name varchar(45);
    declare distinct_name_num int;
    declare deck_id int;
    
    # step 1: transform cardId string to a table whose attributes are cardId and cardname
    drop temporary table if exists check_name;
    create temporary table check_name(card_id int, card_name varchar(16));
    while (instr(cards, ',') != 0) do
		set cur_card_id = substring(cards, 1, instr(cards, ',') - 1);
        select cardname into cur_card_name
			from card 
            where cardId = cur_card_id;
		insert check_name values (cur_card_id, cur_card_name);
		set cards = insert(cards, 1, instr(cards, ','), '');
	end while;
    
    select cardname into cur_card_name
		from card 
        where cardId = cards;
    insert check_name values(cards, cur_card_name);
    
    # step 2: check duplicated cardname
    drop temporary table if exists ttt;
    create temporary table ttt(card_id int, card_name varchar(16))
		select * from check_name;
    
    select count(*) into distinct_name_num
		from (
			select card_id 
            from check_name as t1
				where exists (
					select card_id
						from ttt
                        where t1.card_name = ttt.card_name
							and t1.card_id != ttt.card_id
                )
			limit 1
        ) A;
    
    if (distinct_name_num = 0) then
		# get new deckId
        select count(deckId) + 1 into deck_id 
			from compose 
            where userId = id;
        set @id = id;
        set @deck_id = deck_id;
		insert into compose (
			select @id as userId, @deck_id as deckId, card_id as cardId
				from check_name
		);
        return "ok";
	else
		return "fail";
	end if;
END