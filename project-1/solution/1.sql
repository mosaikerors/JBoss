set @salaryRank := 0;
# 薪水前10%的教师
with topInstructors as (
	select ID, name 
		from (
			select *, (@salaryRank := @salaryRank + 1) salaryRank 
				from instructor
				order by salary desc
		) newInstructor
		where newInstructor.salaryRank <= @salaryRank * 0.1
),
# 这些教师所开的课程（不考虑学年学期）
topCourses as(
	select distinct (teaches.ID) ID, course_id 
		from topInstructors natural join teaches
),
# 选这些课程的学生人数
studentNum as(
	select course_id, (count(*)) num 
		from takes
		where course_id in (select course_id from topCourses)
		group by course_id
)
select name, title, num
	from topInstructors natural join topCourses natural join studentNum natural join course;