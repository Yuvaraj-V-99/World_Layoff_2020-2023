-- Exploratory Data Analysis

select * 
from layoff_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

select *
from layoff_staging2
where percentage_laid_off=1
order by total_laid_off desc;

-- Find the company with thier Total laid off

select company,sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

-- Find the dataset when it will be update and end

select min(`date`),max(`date`)
from layoff_staging2;

select industry, sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

-- We found that which are the company and industry included in this dataset. Then we sperate the year from the "Date" column.

select year(`date`), sum(total_laid_off)
from layoff_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc;

select company, Sum(percentage_laid_off)
from layoff_staging2
group by company
order by 2 desc;

select company, avg(percentage_laid_off)
from layoff_staging2
group by company
order by 2 desc;

-- Then we found Total layoff from the month.

select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoff_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

-- Rolling total with month on month with sperate Column in Rolling Total.

with Rolling_total as 
(select substring(`date`,1,7) as `Month`, 
sum(total_laid_off) as total_off
from layoff_staging2
where substring(`date`,1,7) is not null
group by `Month` 
order by 1 asc
)
select `Month`, total_off,
sum(total_off) over(order by `Month`) as Rolling_total
from Rolling_total;

select company, year(`date`), sum(total_laid_off)
from layoff_staging2
group by company, year(`date`)
order by  3 desc;

-- Then we analyse and Ranking the company with "Total laid off" by "Year"

with Company_year (company, years, total_laid_off)as
(select company, year(`date`), sum(total_laid_off)
from layoff_staging2
group by company,year(`date`)
),Company_year_rank as
(select *, dense_rank()  over( partition by  years order by total_laid_off desc) Ranking
from Company_year
where years is not null
)
select * 
from Company_year_rank
where Ranking<= 5
;