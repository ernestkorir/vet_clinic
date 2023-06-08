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
CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  age INTEGER,
  date_of_graduation DATE
);

-- Create specializations table
CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets(id),
  species_id INTEGER REFERENCES species(id),
  PRIMARY KEY (vet_id, species_id)
);

-- Create visits table
CREATE TABLE visits (
  animal_id INTEGER REFERENCES animals(id),
  vet_id INTEGER REFERENCES vets(id),
  visit_date DATE,
  PRIMARY KEY (animal_id, vet_id, visit_date)
);