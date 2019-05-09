SET GLOBAL log_bin_trust_function_creators=TRUE;
use university;
drop function if exists course_ratio;
delimiter //
create  function course_ratio (dname varchar(20))
returns numeric(4,2)
begin
DECLARE done INT DEFAULT 0;
declare snum integer default 0;
declare cnum integer default 0;
declare ratio numeric(4,2);
declare stuid varchar(5);
declare r_cursor cursor for
select ID 
from student
where student.dept_name=dname;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

open r_cursor;

REPEAT
fetch r_cursor into stuid;
IF NOT done THEN
set cnum=cnum+(select count(*)
from takes
where stuid=ID);
set snum=snum+1;
END IF;
UNTIL done END REPEAT;

close r_cursor;
set ratio=cnum/snum;
return ratio;
end
//
SELECT 
    dept_name, course_ratio(dept_name)
FROM
    department
