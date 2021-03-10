------------------------------------------------------SQL Social-Network Query Exercises------------------------------------------------------
----------Q1
select name
from Highschooler
inner join friend on friend.ID1 = Highschooler.ID and Friend.ID2 IN (select id from Highschooler where name = 'Gabriel')

----------Q2
select s1.name, s1.grade, s2.name, s2.grade
from Highschooler s1
inner join Highschooler s2 on s2.id <> s1.id
inner join Likes on likes.ID1 = s1.id and likes.ID2 = s2.id and s1.grade >= s2.grade+2

----------Q3
--select case when s1.name < s2.name then s1.name else s2.name end as Name1,
--case when s1.name < s2.name then s1.grade else s2.grade end as Grade1,
--case when s1.name > s2.name then s1.name else s2.name end as Name2,
--case when s1.name > s2.name then s1.grade else s2.grade end as Grade2
--from likes
--inner join likes l2 on l2.ID1 = likes.ID2 and l2.ID2 = likes.ID1 and l2.ID1 < Likes.ID1
--inner join Highschooler s1 on s1.id = Likes.ID1
--inner join Highschooler s2 on s2.id = Likes.ID2
--order by s1.name, s2.name

select s1.name, s1.grade, s2.name, s2.grade
from likes
inner join likes l2 on l2.ID1 = likes.ID2 and l2.ID2 = likes.ID1 
inner join Highschooler s1 on s1.id = Likes.ID1
inner join Highschooler s2 on s2.id = Likes.ID2
where s1.name < s2.name
order by s1.name, s2.name

----------Q4
select name, grade
from Highschooler
where not exists (select id1 from likes where likes.ID1 = Highschooler.id or likes.ID2 = Highschooler.id)
order by grade, name

----------Q5
select s1.name, s1.grade, s2.name, s2.grade
from likes
inner join Highschooler s1 on s1.id = Likes.ID1
inner join Highschooler s2 on s2.id = Likes.ID2
where likes.id2 not in (select id1 from likes)

----------Q6
select s1.name, s1.grade as Maingrade
FROM Friend
inner join Highschooler s1 on s1.id = Friend.ID1
inner join Highschooler s2 on s2.id = Friend.ID2
group by s1.name, s1.grade
HAVING MIN(s2.grade) =  MAX(s2.grade) and MAX(s2.grade) = s1.grade
order by s1.grade, s1.name

----------Q7
--For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
--For all such trios, return the name and grade of A, B, and C.
select specialFriends.Name1, 
	   specialFriends.grade1, 
	   specialFriends.Name2, 
	   specialFriends.grade2,
	   S3.name, 
	   s3.grade
from (
	select distinct s1.name AS Name1, s1.ID as ID1, s1.grade AS grade1,
	s2.name AS Name2, s2.ID AS ID2, s2.grade as grade2
	from likes l
	inner join Highschooler S1 on S1.ID = l.ID1
	inner join Highschooler S2 on S2.ID = l.ID2
	cross join friend  
	where friend.ID1 = l.ID1
	AND l.id2 NOT IN (select id2 from friend where id1 = l.id1)
) specialFriends
inner join friend ON friend.ID1 = specialFriends.ID1
					and friend.ID2 IN (select friend.ID2 from friend where friend.ID1 = specialFriends.ID2)
inner join Highschooler S3 ON S3.ID = friend.ID2


