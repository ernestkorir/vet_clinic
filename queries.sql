/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN;

UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;

BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

SELECT species from animals;

COMMIT;

SELECT species from animals;

BEGIN;

DELETE FROM animals;

ROLLBACK;

SELECT * FROM animals;


BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT my_savepoint;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO my_savepoint;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

SELECT COUNT(*) FROM animals;

SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT name, neutered, escape_attempts
FROM animals
WHERE escape_attempts = (
    SELECT MAX(escape_attempts)
    FROM animals
    )

SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) as avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- What animals belong to Melody Pond?
SELECT * FROM animals 
JOIN owners ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon)
SELECT * FROM animals 
JOIN species ON animals.species_id = species.id 
WHERE species.name = 'Pokemon';

-- List all owners and their animals
SELECT owners.full_name, animals.name 
FROM owners 
LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(*) AS animal_count 
FROM animals 
JOIN species ON animals.species_id = species.id 
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell
SELECT animals.name 
FROM animals 
JOIN owners ON animals.owner_id = owners.id 
JOIN species ON animals.species_id = species.id 
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT * FROM animals 
JOIN owners ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name, COUNT(*) AS animal_count 
FROM animals 
JOIN owners ON animals.owner_id = owners.id 
GROUP BY owners.full_name 
ORDER BY COUNT(*) DESC 

-- Who was the last animal seen by William Tatcher?
SELECT A.name, vets.name, V.date
FROM visits V
JOIN animals A
ON V.animal_id = A.animalid
JOIN vets
ON V.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY V.date DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT V.name, COUNT(animals.animalid) AS "TOTAL ANIMALS"
FROM visits
JOIN animals
ON visits.animal_id = animals.animalid
JOIN vets V
ON visits.vet_id = V.id
WHERE V.name = 'Stephanie Mendez'
GROUP BY V.name;


-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name
FROM vets
LEFT JOIN specializations
ON vets.id = specializations.vet_id
LEFT JOIN species
ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vets.name, animals.name, visits.date
FROM animals
JOIN visits
ON visits.animal_id = animals.animalid
JOIN vets
ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez' AND visits.date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.animal_id) AS VISITS
FROM animals
JOIN visits
ON animals.animalid = visits.animal_id
GROUP BY animals.name
ORDER BY VISITS DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT A.name, vets.name, V.date
FROM visits V
JOIN animals A
ON V.animal_id = A.animalid
JOIN vets
ON V.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
ORDER BY V.date ASC LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.* AS ANIMAL_INFORMATION, vets.* AS VET_INFORMATION, visits.date
FROM animals
JOIN visits
ON animals.animalid = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
ORDER BY visits.date DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS "VISITS TO VETS NOT SPECIALISED IN THAT SPECIES"
FROM visits
JOIN vets
ON visits.vet_id = vets.id
JOIN animals
ON visits.animal_id = animals.animalid
LEFT JOIN specializations
ON vets.id = specializations.vet_id AND animals.species_id = specializations.species_id
WHERE specializations.species_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT MAX(species.name) AS "SPECIES MAISY SHOULD CONSIDER"
FROM animals
JOIN visits
ON animals.animalid = visits.animal_id
JOIN species
ON animals.species_id = species.id
WHERE visits.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
GROUP BY species.id ORDER BY COUNT(*) DESC LIMIT 1;