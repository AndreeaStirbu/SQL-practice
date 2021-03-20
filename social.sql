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

----------Q8
--Find the difference between the number of students in the school 
--and the number of different first names.
select COUNT(*) - COUNT(DISTINCT name)
from Highschooler

----------Q9
--Find the name and grade of all students 
--who are liked by more than one other student.
select s2.name, s2.grade
from likes l
inner join Highschooler S1 on S1.ID = l.ID1
inner join Highschooler S2 on S2.ID = l.ID2
group by s2.name, s2.grade 
having count(*) > 1

------------------------------------------------------SQL Social-Network Query Exercises Extras------------------------------------------------------
----------Q1
--For every situation where student A likes student B, but student B likes a different student C, 
--return the names and grades of A, B, and C.
select s1.name, s1.grade, s2.name, s2.grade, s3.name, s3.grade
from likes l
inner join Highschooler S1 on S1.ID = l.ID1
inner join Highschooler S2 on S2.ID = l.ID2
inner join likes l2 on l2.id1 = s2.id and l2.id2 <> s1.ID
inner join Highschooler S3 on S3.ID = l2.ID2

----------Q2
--Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.
select distinct Highschooler.name, Highschooler.grade
from(--get all students that have friends in diffent classes
	select s1.id, s1.grade
	from friend f
	inner join Highschooler S1 on S1.ID = f.ID1
	inner join Highschooler S2 on S2.ID = f.ID2
	where s2.id not in (select id from Highschooler where id = s2.id and grade = s1.grade)
) erm
inner join friend on Friend.id1 = erm.id
inner join Highschooler on Highschooler.id = friend.ID1
where friend.ID1 not in -- make sure that students that have friends in different classes are not student that have friends in same class
						(select s1.id --get all students that have friends in same class
						from friend f
						inner join Highschooler S1 on S1.ID = f.ID1
						inner join Highschooler S2 on S2.ID = f.ID2
						where s2.id not in (select id from Highschooler where id = s2.id and grade <> s1.grade))

----------Q3
--What is the average number of friends per student? (Your result should be just one number.)
select AVG(NumOfFriends)
from(
	select ID1, COUNT(ID2) as NumOfFriends
	from friend
	group by ID1
)countFriends

----------Q4
--Find the number of students who are either friends with Cassandra(1709) or are friends of friends of Cassandra. 
--Do not count Cassandra, even though technically she is a friend of a friend.

SELECT 
(select COUNT(id2)
from friend 
where friend.ID1 = 1709)
+
(select COUNT(ID2)
from friend
where friend.id1 in (select id2 from friend  where friend.ID1 = 1709)
and friend.ID2 <> 1709)

----------Q5
--Find the name and grade of the student(s) with the greatest number of friends.

SELECT Name, Grade
FROM Highschooler
WHERE ID IN (SELECT ID1 
			 FROM Friend
			 GROUP BY ID1
			 HAVING COUNT(ID2) = (
									SELECT MAX(NumOfFriends)
									FROM(
										SELECT ID1, COUNT(ID2) AS NumOfFriends
										FROM Friend
										GROUP BY ID1 
										) CountFriends
								  )
			)



