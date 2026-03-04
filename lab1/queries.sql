-- Lab 01: Analytical Queries
-- 1. Filtering: High-rated books
SELECT title, rating FROM books_read WHERE rating >= 4.5;

-- 2. Aggregation: Average pages per category
SELECT category, AVG(pages) as avg_pages FROM books_read GROUP BY category;

-- 3. Sorting: Longest books first
SELECT title, pages FROM books_read ORDER BY pages DESC;

-- 4. Date Manipulation: Books read late in the year
SELECT title, date_finished FROM books_read WHERE date_finished >= '2024-10-01';

-- 5. Multi-condition: Long books with high ratings
SELECT title, pages, rating FROM books_read WHERE pages > 500 AND rating >= 4.0;
