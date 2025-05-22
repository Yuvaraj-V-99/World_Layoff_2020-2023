use world_layoffs;

select * from layoffs;

-- Remove Duplicates
-- Standardize the data
-- Null values and Blank values
-- Remove any columns

-- Make a Copy of Layoffs table

create table layoff_staging
like layoffs;

insert layoff_staging
select *
from layoffs;

select * 
from layoff_staging;

-- Indentify the  Duplicates

select * ,
Row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off,`date`) as row_num
from layoff_staging;

with duplicate_cte as
(select * ,
Row_number() over(
partition by company, location,industry, total_laid_off, percentage_laid_off,`date`, stage,funds_raised_millions) as row_num
from layoff_staging
)
select * 
from duplicate_cte
where row_num >1
;

select *
from layoff_staging
where company= 'Casper';

-- We have 5 duplicate entry in this table,  we can't do delete in this table because our layoff_staging table in CTE.
-- So we have to create a table as layoff_staging2 with addition of row_num column. We perform this click the table layoff_staging copy to clipboard and select the create statement and paste it. 

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoff_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
as row_num
from layoff_staging;

select *
from layoff_staging2
where row_num>1
;

delete 
from layoff_staging2
where row_num>1;

-- Standardizing data

select company, trim(company)
from layoff_staging2;

update layoff_staging2
set company= Trim(company);

-- Trim white space

select industry, Trim(industry)
from layoff_staging2;

update layoff_staging2
set industry= Trim(industry);

-- Remove duplicate values and find Null and Blanks

select distinct industry 
from layoff_staging2
order by 1;

select * 
from layoff_staging2
where industry like 'crypto%';

-- Update the values Crypto Currency and CryptoCurrency by Crypto, its Exactly same meaning.

update layoff_staging2
set industry ='Crypto'
where industry like 'Crypto%'
;

select distinct industry 
from layoff_staging2;

select distinct location 
from layoff_staging2
order by 1;

select distinct country 
from layoff_staging2
order by 1;

update layoff_staging2
set country = 'USA'
where country like 'United States%'
;

-- Change Data Type Text to Date fromat
select `date`,
str_to_date(`date`,'%m/%d/%Y') `Date`
from layoff_staging2;

update layoff_staging2
set `date` =str_to_date(`date`,'%m/%d/%Y');

alter table layoff_staging2
modify column `date`date;

-- Indentify the Null value and Blanks

update layoff_staging2
set industry = Null
where industry =''
;

select *
from layoff_staging2 t1
join layoff_staging2 t2
	on t1.company=t2.company
where (t1.industry is null or t1.industry ='')
and t2.industry is not null;

update layoff_staging2 t1
join layoff_staging2 t2
	on t1.company=t2.company
set t1.industry= t2.industry
where t1.industry is null 
and t2.industry is not null;

select distinct industry 
from layoff_staging2
order by  1;

select *
from layoff_staging2
where company like 'Bally%'
;

select *
from layoff_staging2
where industry is Null
or industry ='';


select * 
from layoff_staging2;

select * 
from layoff_staging2
where total_laid_off is Null
and percentage_laid_off is Null
;

delete
from layoff_staging2
where total_laid_off is Null
and percentage_laid_off is Null
;

alter table layoff_staging2
drop column row_num;