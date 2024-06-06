-- Create Movies table
CREATE TABLE Movies (
    MovieID SERIAL PRIMARY KEY,
    Title VARCHAR(255),
    Gross VARCHAR(255)
);

-- Create Genres table
CREATE TABLE Genres (
    GenreID SERIAL PRIMARY KEY,
    GenreName VARCHAR(255)
);

-- Create MovieGenres table (many-to-many relationship between Movies and Genres)
CREATE TABLE MovieGenres (
    MovieID INT,
    GenreID INT,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);

-- Create Ratings table
CREATE TABLE Ratings (
    RatingID SERIAL PRIMARY KEY,
    MovieID INT,
    IMDB_Metascore REAL,
    Popcorn_Score REAL,
    Rating VARCHAR(50),
    Tomato_Score REAL,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);
