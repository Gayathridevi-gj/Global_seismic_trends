select * from my_table;
SELECT id, country, time, mag FROM my_table ORDER BY mag DESC LIMIT 10;
SELECT id, country, depth_km, mag, time FROM my_table ORDER BY depth_km DESC LIMIT 10;
SELECT time, country,depth_km, mag
FROM my_table
WHERE 
    depth_km < 50 
    AND mag > 7.5
ORDER BY 
    mag DESC;
    SELECT 
    CASE 
        -- North America roughly
        WHEN latitude BETWEEN 7 AND 85 AND longitude BETWEEN -168 AND -52 THEN 'North America'
        -- South America roughly
        WHEN latitude BETWEEN -56 AND 12 AND longitude BETWEEN -82 AND -34 THEN 'South America'
        -- Europe roughly
        WHEN latitude BETWEEN 34 AND 82 AND longitude BETWEEN -25 AND 60 THEN 'Europe'
        -- Africa roughly
        WHEN latitude BETWEEN -35 AND 38 AND longitude BETWEEN -18 AND 52 THEN 'Africa'
        -- Asia roughly
        WHEN latitude BETWEEN -11 AND 78 AND longitude BETWEEN 26 AND 170 THEN 'Asia'
        -- Oceania / Australia roughly
        WHEN latitude BETWEEN -48 AND 0 AND longitude BETWEEN 110 AND 180 THEN 'Oceania'
        -- Antarctica roughly
        WHEN latitude BETWEEN -90 AND -60 THEN 'Antarctica'
        ELSE 'Other/Ocean'
    END AS continent,
    AVG(depth_km) AS average_depth
FROM 
    my_table
GROUP BY 
    1;
SELECT 
    magtype,
    AVG(mag) AS average_magnitude,
    COUNT(*) AS total_earthquakes
FROM my_table
GROUP BY 
    magType
ORDER BY 
    average_magnitude DESC;
SELECT 
    EXTRACT(YEAR FROM time) AS earthquake_year, 
    COUNT(*) AS total_earthquakes
FROM my_table
GROUP BY 
    earthquake_year
ORDER BY 
    total_earthquakes DESC
LIMIT 1;
SELECT 
    EXTRACT(MONTH FROM time) AS earthquake_month, 
    COUNT(*) AS earthquake_count
FROM my_table
GROUP BY earthquake_month
ORDER BY earthquake_count DESC
LIMIT 5;
SELECT 
    DAYNAME(time) AS day_of_week, 
    COUNT(*) AS earthquake_count
FROM my_table
GROUP BY DAYNAME(time), WEEKDAY(time) -- WEEKDAY helps sort chronologically or just group cleanly
ORDER BY earthquake_count DESC
LIMIT 1;
SELECT EXTRACT(HOUR FROM time) AS hour_of_day,
       COUNT(*) AS earthquake_count
FROM my_table
GROUP BY hour_of_day
ORDER BY hour_of_day;
SELECT 
    network_id, 
    COUNT(*) AS total_reports
FROM 
    reports
GROUP BY 
    network_id
ORDER BY 
    total_reports DESC
LIMIT 1;
SELECT net,
    COUNT(*) AS total_reports
FROM my_table
GROUP BY 
    net
ORDER BY 
    total_reports DESC
LIMIT 1;
SELECT country, sig
FROM my_table
ORDER BY sig DESC
LIMIT 5;
SELECT 
    CASE 
        -- North America roughly
        WHEN latitude BETWEEN 7 AND 85 AND longitude BETWEEN -168 AND -52 THEN 'North America'
        -- South America roughly
        WHEN latitude BETWEEN -56 AND 12 AND longitude BETWEEN -82 AND -34 THEN 'South America'
        -- Europe roughly
        WHEN latitude BETWEEN 34 AND 82 AND longitude BETWEEN -25 AND 60 THEN 'Europe'
        -- Africa roughly
        WHEN latitude BETWEEN -35 AND 38 AND longitude BETWEEN -18 AND 52 THEN 'Africa'
        -- Asia roughly
        WHEN latitude BETWEEN -11 AND 78 AND longitude BETWEEN 26 AND 170 THEN 'Asia'
        -- Oceania / Australia roughly
        WHEN latitude BETWEEN -48 AND 0 AND longitude BETWEEN 110 AND 180 THEN 'Oceania'
        -- Antarctica roughly
        WHEN latitude BETWEEN -90 AND -60 THEN 'Antarctica'
        ELSE 'Other/Ocean'
    END AS continent,
    sum(sig) AS economic_loss
FROM 
    my_table
GROUP BY 
    1;
SELECT 
    alert, 
    AVG(sig) AS economic_loss
FROM my_table
GROUP BY alert
ORDER BY  economic_loss DESC;
SELECT 
    status, 
    COUNT(*) AS earthquake_count
