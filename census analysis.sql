
select * from data2

-- number of rows into our dataset
select count(*) from data1
select count(*) from data2
-- dataset for jharkhand and bihar
select * from data1 
where state in ('Jharkhand' , 'Bihar')

-- total population of India
select sum(Population) as Populations from data2


-- average growth each state

select state, avg(Growth)*100 as avg_growth from data1
group by state


-- avg sex ratio each state
select state, round(avg(sex_ratio),0) as avg_sex_ratio from data1
group by state order by avg_sex_ratio desc

-- states with more than 90% literacy ratio
select state, round(avg(literacy),0) as avg_literacy_ratio from data1
group by state having round(avg(literacy),0) > 90 order by avg_literacy_ratio desc 


-- top 3 states showing highest growth ratio
select state, avg(Growth)*100 as avg_growth from data1
group by state order by avg_growth desc limit 3


-- top and bottom 3 states in literacy 

DROP TABLE IF EXISTS top_states;
CREATE TABLE top_states ( state NVARCHAR(255), topstate FLOAT);
INSERT INTO top_states (state, topstate)
SELECT state,  ROUND(AVG(literacy), 0) AS avg_literacy_ratio
FROM data1
GROUP BY state order by avg_literacy_ratio desc;
SELECT * FROM top_states
ORDER BY topstate DESC limit 3;


DROP TABLE IF EXISTS bottom_states;
CREATE TABLE bottom_states ( state NVARCHAR(255), bottomstate FLOAT);
INSERT INTO bottom_states (state, bottomstate)
SELECT state,  ROUND(AVG(literacy), 0) AS avg_literacy_ratio
FROM data1
GROUP BY state order by avg_literacy_ratio desc;
SELECT * FROM bottom_states
ORDER BY bottomstate  limit 3;

-- using union operator
select * from (SELECT * FROM top_states
ORDER BY topstate DESC limit 3 ) T3
UNION
select * from (SELECT * FROM bottom_states
ORDER BY bottomstate  limit 3 ) B3 ;

-- states starting with letter a

select distinct state from data1 where left(lower(state),1) like  ('%a') or left(lower(state),1)  like  ('%b')

-- states starting with a and ending with m

select distinct state from data1 where left(lower(state),1) like  ('%a') and right(lower(state),1)  like  ('%m')


-- total male and female

select d.state, sum(d.males) total_males, sum(d.females) total_females from 
(select c.state, c.district , round(population/(sex_ratio+1),0) males , round((population*sex_ratio)/(sex_ratio+1),0) females
 from
(select data1.district, data1.state, sex_ratio, population from data1 inner join data2 on data1.district = data2.district) c  )d
group by d.state


-- total literacy rates

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from data1 a 
inner join data2 b on a.district=b.district) d) c
group by c.state


-- population in previous census


select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from data1 a inner join data2 b on a.district=b.district) d) e
group by e.state)m

-- population vs area
select (g.total_area/g.previous_census_population)  as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from data1 a inner join data2 b on a.district=b.district) d) e
group by e.state)m) n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from data2)z) r on q.keyy=r.keyy)g
























