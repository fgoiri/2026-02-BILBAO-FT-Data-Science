-- Obtener los clientes de Brasil
SELECT *
FROM customers
WHERE country == 'Brazil';

-- Obtener los empleados que son agentes de ventas
SELECT *
FROM employees
WHERE Title == 'Sales Support Agent';

-- Obtener las canciones de ‘AC/DC’
SELECT *
FROM tracks
WHERE Composer == 'AC/DC';

-- Obtener los campos de los clientes que no sean de USA: Nombre completo, ID, País
SELECT customers.FirstName, customers.LastName, customers.CustomerId, customers.Country
FROM customers
WHERE Country != 'USA';

--  Obtener los empleados que son agentes de ventas: Nombre completo, Dirección (Ciudad, Estado, País) y email
SELECT employees.FirstName, employees.LastName, employees.Address, employees.City, employees.State, employees.Country, employees.Email
FROM employees
WHERE Title == 'Sales Support Agent';

-- Obtener una lista con los países no repetidos a los que se han emitido facturas
SELECT DISTINCT invoices.BillingCountry
FROM invoices;

-- Obtener una lista con los estados de USA no repetidos de donde son los clientes y cuántos clientes en cada uno.
SELECT customers.State, count(customers.CustomerId)
FROM customers
WHERE Country == 'USA'
GROUP BY State;

-- Cuántos artículos tiene la factura 37
SELECT invoice_items.InvoiceId, SUM(invoice_items.Quantity)
FROM invoice_items
WHERE invoice_items.InvoiceId == 37;

-- Cuántas canciones tiene ‘AC/DC'
SELECT artists.Name, count(tracks.Name)
FROM tracks
    INNER JOIN albums ON tracks.AlbumId = albums.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
WHERE artists.Name == 'AC/DC';

--Cuántos artículos tiene cada factura
SELECT invoice_items.InvoiceId, sum(invoice_items.Quantity) AS Quantity
FROM invoice_items
GROUP BY invoice_items.InvoiceId
ORDER BY Quantity DESC;

-- Cuántas facturas hay de cada país
SELECT invoices.BillingCountry, count(invoices.InvoiceId) AS Numero_Facturas
FROM invoices
GROUP BY invoices.BillingCountry;

--Cuántas facturas ha habido en 2009 y 2011
SELECT strftime("%Y", invoicedate) AS Año, count(invoices.InvoiceId) AS Numero_facturas
FROM invoices
WHERE Año IN ('2009','2011')
GROUP BY Año;

-- Cuántas facturas ha habido entre 2009 y 2011
SELECT strftime("%Y", invoicedate) AS Año, count(invoices.InvoiceId) AS Numero_facturas
FROM invoices
WHERE Año BETWEEN '2009' AND '2011'
GROUP BY Año;

-- Cuántas clientes hay de España y de Brasil
SELECT customers.Country, count(customers.CustomerId)
FROM customers
WHERE customers.Country IN ('Spain','Brazil')
GROUP BY Country;

-- Obtener las canciones que su título empieza por ‘You’
SELECT tracks.Name
FROM tracks
WHERE tracks.Name LIKE "You%";

-- Facturas de Clientes de Brasil, Nombre del cliente, Id de factura, fecha de la factura y el país de la factura
SELECT customers.FirstName, customers.LastName, invoices.InvoiceId, invoices.InvoiceDate, invoices.BillingCountry
FROM invoices
    INNER JOIN customers ON invoices.CustomerId = customers.CustomerId
WHERE customers.Country = 'Brazil';

-- Obtener cada factura asociada a cada agente de ventas con su nombre completo
SELECT invoices.InvoiceId, employees.FirstName, employees.LastName
FROM invoices
    INNER JOIN customers ON invoices.CustomerId = customers.CustomerId
    INNER JOIN employees ON employees.EmployeeId = customers.SupportRepId;
    
-- Obtener el nombre del cliente, el país, el nombre del agente y el total
SELECT customers.FirstName, customers.LastName, customers.Country, employees.FirstName, employees.LastName, invoices.Total
FROM invoices
    INNER JOIN customers ON invoices.CustomerId = customers.CustomerId
    INNER JOIN employees ON employees.EmployeeId = customers.SupportRepId;

--Obtener cada artículo de la factura con el nombre de la canción
SELECT invoice_items.InvoiceId, tracks.Name, tracks.UnitPrice
FROM invoice_items
    INNER JOIN tracks ON tracks.TrackId = invoice_items.TrackId;
    
-- Muestra todas las canciones con su nombre, formato, álbum y género
SELECT tracks.Name, media_types.Name, albums.Title, genres.Name
FROM tracks
    INNER JOIN media_types ON media_types.MediaTypeId = tracks.MediaTypeId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN genres ON genres.GenreId = tracks.GenreId;
    
-- Cuántas canciones hay en cada playlist
SELECT playlists.PlaylistId, playlists.Name, COUNT(playlist_track.PlaylistId) AS Numero_Canciones
FROM playlists
    LEFT JOIN playlist_track ON playlist_track.PlaylistId = playlists.PlaylistId
GROUP BY playlists.PlaylistId, playlists.Name;

-- Cuánto ha vendido cada empleado
SELECT employees.EmployeeId, employees.FirstName, employees.LastName, sum(invoices.Total) AS Total_ventas
FROM invoices
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
    INNER JOIN employees ON employees.EmployeeId = customers.SupportRepId
GROUP BY employees.EmployeeId, employees.FirstName, employees.LastName
ORDER BY Total_ventas DESC;


SELECT employees.EmployeeId, employees.FirstName, employees.LastName, sum(invoices.Total) AS Total_ventas
FROM employees
    LEFT JOIN customers ON customers.SupportRepId = employees.EmployeeId
    LEFT JOIN invoices ON invoices.InvoiceId = customers.CustomerId
GROUP BY employees.EmployeeId, employees.FirstName, employees.LastName
ORDER BY Total_ventas DESC;

-- ¿Quién ha sido el agente de ventas que más ha vendido en 2009?
SELECT employees.EmployeeId, employees.FirstName, employees.LastName, sum(invoices.Total) AS Total_ventas
FROM invoices
    INNER JOIN customers ON customers.CustomerId = invoices.CustomerId
    INNER JOIN employees ON employees.EmployeeId = customers.SupportRepId
WHERE strftime("%Y", invoices.InvoiceDate) = '2009'
GROUP BY employees.EmployeeId, employees.FirstName, employees.LastName
ORDER BY Total_ventas DESC
LIMIT 1;

-- ¿Cuáles son los 3 grupos que más han vendido?
SELECT artists.ArtistId, artists.Name, sum(invoices.Total) as Total_ventas
FROM invoices
    INNER JOIN invoice_items ON invoice_items.InvoiceId = invoices.InvoiceId
    INNER JOIN tracks ON tracks.TrackId = invoice_items.TrackId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
GROUP BY artists.ArtistId, artists.Name
ORDER BY Total_ventas DESC
LIMIT 3;

SELECT artists.ArtistId, artists.Name, sum(invoice_items.Quantity) as Total_ventas
FROM invoice_items
    INNER JOIN tracks ON tracks.TrackId = invoice_items.TrackId
    INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
    INNER JOIN artists ON artists.ArtistId = albums.ArtistId
GROUP BY artists.ArtistId, artists.Name
ORDER BY Total_ventas DESC
LIMIT 3;