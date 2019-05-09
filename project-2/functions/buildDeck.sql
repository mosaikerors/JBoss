drop function if exists buildDeck;
delimiter //
create function buildDeck(id int, cards varchar(20000))
returns varchar(45)
begin
	declare cur_card_id int;
    declare cur_card_name varchar(45);
    declare distinct_name_num int;
    declare deck_id int;
    
    drop temporary table if exists check_name;
    create temporary table check_name(card_id int, card_name varchar(45));
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
    
    # 检查是否重名
    select count(distinct(card_name)) from check_name into distinct_name_num;
    if (distinct_name_num = 30) then
		# 要先插入deck
        select count(deckId) + 1 into deck_id 
			from deck 
            where userId = id;
        insert into deck values (id, deck_id);
		insert into compose (
			select @id, @deck_id, card_id
				from check_name
		);
        return "ok";
	else
		return "fail";
	end if;
END //
delimiter ;

select buildDeck(2, "1,2,3");