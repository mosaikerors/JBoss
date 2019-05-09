# find all the students and their courses
create table new_student_takes as
	select student.ID, student.name, student.dept_name, takes.course_id, course.title, takes.grade, course.credits
    from student join takes join course
    where student.ID = takes.ID and takes.course_id = course.course_id;
    
# add one column for their score
alter table new_student_takes add column score real;

# convert grade to score
update new_student_takes 
	set score = case
		when grade = "A+" then 100
        when grade = "A " then 95
        when grade = "A-" then 90
        when grade = "B+" then 85
        when grade = "B " then 80
        when grade = "B-" then 75
        when grade = "C+" then 70
        when grade = "C " then 65
        when grade = "C-" then 60
        else 0
	end;
    
# student_score -- compute their average score
create view student_score as 
	select ID, name, dept_name, sum(credits) as total_credits, sum(credits*score)/sum(credits) as avg_score
	from new_student_takes
    group by ID,name,dept_name;
    
# rank the students by their dept_name and score
create view student_rank as
	select *, percent_rank() over(partition by dept_name order by avg_score desc) as score_rank
	from student_score
    order by dept_name, score_rank;
    
# create a table for sholarship
create table scholarship as
	select dept_name, ID as s_id, score_rank, name as s_name, avg_score
    from student_rank
    where score_rank<0.4;
    
# add one column for score
alter table scholarship add column level varchar(10);

# add scholarship level
update scholarship 
	set level = case
		when score_rank<0.2 then "A"
		else "B"
    end;
# print the result
select dept_name, level, s_id, s_name, avg_score 
	from scholarship
    order by dept_name, level, avg_score desc;
    
drop table new_student_takes;
drop view student_score;
drop view student_rank;
drop table scholarship;