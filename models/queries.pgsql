DELETE FROM broadcasts ;

INSERT INTO broadcasts (broadcast) VALUES ('{"no":"no val"}');

SELECT * FROM "broadcasts" LIMIT 1000;