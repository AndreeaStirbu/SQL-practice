------------------------------------------------------SQL Movie-Rating Query Exercises------------------------------------------------------
----Q1
select title from Movie where director like 'Steven Spielberg'

----Q2
select year from Movie 
inner join Rating on Rating.mID = Movie.mID
where stars >=4
order by stars

----Q3
select title from Movie 
left outer join Rating on Rating.mID = Movie.mID
where stars is null

----Q4
select name from Reviewer
inner join Rating on Rating.rID = Reviewer.rID
where ratingDate is null

----Q5
select name, title, stars, ratingDate
from movie
left outer join rating on rating.mID = movie.mid
left join Reviewer on Reviewer.rID = rating.rID
order by name, title, stars

----Q6
select name, title
from movie
inner join rating r1 on r1.mid = movie.mid
inner join rating r2 on r2.mid = r1.mid and r1.ratingDate < r2.ratingDate and r1.stars < r2.stars
inner join Reviewer on Reviewer.rid = r2.rid
group by name, title
having count(title) > 1

----Q7
select title, max(stars) from Movie
inner join rating on rating.mID = movie.mid
inner join Reviewer on Reviewer.rID = rating.rID
group by Movie.title
having count(*) > 1 

----Q8
select title, max(stars)-min(stars) as ratingSpread from Movie
inner join rating on rating.mID = movie.mid
inner join Reviewer on Reviewer.rID = rating.rID
group by Movie.title
having count(*) > 1 
order by ratingSpread desc, title

----Q9
select 
(select avg(m1.avg1) from(
select title, avg(stars) as avg1 from Movie
inner join rating on rating.mID = movie.mid
where year < 1980
group by Movie.title)m1) 
-
(select avg(m2.avg2) from(
select title, avg(stars ) as avg2 from Movie
inner join rating on rating.mID = movie.mid
where year > 1980
group by Movie.title)m2) 

------------------------------------------------------SQL Movie-Rating Query Exercises Extras------------------------------------------------------
----Q1
select distinct name from Reviewer
inner join rating on rating.rID = Reviewer.rID
inner join Movie on movie.mid = rating.mid
where title = 'Gone with the Wind'

----Q2
select name, title, stars from Reviewer
inner join rating on rating.rID = Reviewer.rID 
inner join Movie on movie.mid = rating.mid and movie.director = Reviewer.name

----Q3
select name as Name from Reviewer
union all 
select title as Name from Movie order by Name

----Q4
select distinct title from movie
left join rating on rating.mid = movie.mid 
where movie.mid not in (select mid from rating inner join reviewer on reviewer.rid = rating.rid where name = 'Chris Jackson')
or rid is null

----Q5
select distinct case when reviewer.name < rev2.name then reviewer.name else case when rev2.name < reviewer.name then rev2.name end end as r1,
case when reviewer.name > rev2.name then reviewer.name else case when rev2.name > reviewer.name then rev2.name end end as r2
from reviewer
inner join rating on rating.rid = reviewer.rid
inner join rating r2 on r2.mid = rating.mid and r2.rid < rating.rid
inner join reviewer rev2 on rev2.rid = r2.rid
order by r1, r2

----Q6
select name, title, stars
from movie
inner join rating on rating.mid = movie.mid
inner join reviewer on reviewer.rid = rating.rid
where stars = (select min(stars) from rating)

----Q7
select title, avg(stars) as avgMovie
from movie
inner join rating on rating.mid = movie.mid
group by title
order by avgMovie desc, title

----Q8
select name, *
from reviewer 
inner join rating on rating.rID = reviewer.rid
group by name
having count(*) > 2

--without HAVING or COUNT


----Q9
select title, director
from movie
where director in (select director from movie group by director having count(*) > 1)
order by director, title

--without HAVING or COUNT


----Q10
select title, avgMovie.avgMovie
from (
	select title, avg(stars) as avgMovie
	from movie
	inner join rating on rating.mid = movie.mid
	group by title
) avgMovie
where avgMovie = (select MAX(avgMovie) from (
	select avg(stars) as avgMovie
	from rating
	group by mid
) avgMovie)

----Q11
select title, avgMovie.avgMovie
from (
	select title, avg(stars) as avgMovie
	from movie
	inner join rating on rating.mid = movie.mid
	group by title
) avgMovie
where avgMovie = (select MIN(avgMovie) from (
	select avg(stars) as avgMovie
	from rating
	group by mid
) avgMovie) 

SELECT title, avg(stars) as avgMovie
FROM Movie
CROSS JOIN (
	select TOP 1 avg(stars) as avgMovie
	from rating
	group by mid
	ORDER BY  ROW_NUMBER() OVER ( ORDER BY  avg(stars) ASC )
) MinRating
INNER JOIN rating on rating.mid = Movie.mID
GROUP BY title, avgMovie
HAVING avg(stars) = MinRating.avgMovie

----Q12
select distinct director, title, stars
from movie m
inner join rating on rating.mid = m.mid 
where director is not null
and stars = (select max(stars) from movie inner join rating on rating.mid = movie.mid and movie.director = m.director group by director)

