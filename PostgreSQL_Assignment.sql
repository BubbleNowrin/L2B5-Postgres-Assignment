-- Active: 1748277074864@@127.0.0.1@5432@conservation_db

--ranger table
create table rangers (
    ranger_id SERIAL primary key,
    name varchar(50) not null,
    region varchar(100) not null
);

--species table
create table species (
    species_id serial primary key,
    common_name varchar(100) not null,
    scientific_name varchar(100) not null,
    discovery_date DATE not null,
    conservation_status varchar(50) not null
);

-- sightings table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers (ranger_id),
    species_id INTEGER REFERENCES species (species_id),
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

-- rangers input
INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

-- species input

INSERT INTO
    species (
        species_id,
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        1,
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        2,
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        3,
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        4,
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

-- sightings input
INSERT INTO
    sightings (
        sighting_id,
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        4,
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

select * from rangers;

select * from species;

select * from sightings;

-- Problem 1
insert into
    rangers (name, region)
values ('Derek Fox', 'Coastal Plains');

-- Problem 2

select count(DISTINCT species_id) as unique_species_count
from sightings;

-- Problem 3

select * from sightings where location ILIKE '%Pass%';

-- Problem 4
SELECT rangers.name, COUNT(sightings.sighting_id) AS total_sightings
FROM rangers
    LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY
    rangers.name;

-- Problem 5

SELECT s.common_name
FROM species s
    LEFT JOIN sightings si ON s.species_id = si.species_id
WHERE
    si.sighting_id IS NULL;

-- Problem 6

SELECT sp.common_name, si.sighting_time, r.name
FROM
    sightings si
    JOIN species sp ON si.species_id = sp.species_id
    JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

-- Problem 7
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    EXTRACT(
        YEAR
        FROM discovery_date
    ) < 1800;

-- Problem 8
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- Problem 9
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );