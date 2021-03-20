------------------------------SQL Social-Network Modification Exercises----------------------
--It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from highschooler
where grade = 12

--If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from likes
where exists (
	select h1.id, h2.id 
	from friend
	inner join highschooler h1 on h1.id = friend.id1
	inner join highschooler h2 on h2.id = friend.id2
	inner join likes l on l.ID1 = Friend.ID1 and l.id2 = friend.id2 
	where l.ID1 not in (select id2 from likes where id1 = h2.id)
	and h1.id = likes.ID1 and h2.id = likes.id2
)

/*For all cases where A is friends with B, and B is friends with C, 
add a new friendship for the pair A and C. 
Do not add duplicate friendships, friendships that already exist, 
or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)*/
insert into friend(id1, id2)
select h1.id, h3.id
from friend f1
inner join highschooler h1 on h1.id = f1.id1
inner join highschooler h2 on h2.id = f1.id2
inner join friend f2 on f2.ID1 = f1.id2 
inner join highschooler h3 on h3.id = f2.id2
where f1.id1 <> f2.id2 --do not add friendship with oneself
and not exists ( --do not add already existing friendships 
	select 1
	from friend
	where friend.ID1 = f1.id1 
	and friend.id2 = f2.id2
)
--do not add duplicate friendship
group by h1.id, h3.id