FROM my_table
WHERE 
    status IN ('reviewed', 'automatic')
GROUP BY 
    status;
SELECT event_type, COUNT(*) AS earthquake_count
FROM my_table
GROUP BY event_type
ORDER BY earthquake_count DESC;
SELECT 
    types, 
    COUNT(*) AS earthquake_count
FROM my_table
GROUP BY 
    types
ORDER BY 
    earthquake_count DESC;
 SELECT 
    CASE 
        -- North America roughly
        WHEN latitude BETWEEN 7 AND 85 AND longitude BETWEEN -168 AND -52 THEN 'North America'
        -- South America roughly
        WHEN latitude BETWEEN -56 AND 12 AND longitude BETWEEN -82 AND -34 THEN 'South America'
        -- Europe roughly
        WHEN latitude BETWEEN 34 AND 82 AND longitude BETWEEN -25 AND 60 THEN 'Europe'
        -- Africa roughly
        WHEN latitude BETWEEN -35 AND 38 AND longitude BETWEEN -18 AND 52 THEN 'Africa'
        -- Asia roughly
        WHEN latitude BETWEEN -11 AND 78 AND longitude BETWEEN 26 AND 170 THEN 'Asia'
        -- Oceania / Australia roughly
        WHEN latitude BETWEEN -48 AND 0 AND longitude BETWEEN 110 AND 180 THEN 'Oceania'
        -- Antarctica roughly
        WHEN latitude BETWEEN -90 AND -60 THEN 'Antarctica'
        ELSE 'Other/Ocean'
    END AS continent,
   avg(rms) AS average_rms,avg(gap) AS average_gap
FROM 
    my_table
GROUP BY 
    1;
SELECT 
    id, 
    time, country,
    mag, 
    nst
FROM my_table
WHERE 
    nst IS NOT NULL
ORDER BY 
    nst DESC
LIMIT 10;
SELECT 
    EXTRACT(year FROM time) AS tsunami_year,
    COUNT(*) AS total_tsunamis
FROM my_table
WHERE 
    tsunami = 1
GROUP BY 
   tsunami_year
ORDER BY 
    tsunami_year DESC;
SELECT 
    alert, 
    COUNT(*) AS earthquake_count
FROM my_table
GROUP BY 
    alert
ORDER BY 
    earthquake_count DESC;
SELECT 
    country,
    ROUND(AVG(mag), 2) AS average_magnitude,
    COUNT(*) AS total_earthquakes
FROM my_table
WHERE 
   time >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
    AND mag IS NOT NULL
GROUP BY 
    country
HAVING 
    COUNT(*) >= 5 -- Filters out countries with only one or two isolated anomalies
ORDER BY 
    average_magnitude DESC limit 5;
SELECT 
    country,
    COUNT(*) AS earthquake_count,
    ROUND(AVG(mag), 2) AS avg_magnitude,
    ROUND(COUNT(*) * AVG(mag), 2) AS activity_score
FROM my_table
WHERE country IS NOT NULL 
  AND mag >= 4.0 
GROUP BY country
ORDER BY activity_score DESC
LIMIT 3;
SELECT 
    country,
    COUNT(CASE WHEN depth_km BETWEEN 0 AND 70 THEN 1 END) AS shallow_count,
    COUNT(CASE WHEN depth_km > 300 THEN 1 END) AS deep_count,
    -- Calculate ratio, using NULLIF to prevent division-by-zero errors
    ROUND(
        COUNT(CASE WHEN depth_km BETWEEN 0 AND 70 THEN 1 END) * 1.0 / 
        NULLIF(COUNT(CASE WHEN depth_km > 300 THEN 1 END), 0), 
        2
    ) AS shallow_to_deep_ratio
FROM my_table
WHERE 
    country IS NOT NULL
GROUP BY 
    country
    HAVING 
    COUNT(CASE WHEN depth_km > 300 THEN 1 END) > 0
ORDER BY 
    shallow_to_deep_ratio DESC;
SELECT 
    AVG(CASE WHEN tsunami = 1 THEN mag END) AS avg_mag_with_tsunami,
    AVG(CASE WHEN tsunami = 0 THEN mag END) AS avg_mag_without_tsunami,
    AVG(CASE WHEN tsunami = 1 THEN mag END) - AVG(CASE WHEN tsunami = 0 THEN mag END) AS magnitude_difference
FROM my_table;
SELECT 
    id,
    AVG(gap) AS average_gap,
    AVG(rms) AS average_rms
FROM my_table
GROUP BY 
   id
ORDER BY 
    average_gap DESC, 
    average_rms DESC;
SELECT country, 
    COUNT(*) AS earthquake_count
FROM my_table
WHERE 
    depth_km > 300
GROUP BY 
    country
ORDER BY 
    earthquake_count DESC;




