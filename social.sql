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
select *
from likes
where 