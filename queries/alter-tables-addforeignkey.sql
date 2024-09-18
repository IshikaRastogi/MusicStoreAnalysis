-- 1. Album table (artist_id references artist)
ALTER TABLE album
ADD CONSTRAINT fk_album_artist FOREIGN KEY (artist_id) REFERENCES artist(artist_id)

-- 2. Track table (album_id references album, mediatype_id references mediatype, genre_id references genre)
ALTER TABLE track
ADD CONSTRAINT fk_track_album FOREIGN KEY (album_id) REFERENCES album(album_id),
ADD CONSTRAINT fk_track_mediatype FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id),
ADD CONSTRAINT fk_track_genre FOREIGN KEY (genre_id) REFERENCES genre(genre_id)

-- 3. InvoiceLine table (invoice_id references invoice, track_id references track)
ALTER TABLE invoice_line
ADD CONSTRAINT fk_invoiceline_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
ADD CONSTRAINT fk_invoiceline_track FOREIGN KEY (track_id) REFERENCES track(track_id)

-- 4. Invoice table (customer_id references customer)
ALTER TABLE invoice
ADD CONSTRAINT fk_invoice_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id);

-- 5. Customer table (support_rep_id references employee)
ALTER TABLE customer
ALTER COLUMN support_rep_id TYPE VARCHAR USING support_rep_id::VARCHAR;

ALTER TABLE customer
ADD CONSTRAINT fk_customer_support_rep FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id);

-- 6. PlaylistTrack table (playlist_id references playlist, track_id references track)
ALTER TABLE playlist_track
ADD CONSTRAINT fk_playlisttrack_playlist FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
ADD CONSTRAINT fk_playlisttrack_track FOREIGN KEY (track_id) REFERENCES track(track_id);

-- 7. Employee table (reportsto references employee itself for hierarchy)
ALTER TABLE employee
ADD CONSTRAINT fk_employee_reportsto FOREIGN KEY (reports_to) REFERENCES employee(employee_id);
