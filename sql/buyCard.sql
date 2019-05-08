delimiter //                        			     #定义标识符为双斜杠
drop procedure if exists buycard;          			 #如果存在test存储过程则删除
create procedure buyCard(userid int)                 #创建无参存储过程,名称为test
begin
    declare i int;					#repeat循环变量
    declare cardid int;				#抽卡的卡id，待定
    declare money float;			#本月已充值金额
    declare possibility double; 	#根据本月充值金额获取的获得稀有卡的概率
    declare rare double;			#用于定义稀有卡的稀有界限值，需在游戏中实现
    
    set money=(select recharge from player where userId=userid);                #查看本月充值金额
    set possibility=get_rarity(money);											#计算获取稀有卡的概率，get_rarity算法需在游戏中实现
    
    set i=0;																	#开始循环
    repeat 
		IF  (rand()/possibility<1) THEN 										#随机函数判断这张卡是否为稀有卡
			set cardid=select cardId from 										#将所有稀有卡随机打乱抽取一张
						(select * from cards where rarity>=rare order by rand()) 
						limit 1;  
		ELSE 
			set cardid=select cardId from 										#将非稀有卡随机打乱抽取一张
						(select * from cards where rarity<rare order by rand()) 
						limit 1;  
		END IF; 
		
		INSERT INTO Collect (userId,cardId,number) 
			VALUES (userid,cardid,1) 
			ON DUPLICATE KEY 
			UPDATE number=number+1;												#已有该卡更新卡片数量，否则插入新纪录
		set i = i + 1;		#更新循环条件
		until i > 4			#一次抽五张卡
	end repeat;
end
