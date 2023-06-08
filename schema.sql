/* Database schema to keep the structure of entire database. */

CREATE TABLE animals( 
    id integer NOT NULL,
    name varchar(100)
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weight_kg numeric,
    CONSTRAINT animals_pkey PRIMARY KEY (id)
)

ALTER TABLE animals
ADD COLUMN species VARCHAR(50);
;

--Craete owners table
CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255),
  age INTEGER
);

--Create species table
CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

--Modify animals table
DROP COLUMN species,
ADD COLUMN species_id INTEGER REFERENCES species(id),
ADD COLUMN owner_id INTEGER REFERENCES owners(id),
ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;

-- Create vets table
CREATE TABLE vets(
	id INT GENERATED ALWAYS AS IDENTITY,
	name varchar(200),
	age INT,
    graduation_date DATE,
	PRIMARY KEY(id)
);


-- Create specializations table
CREATE TABLE specializations(
	id INT GENERATED ALWAYS AS IDENTITY,
	vet_id INT REFERENCES vets(id),
	species_id INT REFERENCES species(id),
	PRIMARY KEY(id)
);

-- Create visits table

BEGIN;

ALTER TABLE animals ADD CONSTRAINT animals_id_unique UNIQUE (id);

COMMIT;

CREATE TABLE visits(
	id INT GENERATED ALWAYS AS IDENTITY,
	vet_id INT REFERENCES vets(id),
	animal_id INT REFERENCES animals(animalid),
    date DATE,
	PRIMARY KEY(id)
);